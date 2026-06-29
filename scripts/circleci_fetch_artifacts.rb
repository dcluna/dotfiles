#!/usr/bin/env ruby
# frozen_string_literal: true

# Fetches test artifacts (results.xml) from a CircleCI job given its URL.
#
# Usage:
#   ruby scripts/circleci_fetch_artifacts.rb URL [--output-dir DIR]
#
# Example:
#   ruby scripts/circleci_fetch_artifacts.rb \
#     https://app.circleci.com/pipelines/github/homeroom/api/34656/workflows/809259ad-270f-4da7-9049-de0c7cc2d364/jobs/96305/tests
#
# Requires:
#   - CIRCLECI_TOKEN env var or token in ~/.circleci/cli.yml
#
# Stores artifacts under:
#   {output_dir}/{repo}/{slugified-test-name-or-job-number}/
#     results.xml
#     metadata.json

require "json"
require "net/http"
require "uri"
require "pathname"
require "fileutils"
require "time"
require "yaml"
require "optparse"

module CircleCIFetcher
  module_function

  URL_PATTERN = %r{
    https://app\.circleci\.com/pipelines/
    (?<vcs>github|gh|bitbucket|bb)/
    (?<org>[^/]+)/
    (?<repo>[^/]+)/
    (?<pipeline>\d+)/
    workflows/
    (?<workflow>[^/]+)/
    jobs/
    (?<job_number>\d+)
  }x

  def parse_url(url)
    match = URL_PATTERN.match(url)
    raise ArgumentError, "Cannot parse CircleCI URL: #{url}" unless match

    {
      vcs: match[:vcs],
      org: match[:org],
      repo: match[:repo],
      pipeline: match[:pipeline],
      workflow: match[:workflow],
      job_number: match[:job_number]
    }
  end

  def resolve_token
    token = ENV["CIRCLECI_TOKEN"]
    return token if token && !token.empty?

    cli_config = Pathname.new(Dir.home) / ".circleci" / "cli.yml"
    if cli_config.exist?
      config = YAML.safe_load(cli_config.read)
      token = config&.dig("token")
      return token if token && !token.empty?
    end

    raise "No CircleCI token found. Set CIRCLECI_TOKEN or configure ~/.circleci/cli.yml"
  end

  def api_get(path, token)
    uri = URI("https://circleci.com/api/v2#{path}")
    req = Net::HTTP::Get.new(uri)
    req["Circle-Token"] = token
    req["Accept"] = "application/json"

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end

    unless response.is_a?(Net::HTTPSuccess)
      raise "API request failed: #{response.code} #{response.body}"
    end

    JSON.parse(response.body)
  end

  def fetch_all_pages(path, token, item_key: "items")
    items = []
    next_token = nil

    loop do
      separator = path.include?("?") ? "&" : "?"
      paginated_path = next_token ? "#{path}#{separator}page-token=#{next_token}" : path
      data = api_get(paginated_path, token)
      items.concat(data[item_key] || [])
      next_token = data["next_page_token"]
      break if next_token.nil? || next_token.empty?
    end

    items
  end

  VCS_SLUG = { "github" => "gh", "gh" => "gh", "bitbucket" => "bb", "bb" => "bb" }.freeze

  def project_slug(params)
    "#{VCS_SLUG.fetch(params[:vcs])}/#{params[:org]}/#{params[:repo]}"
  end

  def fetch_test_metadata(params, token)
    slug = project_slug(params)
    fetch_all_pages("/project/#{slug}/#{params[:job_number]}/tests", token)
  end

  def fetch_artifacts(params, token)
    slug = project_slug(params)
    fetch_all_pages("/project/#{slug}/#{params[:job_number]}/artifacts", token)
  end

  def download_file(url, dest, token)
    uri = URI(url)
    req = Net::HTTP::Get.new(uri)
    req["Circle-Token"] = token

    Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
      response = http.request(req)

      # Follow redirect
      if response.is_a?(Net::HTTPRedirection)
        redirect_uri = URI(response["location"])
        redirect_req = Net::HTTP::Get.new(redirect_uri)
        response = Net::HTTP.start(redirect_uri.hostname, redirect_uri.port,
                                   use_ssl: redirect_uri.scheme == "https") do |rhttp|
          rhttp.request(redirect_req)
        end
      end

      File.binwrite(dest, response.body)
    end
  end

  def slugify(text)
    text.gsub(/[^a-zA-Z0-9_\-]/, "_").gsub(/_+/, "_").gsub(/\A_|_\z/, "")[0, 120]
  end

  def directory_name_from_tests(tests)
    failed = tests.select { |t| t["result"] == "failure" }
    return nil if failed.empty?

    first = failed.first
    name = first["name"] || first["classname"] || first["file"]
    return nil unless name

    slugify(name)
  end

  def run(url, output_dir:)
    params = parse_url(url)
    token = resolve_token

    warn "Fetching test metadata for job #{params[:job_number]}..."
    tests = fetch_test_metadata(params, token)

    warn "Fetching artifacts list..."
    artifacts = fetch_artifacts(params, token)

    test_name = directory_name_from_tests(tests) || "job-#{params[:job_number]}"
    dest_dir = Pathname.new(output_dir) / params[:repo] / params[:workflow] / test_name
    FileUtils.mkdir_p(dest_dir)

    # Download XML artifacts (results.xml, junit.xml, etc.)
    xml_artifacts = artifacts.select { |a| a["path"] =~ /\.(xml|junit)$/i }

    if xml_artifacts.empty?
      warn "No XML artifacts found. Downloading all artifacts."
      xml_artifacts = artifacts
    end

    seen_paths = Hash.new(0)
    xml_artifacts.each do |artifact|
      path = artifact["path"]
      count = seen_paths[path]
      seen_paths[path] += 1

      if count > 0
        ext = File.extname(path)
        base = path.chomp(ext)
        path = "#{base}_#{count}#{ext}"
      end

      dest = dest_dir / path
      FileUtils.mkdir_p(dest.dirname)
      warn "  Downloading #{artifact["path"]} -> #{dest}"
      download_file(artifact["url"], dest.to_s, token)
    end

    # Write metadata
    metadata = {
      url: url,
      params: params,
      fetched_at: Time.now.iso8601,
      failed_tests: tests.select { |t| t["result"] == "failure" }.map { |t|
        { name: t["name"], classname: t["classname"], file: t["file"], message: t["message"] }
      },
      artifact_count: xml_artifacts.size
    }
    File.write(dest_dir / "metadata.json", JSON.pretty_generate(metadata))

    warn "Done. Artifacts stored in #{dest_dir}"
    puts dest_dir.to_s
  end
