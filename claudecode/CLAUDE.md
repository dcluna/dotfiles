# Important Instructions

## LLM comments

Whenever you see a comment starting with `LLM` in a file containing code, interpret these as instructions.

Example:

```ruby
# LLM: please treat this comment as an instruction
```

## Commands

### Modify the DB

Use the rails generate command:

```shell
rails g migration AddColumnNameToTable column_name:bigint
```

If you need to add a reference use the following:

```shell
rails g migration AddAssociationReferenceToTable belongs_to_association_name:references
```

If in doubt, check the output of this command before proceeding:

```
rails g migration --help
```


# Project conventions

## Toggling CSS classes

Instead of writing custom Javascript to toggle CSS classes, use @packages/workspace/@adquick/shared/src/controllers/toggle_controller.js, a Stimulus controller that was built to achieve this result.
