---
name: kanata
description: Review, edit, and extend kanata keyboard remapping configurations. Use when adding layers, tap-hold home row mods, aliases, macros, chords, or debugging kanata .kbd files. Also use for explaining kanata S-expression syntax, actions, and defcfg options.
---

# Kanata Configuration

## Workflow

1. **Read the config** — examine `config.kbd` and understand the current `defsrc`, `deflayer`, `defalias`, `defvar`, and `defcfg` sections.
2. **Check alignment** — ensure every `deflayer` has exactly the same number of items as `defsrc`. Mismatched counts are the most common error.
3. **Validate** — if kanata is running, trigger a live reload (`lrld`) to test. On Linux: `pkill -USR1 kanata` or use the mapped `lrld` key. Check `journalctl -u kanata` or run `kanata --debug -c config.kbd` in a terminal to catch parse errors.
4. **Edit precisely** — use `edit` with minimal `oldText`. Keep visual alignment in `deflayer` blocks so columns map to physical keys.

## References

- [Kanata Configuration Guide](https://github.com/jtroo/kanata/blob/main/docs/config.adoc) — full syntax and action reference
- [Kanata Key Names](https://github.com/jtroo/kanata/blob/main/parser/src/keys/mod.rs) — source of truth for valid key strings
- [Platform Known Issues](https://github.com/jtroo/kanata/blob/main/docs/platform-known-issues.adoc) — Windows/macOS/Linux caveats
