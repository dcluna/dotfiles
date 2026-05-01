#!/usr/bin/env ruby
# frozen_string_literal: true

# Resolves merge conflicts in structure.sql's schema_migrations block.
#
# Usage:
#   Pipe the conflicted migration entries (or just the version numbers) from stdin:
#
#     pbpaste | ruby scripts/resolve_schema_migrations.rb [path/to/db/migrate]
#
#   Or pass a file:
#
#     ruby scripts/resolve_schema_migrations.rb [path/to/db/migrate] < entries.txt
#
#   Input accepts lines like:
#     ('20260409145728'),
#     ('20260423170000');
#     20260409145728
#
#   The migrate directory defaults to db/migrate in the current working directory.
#
#   Migrations without a matching file are shown in the summary but excluded
#   from the sorted INSERT block.

require "pathname"
require "optparse"

module MigrationResolver
  module_function

  def parse_ids(input)
    input.scan(/(\d{14})/).flatten.uniq
  end

  def build_file_lookup(migrate_dir)
    migrate_dir.children.select(&:file?).map(&:basename).map(&:to_s)
      .each_with_object({}) do |fname, h|
        h[$1] = fname if fname =~ /^(\d{14})_/
      end
  end

  def resolve_migrate_dir(given_path)
    if (given_path / "db" / "migrate").directory?
      given_path / "db" / "migrate"
    elsif given_path.directory? && given_path.basename.to_s == "migrate"
      given_path
    else
      given_path
    end
  end

  def mapping_lines(ids, file_by_id)
    ids.map do |id|
      file = file_by_id[id]
      status = file || "** NO MATCHING FILE **"
      "#{id} | #{status}"
    end
  end

  def sorted_insert_block(ids, file_by_id)
    matched = ids.select { |id| file_by_id.key?(id) }.sort
    return [] if matched.empty?

    matched.each_with_index.map do |id, i|
      suffix = i == matched.length - 1 ? ";" : ","
      "('#{id}')#{suffix}"
    end
  end

  def format_output(ids, file_by_id, apply_mode: false)
    lines = []
    unless apply_mode
      lines.concat(mapping_lines(ids, file_by_id))
      lines << "---"
    end
    lines.concat(sorted_insert_block(ids, file_by_id))
    lines.join("\n")
  end
end

if $0 == __FILE__
  apply_mode = false
  OptionParser.new do |opts|
    opts.on("--apply", "Output only the sorted INSERT block (no mapping)") { apply_mode = true }
  end.parse!

  given_path = Pathname.new(ARGV[0] || ".")
  migrate_dir = MigrationResolver.resolve_migrate_dir(given_path)

  unless migrate_dir.directory?
    warn "Migration directory not found: #{migrate_dir}"
    warn "Pass a Rails root or db/migrate path as first argument."
    exit 1
  end

  input = $stdin.read
  ids = MigrationResolver.parse_ids(input)

  if ids.empty?
    warn "No migration IDs found in input."
    exit 1
  end

  file_by_id = MigrationResolver.build_file_lookup(migrate_dir)
  puts MigrationResolver.format_output(ids, file_by_id, apply_mode: apply_mode)
end

if $0 == __FILE__ && ARGV.include?("--test")
  # noop — tests run below
elsif defined?(Minitest)
  # loaded by test runner
else
  return unless $0 != __FILE__
end

require "minitest/autorun"
require "tmpdir"
require "fileutils"

