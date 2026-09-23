# 12. Explicitly not going to happen

| Field | Value |
|---|---|
| Document type | User manual, Clause 12 |
| Part of | [Index](index.md) |
| Boundary added | 2026-08-16 |

## 12.1 Purpose

This clause records deliberate product boundaries. Each boundary follows an
existing project commitment. It is not an arbitrary feature cut.

A proposal that reintroduces one of these items shall first identify and amend
the conflicting commitment in the QSG, README, or the applicable architecture
decision.

## 12.2 Telemetry

Telemetry is not planned.

Reason:

- the QSG states that startup is local and read-only;
- Clause 11 states that Core performs no telemetry; and
- the base operating loop requires no network access.

No usage counter, startup beacon, crash upload, analytics identifier, or silent
remote report shall be added to Core.

## 12.3 Automatic update machinery

Automatic update machinery is not planned.

Reason:

- it has the same unsolicited network and phone-home shape as telemetry;
- no published installer currently exists for an updater to manage; and
- installation is intentionally an explicit package-manager or source-build
  action.

A future package repository may expose normal operator-invoked package updates.
That is not an in-application updater.

## 12.4 Huge configuration system

A large, central, mandatory configuration system is not planned.

Reason:

- Core's own architecture defines small project-local `.iderm/*.toml` files;
- each file is additive;
- absence degrades to no extension; and
- the base operating loop remains valid with no `.iderm/` directory.

New configuration shall be narrowly scoped to a real extension point. It shall
not create a required global registry, policy engine, migration framework, or
configuration language.

## 12.5 Complicated installer logic

Complicated installer logic is not planned.

Reason:

- README defines a single-binary product shape;
- the source build produces one executable with no application-level linking or
  packaging stage; and
- package managers, when published, should own platform installation behavior.

The product shall not add an installation wizard, background installer,
self-modifying bootstrapper, bundled runtime manager, or application-level
package database.

## 12.6 Interpretation

These boundaries do not prohibit documentation, checksums, signatures, release
archives, RPM metadata, or a Homebrew formula. Those are release artifacts and
normal distribution metadata. They shall not introduce telemetry, automatic
updates, mandatory configuration, or application-owned installer complexity.
