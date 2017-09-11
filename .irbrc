if defined? Rails
  puts 'This should only run in rails console!'

  def routes
    # (@route_set ||= ActionDispatch::Routing::RouteSet.new)
    (@route_set ||= begin
      obj = Object.new
      obj.extend Rails.application.routes.url_helpers
      obj
    end).methods.grep /path/
  end

  $LOAD_PATH << '$HOME/.rvm/gems/ruby-2.3.1/gems/colorize-0.7.7/lib'
  $LOAD_PATH << '$HOME/code/httplog/lib/'
  # default_url_options[:host] = 'localhost'
  if Rails.env.test?
    puts 'Use the `migration` variable to access ActiveRecord::Migration methods, such as those available in db/migrate'
    class << self
      def migration
        ActiveRecord::Migration
      end
    end

    require 'factory_girl'
    FactoryGirl.find_definitions
  end
  # require 'hirb'
  # Hirb.enable

  # the following code just sets up rspec_profiling if it works
  results.connection if defined?(results) && results.respond_to?(:connection)

  # require "awesome_print"
  require 'objspace'
  # require 'irbtools'
  # require 'sidekiq/testing/inline'

  if defined?(ActiveRecordQueryTrace)
    ActiveRecordQueryTrace.enabled = true
    # ActiveRecordQueryTrace.colorize = true
    ActiveRecordQueryTrace.lines = 10
  end
end

# taken from http://dalibornasevic.com/posts/51-tracing-ruby-code (a bit improved upon)
def trace(filename = '/tmp/trace', event_types = [:call, :return], *matchers)
  points = []

  tracer = TracePoint.new(*event_types) do |trace_point|
    if matchers.all? { |match| trace_point.path.match(match) }
      points << { event: trace_point.event,
                  file: trace_point.path, line: trace_point.lineno,
                  class: trace_point.defined_class,
                  method: trace_point.method_id }.merge(
        trace_point.event == :return ? { return: trace_point.return_value } : {}
      )
    end
  end

  result = tracer.enable { yield }

  File.open("#{filename}.rb_trace", 'w') do |file|
    points.each do |point|
      event_prefix = point[:event] == :return ? 'return' : 'call'
      return_value = point[:return] ? "(#{point[:return]})" : ''
      file.puts "#{point[:file]}:#{point[:line]}:#{event_prefix} #{point[:class]}##{point[:method]} #{return_value}"
    end
  end

  result
end

require 'tracer'
Tracer.stdout = File.open('/tmp/tracer_output.rb_trace', 'a')
