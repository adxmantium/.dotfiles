---
# Plugin Ideas
---

## Hound

- Plugin that will yank highlight text or what's under cursor, and add that text as QSP on a "base_url", but for now is mainly just the hound url for work
- "base_url" can be a config option that can be set to anything
- Future idea: allow setting a list of urls and telescope select a url to set QSP to

## Avesta template text highlighting

- basically just parse avesta syntax in html templates for color highlighting

## Content Type Schema plugin

- convert the schema script you wrote into a nvim plugin that will open the schema in a scratch buffer

## Look into nvim git-worktrees

- should help with managing multiple prs/branches, but just need to look into how worktrees works in general
- [plugin](https://github.com/nvim-treesitter/nvim-treesitter)

## Autosave from insert -> normal mode

- [ ] map :w (file save) whenever going from insert to normal mode

## Open test file based on current file

- map to a kemap, opening the test file of the current file in a new vsplit buffer
