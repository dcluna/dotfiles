---
name: rails-sidekiq-job
description: Generate a Sidekiq background job for a Rails application
---

# Rails Sidekiq Job

When asked to create a Sidekiq job, follow these conventions:

## File placement

- Job classes go in `app/jobs/`. If it does not exist, use `rails generate sidekiq:job`.
- Name the file using snake_case matching the class name: `hard_worker_job.rb` for `HardWorkerJob`.
- Corresponding specs go in `spec/jobs/`.

## Before writing code

1. Check the project for existing Sidekiq jobs to match local conventions (directory, base class, naming).
2. Check `Gemfile` to confirm `sidekiq` is present and note the major version (API differs between v6 and v7+).
3. Check for a `config/sidekiq.yml` to understand queue configuration.

## Job class structure

```ruby
class HardWorkerJob
  include Sidekiq::Job

  # Only set options that differ from defaults
  sidekiq_options queue: 'default', retry: 5

  def perform(record_id)
    # Always pass simple, serializable arguments (strings, integers, booleans).
    # NEVER pass full Ruby objects — they won't serialize properly.
    record = Record.find(record_id)
    # ... do work
  end
end
```

## Key rules

- **Use `Sidekiq::Job`**, not the deprecated `Sidekiq::Worker` (unless the project is on Sidekiq < 6.3).
- **Keep arguments simple and serializable**: IDs, strings, numbers, booleans, small hashes/arrays. Never pass ActiveRecord objects, symbols, or complex Ruby objects.
- **Make jobs idempotent**: The same job may run more than once. Use database constraints, `find_or_create_by`, or idempotency keys to avoid duplicate side effects.
- **Handle missing records gracefully**: Use `find_by` + early return or rescue `ActiveRecord::RecordNotFound` if the record may be deleted before the job runs.
- **Keep `perform` focused**: One job, one responsibility. Extract complex logic into service objects or model methods.
- **Set `sidekiq_options`** only when needed (non-default queue, custom retry count, `unique` if using sidekiq-unique-jobs, etc.).

## Retry and error handling

- Sidekiq retries failed jobs automatically (default: 25 times with exponential backoff).
- Set `retry: false` for jobs that should not retry (e.g., sending notifications where duplicates are harmful).
- Use `sidekiq_retry_in` to customize backoff if needed.
- For dead-letter handling, implement `sidekiq_retries_exhausted` block.

```ruby
sidekiq_retries_exhausted do |job, exception|
  Rails.logger.error("Job #{job['jid']} exhausted: #{exception.message}")
end
```

## Testing (RSpec)

```ruby
require 'rails_helper'

RSpec.describe HardWorkerJob do
  describe '#perform' do
    it 'processes the record' do
      record = create(:record)
      described_class.new.perform(record.id)
      # assert expected side effects
    end
  end

  describe 'enqueuing' do
    it 'enqueues the job' do
      expect {
        described_class.perform_async(1)
      }.to change(described_class.jobs, :size).by(1)
    end
  end
end
```

- Use `require 'sidekiq/testing'` and `Sidekiq::Testing.fake!` (usually already configured in `rails_helper.rb`).
- Test the `perform` method directly for unit tests (call `.new.perform(args)`).
- Test enqueuing separately when needed.

## Processing large scopes in batches

When a job operates on a potentially large ActiveRecord scope, **never** load all records at once or write custom batch-looping code. Use Rails' built-in `find_each` or `find_in_batches` instead.

### `find_each` — process records one at a time

Use when each record needs individual handling:

```ruby
class BackfillAvatarsJob
  include Sidekiq::Job

  def perform
    User.where(avatar: nil).find_each do |user|
      user.generate_avatar!
    end
  end
end
```

### `find_in_batches` — process records in groups

Use when you can operate on a batch as a whole (e.g., bulk delete, bulk insert, bulk API call):

```ruby
class DeleteTrashCartEnrollmentsJob
  include Sidekiq::Job

  def perform
    Enrollment.removed_from_cart.find_in_batches do |batch|
      batch.each(&:delete)
    end
  end
end
```

### Why not a custom loop?

A manual `loop { break if scope.limit(N).delete_all < N }` pattern is fragile and harder to read. `find_in_batches` handles batching, ordering, and cursor tracking automatically. It also avoids loading the entire scope into memory.

### Key options

- `batch_size:` — number of records per batch (default: 1000). Tune based on memory and query load.
- `find_each` and `find_in_batches` order by primary key by default. They do **not** support custom `order()` — if you need a specific order, use `in_batches` (Rails 5+) with `.each_record` instead.

### `in_batches` — when you need the relation, not the array

`in_batches` yields an `ActiveRecord::Relation` per batch, which lets you call scope methods like `update_all` or `delete_all` directly:

```ruby
class PurgeOldRecordsJob
  include Sidekiq::Job

  def perform
    AuditLog.where("created_at < ?", 1.year.ago).in_batches do |batch|
      batch.delete_all
    end
  end
end
```

This is the most efficient approach for bulk deletes and updates since it never instantiates ActiveRecord objects.

## Scheduling / Cron

If the job needs to run on a schedule, check if the project uses `sidekiq-cron` or `sidekiq-scheduler`, then add the entry to the appropriate config (usually `config/sidekiq_cron.yml` or `config/sidekiq.yml`).

## Batches and bulk enqueuing

- For enqueuing many jobs at once, use `Sidekiq::Client.push_bulk` instead of calling `perform_async` in a loop.
- If the project has Sidekiq Pro/Enterprise, use `Sidekiq::Batch` for coordinated workflows.

## Throttling with sidekiq-throttled

Use `sidekiq-throttled` to prevent jobs from overwhelming the database or external services. Check that the gem is in the `Gemfile`; if not, ignore this.

### Concurrency limit

Restricts how many jobs of this class run at the same time:

```ruby
class ImportRecordsJob
  include Sidekiq::Job
  include Sidekiq::Throttled::Job

  sidekiq_throttle(
    concurrency: { limit: 5 }
  )

  def perform(record_id)
    # At most 5 of these jobs run in parallel
  end
end
```

### Rate limit (threshold)

Caps how many jobs execute within a time window:

```ruby
class ApiSyncJob
  include Sidekiq::Job
  include Sidekiq::Throttled::Job

  sidekiq_throttle(
    threshold: { limit: 100, period: 1.minute }
  )

  def perform(resource_id)
    # Max 100 executions per minute
  end
end
```

### Combined concurrency + threshold

```ruby
class HeavyQueryJob
  include Sidekiq::Job
  include Sidekiq::Throttled::Job

  sidekiq_throttle(
    concurrency: { limit: 3 },
    threshold:   { limit: 60, period: 1.minute }
  )

  def perform(query_id)
    # At most 3 concurrent, and no more than 60 per minute
  end
end
```

### Dynamic limits with key_suffix

Scope throttles per-resource (e.g., per-account) so one noisy tenant doesn't starve others:

```ruby
sidekiq_throttle(
  concurrency: {
    limit:      2,
    key_suffix: ->(account_id, _opts) { account_id }
  }
)

def perform(account_id, opts = {})
  # Each account limited to 2 concurrent jobs
end
```

### When to use throttling

- Jobs that run heavy database queries (reports, bulk imports/exports).
- Jobs that call rate-limited external APIs.
- Fan-out scenarios where thousands of jobs enqueue at once and would spike DB connections.
