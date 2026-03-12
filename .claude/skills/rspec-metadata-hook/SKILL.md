---
name: rspec-metadata-hook
description: Generate an RSpec metadata-driven hook (before/after/around) in a dedicated support file
---

# RSpec Metadata Hook

When asked to create an RSpec hook that runs only for tests with a specific metadata tag, follow these conventions:

## File placement

- All metadata hooks go in `spec/support/metadata_hooks.rb`.
- Do **not** add hooks directly to `rails_helper.rb` or `spec_helper.rb`.

## Before writing code

1. Check that `spec/support/` exists; create it if not.
2. Verify that `rails_helper.rb` (or `spec_helper.rb`) requires support files. Look for:
   ```ruby
   Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
   ```
   If missing, warn the user that `spec/support/metadata_hooks.rb` won't be loaded automatically. Do not auto-add the require line.
3. Check `spec/support/metadata_hooks.rb` for existing hooks to avoid duplicating a metadata tag.

## Hook templates

### `:before` — setup

For stubbing APIs, seeding data, or configuring state before tagged examples.

```ruby
RSpec.configure do |config|
  config.before(:each, stripe: true) do
    StripeMock.start
  end
end
```

### `:after` — teardown

For cleaning up state after tagged examples.

```ruby
RSpec.configure do |config|
  config.after(:each, stripe: true) do
    StripeMock.stop
  end
end
```

### `:around` — wrapping

For wrapping test execution (e.g., time freezing, VCR cassettes, custom transactions).

```ruby
RSpec.configure do |config|
  config.around(:each, freeze_time: true) do |example|
    travel_to(Time.zone.parse('2026-01-01 12:00:00')) do
      example.run
    end
  end
end
```

Note: `:around` hooks **must** accept `|example|` and call `example.run`.

## File organization

Group hooks by metadata tag with comment headers. Related `:before`/`:after` pairs for the same tag stay together:

```ruby
# -- :stripe --
RSpec.configure do |config|
  config.before(:each, stripe: true) do
    StripeMock.start
  end

  config.after(:each, stripe: true) do
    StripeMock.stop
  end
end

# -- :freeze_time --
RSpec.configure do |config|
  config.around(:each, freeze_time: true) do |example|
    travel_to(Time.zone.parse('2026-01-01 12:00:00')) do
      example.run
    end
  end
end
```

## Key rules

- **Use symbol metadata tags** — in specs write `:stripe`; in `RSpec.configure` the syntax is `stripe: true`.
- **Keep hook bodies small** — extract complex logic into helper methods or modules in `spec/support/helpers/`.
- **Don't redefine built-in metadata** — RSpec reserves `:focus`, `:skip`, `:pending`, and type metadata like `type: :request`. Don't shadow these.
- **Prefer `:each` scope** — use `:each` over `:all` unless there's a clear performance reason. `:all` shares state across examples and causes subtle test pollution.
- **Idempotent hooks** — hooks should be safe to run multiple times. Avoid side effects that accumulate.

## Usage pattern

After creating a hook, show the usage pattern in a comment:

```ruby
# Usage in specs:
#
#   it 'charges the customer', :stripe do
#     # StripeMock is automatically started/stopped
#   end
#
#   describe 'frozen time behavior', :freeze_time do
#     it 'uses the frozen time' do
#       expect(Time.current).to eq(Time.zone.parse('2026-01-01 12:00:00'))
#     end
#   end
```
