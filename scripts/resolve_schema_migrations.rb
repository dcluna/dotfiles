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

require "pathname"
require "optparse"

apply_mode = false
OptionParser.new do |opts|
  opts.on("--apply", "Output only the sorted INSERT block (no mapping)") { apply_mode = true }
end.parse!

given_path = Pathname.new(ARGV[0] || ".")
migrate_dir = if (given_path / "db" / "migrate").directory?
                given_path / "db" / "migrate"
              elsif given_path.directory? && given_path.basename.to_s == "migrate"
                given_path
              else
                given_path
              end

unless migrate_dir.directory?
  warn "Migration directory not found: #{migrate_dir}"
  warn "Pass a Rails root or db/migrate path as first argument."
  exit 1
end

# Parse migration IDs from stdin
input = $stdin.read
ids = input.scan(/(\d{14})/).flatten.uniq

if ids.empty?
  warn "No migration IDs found in input."
  exit 1
end

# Build lookup: id -> filename
migration_files = migrate_dir.children.select(&:file?).map(&:basename).map(&:to_s)
file_by_id = migration_files.each_with_object({}) do |fname, h|
  if fname =~ /^(\d{14})_/
    h[$1] = fname
  end
end

unless apply_mode
  ids.each do |id|
    file = file_by_id[id]
    status = file || "** NO MATCHING FILE **"
    puts "#{id} | #{status}"
  end
  puts "---"
end

sorted = ids.sort
sorted.each_with_index do |id, i|
  suffix = i == sorted.length - 1 ? ";" : ","
  puts "('#{id}')#{suffix}"
end
