---
name: bisect-failure
description: Bisect order-dependent RSpec failures from JUnit XML reports. Parses XML files to extract seed and file ordering, generates the rspec reproduction command, then runs rspec --bisect to find minimal failing set. Use when user mentions bisect, order-dependent failure, flaky test, JUnit XML, reproducing CI failure, or has XML result files from CI.
---

# Bisect Failure

Reproduce and minimize order-dependent RSpec failures from CI JUnit XML reports.

## Workflow

### 1. Locate XML files

Ask user for XML file paths if not provided. Files are JUnit XML reports from CI.

### 2. Generate reproduction command

For each XML file, run:

```bash
ruby ~/ghq/github.com/dcluna/dotfiles/homeroom/scripts/reproduce_failure.rb <xml-path>
```

This outputs a `bundle exec rspec --seed N --order defined file1 file2 ...` command.

If `--full` mode needed (all files, not just up-to-failure), append `--full`.

Show the user the generated command, then proceed to confirm reproduction.

### 3. Confirm reproduction

Run the generated rspec command to verify the failure reproduces locally.

If it does NOT reproduce, tell the user and stop. Do not proceed to bisect.

### 4. Bisect

Run `rspec --bisect` using the same seed and files:

```bash
bundle exec rspec --bisect --seed <seed> --order defined <files...>
```

This is long-running. Use `run_in_background` or `timeout: 600000`.

Report the minimal reproduction set when bisect completes.

### 5. Offer to debug

After bisect completes, present the minimal reproduction command and ask:

> Bisect found minimal set: `<command>`. Want me to debug and fix this order-dependent failure?

If user says yes:
- Run the minimal reproduction to see the actual failure output
- Read the failing spec and the "polluting" spec identified by bisect
- Look for shared state: global variables, class-level caches, database leaks, stub/mock bleed
- Propose a fix (isolation, cleanup, `around` hooks, database cleaner config)
- Run minimal reproduction again to verify fix

## Multiple XML files

When given multiple XML files, process each independently. Different files may have different seeds and different failures. Present results for each before offering to debug.

## Tips

- Bisect can take a long time with many files. Suggest `--full` only if default mode fails to reproduce.
- Common causes: shared database state, memoized class variables, stubbed constants not restored, Redis/cache pollution.
