# Agents

## Agent: Compatibility Triage
Goal: Identify all Neovim 0.11+ compatibility breakages.
Deliverables: prioritized failure list, file references, reproduction steps.

## Agent: Plugin Update Manager
Goal: Update only necessary plugins (batch by subsystem) and keep reproducibility.
Deliverables: updated plugin list + reasons + verification per batch.

## Agent: Core Runtime Maintainer
Goal: Fix boot/runtime/init order and core Lua runtime issues with minimal diffs.
Deliverables: minimal patches + startup verification.

## Agent: User Config Migration
Goal: Keep ~/.config/lvim compatible with minimal user changes.
Deliverables: MIGRATION.md notes + before/after snippets + shims if feasible.
