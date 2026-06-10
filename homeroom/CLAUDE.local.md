## graphify

This project has a knowledge graph at graphify-out/ with god nodes, community structure, and cross-file relationships.

Rules:
- For codebase questions, first run `graphify query "<question>"` when graphify-out/graph.json exists. Use `graphify path "<A>" "<B>"` for relationships and `graphify explain "<concept>"` for focused concepts. These return a scoped subgraph, usually much smaller than GRAPH_REPORT.md or raw grep output.
- If graphify-out/wiki/index.md exists, use it for broad navigation instead of raw source browsing.
- Read graphify-out/GRAPH_REPORT.md only for broad architecture review or when query/path/explain do not surface enough context.
- After modifying code, run `graphify update .` to keep the graph current (AST-only, no API cost).

## Test Setup: GraphQL Helpers Required

All test setup MUST use the GraphQL helpers defined in `spec/support/graphql_helpers/`.
FactoryBot is forbidden for domain objects (enrollments, orders, payments, carts, etc.).

See `.claude/skills/testing/SKILL.md` for the full rules and
`spec/support/graphql_helpers/README.md` for the complete helper API.

### Why

GraphQL helpers exercise real application code paths — mutations, callbacks,
denormalized join-table syncs — that FactoryBot silently bypasses. Tests built
on factories can pass while hiding bugs that only surface in production.

### What "use GraphQL helpers" means

```ruby
# WRONG — bypasses business logic
let(:enrollment) { create(:enrollment, :paid, course: course, parent: parent, student: student) }

# RIGHT — exercises the real checkout flow
let!(:organizer) { create_organizer }
let!(:site)      { organizer.create_site.first }
let!(:season)    { organizer.create_season(:enrolling_season, :schedule_session, site:).first }
let!(:course)    { organizer.create_course(:season_rate, :approved_course, site:, season:).first }
let!(:parent)    { create_parent }
let!(:student)   { parent.create_student.first }
let!(:enrollment) do
  parent.add_to_cart(course:, student:)
  parent.accept_terms_of_service
  parent.add_credit_card(token: "test", update_cart_payment_service: true)
  parent.checkout(payment_method: "pm_card_visa")
end
```

### When factories are acceptable

The only exception is entities that are **never created through the UI** — for
example, records seeded by background jobs or data migrations. Even then, prefer
GraphQL helpers if a helper exists for the entity.

If the existing helpers do not cover the setup you need, **stop and ask the user**
for instructions before falling back to FactoryBot. Do not invent workarounds.

### Reference commit

See `8635867904` ("Refactor student_log_entry_spec to use GQL helpers") for a
concrete before/after example of converting FactoryBot setup to GraphQL helpers.