end

if $0 == __FILE__
  output_dir = File.join(Dir.home, ".local", "share", "circleci-artifacts")

  OptionParser.new do |opts|
    opts.banner = "Usage: #{$0} URL [options]"
    opts.on("--output-dir DIR", "Output directory (default: #{output_dir})") { |d| output_dir = d }
  end.parse!

  url = ARGV[0]
  unless url
    warn "Usage: #{$0} URL [--output-dir DIR]"
    exit 1
  end

  CircleCIFetcher.run(url, output_dir: output_dir)
end

return if $0 == __FILE__

require "minitest/autorun"

class CircleCIFetcherTest < Minitest::Test
  def test_parse_url_github
    url = "https://app.circleci.com/pipelines/github/homeroom/api/34656/workflows/809259ad-270f-4da7-9049-de0c7cc2d364/jobs/96305/tests"
    params = CircleCIFetcher.parse_url(url)

    assert_equal "github", params[:vcs]
    assert_equal "homeroom", params[:org]
    assert_equal "api", params[:repo]
    assert_equal "34656", params[:pipeline]
    assert_equal "809259ad-270f-4da7-9049-de0c7cc2d364", params[:workflow]
    assert_equal "96305", params[:job_number]
  end

  def test_parse_url_gh_shortform
    url = "https://app.circleci.com/pipelines/gh/homeroom/api/34234/workflows/24ab5681-141f-487f-874a-ae8d6b6d2999/jobs/95261/artifacts"
    params = CircleCIFetcher.parse_url(url)

    assert_equal "gh", params[:vcs]
    assert_equal "homeroom", params[:org]
    assert_equal "api", params[:repo]
    assert_equal "95261", params[:job_number]
    assert_equal "gh/homeroom/api", CircleCIFetcher.project_slug(params)
  end

  def test_parse_url_without_tests_suffix
    url = "https://app.circleci.com/pipelines/github/myorg/myrepo/100/workflows/abc-123/jobs/555"
    params = CircleCIFetcher.parse_url(url)

    assert_equal "myorg", params[:org]
    assert_equal "myrepo", params[:repo]
    assert_equal "555", params[:job_number]
  end

  def test_parse_url_invalid
    assert_raises(ArgumentError) { CircleCIFetcher.parse_url("https://google.com") }
  end

  def test_project_slug_github
    params = { vcs: "github", org: "homeroom", repo: "api" }
    assert_equal "gh/homeroom/api", CircleCIFetcher.project_slug(params)
  end

  def test_project_slug_bitbucket
    params = { vcs: "bitbucket", org: "myorg", repo: "myrepo" }
    assert_equal "bb/myorg/myrepo", CircleCIFetcher.project_slug(params)
  end

  def test_slugify
    assert_equal "some_test_name_here", CircleCIFetcher.slugify("some test name here")
    assert_equal "foo_bar_baz", CircleCIFetcher.slugify("foo//bar..baz")
    assert_equal "clean", CircleCIFetcher.slugify("__clean__")
  end

  def test_directory_name_from_tests_with_failures
    tests = [
      { "result" => "success", "name" => "good test" },
      { "result" => "failure", "name" => "UserAuth#login fails with bad password" }
    ]
    assert_equal "UserAuth_login_fails_with_bad_password", CircleCIFetcher.directory_name_from_tests(tests)
  end

  def test_directory_name_from_tests_no_failures
    tests = [{ "result" => "success", "name" => "all good" }]
    assert_nil CircleCIFetcher.directory_name_from_tests(tests)
  end

  def test_directory_name_from_tests_empty
    assert_nil CircleCIFetcher.directory_name_from_tests([])
  end

  def test_directory_name_truncated
    long_name = "a" * 200
    result = CircleCIFetcher.slugify(long_name)
    assert result.length <= 120
  end
end
