# Changelog

All notable changes to this project are documented here. Format follows
[Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

### Added

- `skills/testing-rules/SKILL.md`: a shared skill holding the operating rules, assessment
  workflow, and finding format that every category skill used to repeat. Category skills now
  link to it instead of duplicating it.
- A "Confirmed vs. false positive" section in every vulnerability skill, stating what counts as
  a confirmed finding versus a false positive for that category.
- A "Steps" breakdown under each prompt catalog entry, turning the hypothesis into a numbered
  checklist.
- `CONTRIBUTING.md` with the contribution workflow moved out of the README.
- `examples/idor-walkthrough.md`: an end-to-end example of running a skill against a test
  target, ending in a short sample finding report.

### Removed

- All third-party source attribution and external links from skill files.

## [1.1.0] - 2026-08-29

### Added

- Safe canary markers in `wordlists/payloads/safe-canaries.txt` for non-destructive testing.

## [1.0.0] - 2026-08-28

### Added

- Initial release: skill packs for the core web vulnerability categories, recon and
  discovery skills, wordlists, and `setup.sh` for installing into Claude Code or Codex.
