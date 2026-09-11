#!/usr/bin/env ruby
# frozen_string_literal: true

# Parse a JUnit XML report from RSpec and output the rspec command to reproduce
# an order-dependent failure. Extracts seed, collects all spec files in execution
# order up to and including the first failure, and deduplicates while preserving
# order.
#
# Usage:
#   bin/reproduce_failure path/to/results.xml
#   bin/reproduce_failure path/to/results.xml --full           # include all files, not just up to failure
#   bin/reproduce_failure path/to/results.xml --focus spec/x.rb  # stop at this file's failure, not the first

require "rexml/document"

xml_path = ARGV.find { |a| !a.start_with?("--") }
full_mode = ARGV.include?("--full")
focus_idx = ARGV.index("--focus")
focus_file = focus_idx && ARGV[focus_idx + 1]&.sub(%r{\A\./}, "")

abort "Usage: #{$PROGRAM_NAME} <junit-xml-path> [--full] [--focus spec/file.rb]" unless xml_path
abort "File not found: #{xml_path}" unless File.exist?(xml_path)

doc = REXML::Document.new(File.read(xml_path))

seed = doc.elements["testsuite/properties/property[@name='seed']"]&.attributes&.[]("value")
abort "No seed found in XML" unless seed

files = []
failure_file = nil

doc.each_element("testsuite/testcase") do |tc|
  file = tc.attributes["file"]&.sub(%r{\A\./}, "")
  next unless file

  files << file

  if !full_mode && tc.elements["failure"]
    # --focus: only stop at the focused file's failure
    if focus_file.nil? || file == focus_file
      failure_file = file
      break
    end
  end
end

# Deduplicate preserving first-seen order
seen = {}
ordered_files = files.each_with_object([]) do |f, acc|
  next if seen[f]

  seen[f] = true
  acc << f
end

warn "Seed: #{seed}"
warn "Files: #{ordered_files.size} (from #{files.size} examples)"
warn "Stopped at: #{failure_file}" if failure_file

puts "bundle exec rspec --seed #{seed} --order defined \\"
ordered_files.each_with_index do |f, i|
  trailing = i < ordered_files.size - 1 ? " \\" : ""
  puts "  #{f}#{trailing}"
end
