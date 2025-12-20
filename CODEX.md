# Codex Rules for Silent's LunarVim fork

## Mission
- Short-term: Make this fork compatible with Neovim 0.11+ and update bundled plugins that break on 0.11+.
- Keep user config migration straightforward for ~/.config/lvim.

## Non-goals (unless explicitly requested)
- No large refactor for style only.
- No plugin swap unless necessary for compatibility.
- No breaking defaults without migration notes and (when feasible) a compatibility fallback.

## Working style
1. Plan-first: before editing, list relevant files + suspected breakpoints + minimal plan.
2. Small diffs: incremental PR-style changes.
3. Evidence-driven: tie changes to reproducible errors/logs.
4. Preserve UX: keep LunarVim feel stable unless incompatible.

## Compatibility policy
- Supported Neovim: 0.11.x and newer (0.11+).

## Plugin update rules
- Update the smallest set needed to reach clean startup + core workflows.
- Batch updates by subsystem: boot/runtime, LSP+completion, treesitter, UI, git/debug/test.
- Avoid “update everything”.

## Testing & verification (required)
- Clean boot on Neovim 0.11+
- :checkhealth key sections
- LSP attach for at least one language
- No critical startup errors

## User config migration (for ~/.config/lvim)
- Never silently break existing configs.
- If keys/behavior change: add shim if feasible, and write MIGRATION notes with before/after.

## Output format
1) Plan  2) Changes  3) Verification  4) Migration notes

## Safety
- Never output secrets.

## Maintenance Rules (Silent fork)

### Absolute paths & logs
- Always run maintenance commands from the repo root: `~/.local/share/lunarvim/lvim`.
- All generated logs MUST be written with absolute paths using `$(pwd)`:
  - `-V10"$(pwd)/triage_*.log"`
  - `> "$(pwd)/checkhealth.log" 2>&1`

### Batch upgrades only
- Never run a full `:Lazy update` across all plugins.
- Only update one subsystem per batch (LSP, Treesitter, UI, Git, etc.).
- After each batch, require:
  - headless triage: `NVIM_APPNAME=lvim lvim --headless -V10"$(pwd)/triage.log" ./_triage.lua +"sleep 300m" +"qa"`
  - UI triage: `NVIM_APPNAME=lvim lvim -V10"$(pwd)/triage_ui.log" ./_triage.lua +"sleep 300m" +"qa"`
  - lockfile drift check: only batch plugins changed in `~/.config/lvim/lazy-lock.json`.

### User config compatibility
- Treat `~/.config/lvim/lua/user/plugins/*` as a compatibility surface:
  - Prefer adding plugins via the recommended lazy spec path.
  - Avoid multiple merges into `lvim.plugins` (can cause duplicates).
- Any user-facing config change must be documented in MIGRATION.md with before/after snippets.

### Headless safety
- Any UI-dependent feature must guard `#vim.api.nvim_list_uis() == 0` to avoid headless failures.

### Capturing :checkhealth output
- `:checkhealth` writes to a `health://` buffer, not stdout.
- Always export it explicitly:
  NVIM_APPNAME=lvim lvim --headless +"silent! checkhealth" +"silent! w! $(pwd)/checkhealth.full.log" +"qa"