class MigrationResolverTest < Minitest::Test
  def setup
    @tmpdir = Dir.mktmpdir
    @migrate_dir = Pathname.new(@tmpdir)
    # Create fake migration files
    %w[
      20260409145728_create_widgets.rb
      20260422170956_remove_course_id_from_photos.rb
      20260423170000_fix_stale_enrollments.rb
      20260423180000_backfill_voucher_deposit.rb
    ].each { |f| FileUtils.touch(@migrate_dir / f) }

    @file_by_id = MigrationResolver.build_file_lookup(@migrate_dir)
  end

  def teardown
    FileUtils.remove_entry(@tmpdir)
  end

  def test_parse_ids_from_sql_format
    input = "('20260409145728'),\n('20260423170000');"
    assert_equal %w[20260409145728 20260423170000], MigrationResolver.parse_ids(input)
  end

  def test_parse_ids_deduplicates
    input = "('20260409145728'),\n('20260409145728');"
    assert_equal %w[20260409145728], MigrationResolver.parse_ids(input)
  end

  def test_parse_ids_from_plain_numbers
    input = "20260409145728\n20260423170000"
    assert_equal %w[20260409145728 20260423170000], MigrationResolver.parse_ids(input)
  end

  def test_build_file_lookup
    assert_equal "20260409145728_create_widgets.rb", @file_by_id["20260409145728"]
    assert_nil @file_by_id["99999999999999"]
  end

  def test_mapping_lines_shows_matched_files
    ids = %w[20260409145728 20260422170956]
    lines = MigrationResolver.mapping_lines(ids, @file_by_id)
    assert_equal 2, lines.length
    assert_match(/create_widgets/, lines[0])
    assert_match(/remove_course_id/, lines[1])
  end

  def test_mapping_lines_shows_no_matching_file
    ids = %w[20260416195406]
    lines = MigrationResolver.mapping_lines(ids, @file_by_id)
    assert_equal ["20260416195406 | ** NO MATCHING FILE **"], lines
  end

  def test_sorted_block_excludes_unmatched_ids
    ids = %w[20260416195406 20260422170956 20260423170000]
    block = MigrationResolver.sorted_insert_block(ids, @file_by_id)
    refute block.any? { |line| line.include?("20260416195406") },
           "Unmatched migration ID should not appear in sorted block"
    assert_equal "('20260422170956'),", block[0]
    assert_equal "('20260423170000');", block[1]
  end

  def test_sorted_block_is_sorted
    ids = %w[20260423180000 20260409145728 20260422170956]
    block = MigrationResolver.sorted_insert_block(ids, @file_by_id)
    plain_ids = block.map { |l| l[/\d{14}/] }
    assert_equal plain_ids.sort, plain_ids
  end

  def test_sorted_block_last_entry_has_semicolon
    ids = %w[20260409145728 20260423170000]
    block = MigrationResolver.sorted_insert_block(ids, @file_by_id)
    assert block.last.end_with?(";")
    assert block.first.end_with?(",")
  end

  def test_format_output_full_mode
    ids = %w[20260416195406 20260422170956 20260423170000]
    output = MigrationResolver.format_output(ids, @file_by_id)
    lines = output.split("\n")
    separator_idx = lines.index("---")
    refute_nil separator_idx, "Output should contain --- separator"
    mapping = lines[0...separator_idx]
    assert mapping.any? { |l| l.include?("NO MATCHING FILE") }
    assert mapping.any? { |l| l.include?("remove_course_id") }
    # Sorted block excludes unmatched
    sorted_lines = lines[(separator_idx + 1)..]
    refute sorted_lines.any? { |l| l.include?("20260416195406") }
  end

  def test_format_output_apply_mode
    ids = %w[20260416195406 20260422170956]
    output = MigrationResolver.format_output(ids, @file_by_id, apply_mode: true)
    refute output.include?("NO MATCHING FILE")
    refute output.include?("---")
    refute output.include?("20260416195406")
    assert output.include?("20260422170956")
  end

  def test_resolve_migrate_dir_from_rails_root
    rails_root = Pathname.new(Dir.mktmpdir)
    FileUtils.mkdir_p(rails_root / "db" / "migrate")
    assert_equal rails_root / "db" / "migrate",
                 MigrationResolver.resolve_migrate_dir(rails_root)
  ensure
    FileUtils.remove_entry(rails_root)
  end
end
