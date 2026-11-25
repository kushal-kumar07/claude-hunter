# Contributing

Contributions are welcome. Feel free to contribute new skills, improve existing guidance, add
safe testing ideas, fix documentation, or improve the setup script.

## Adding or improving a skill

1. Create or update a category folder under `skills/`.
2. Put the skill instructions in `SKILL.md`.
3. Keep the language simple and the workflow reproducible.
4. Include authorization boundaries, safe canaries, evidence requirements, impact, and
   remediation.
5. Link to [`skills/testing-rules/SKILL.md`](skills/testing-rules/SKILL.md) instead of repeating
   the operating rules, assessment workflow, or finding format.
6. Add a "Confirmed vs. false positive" section stating what counts as a confirmed finding for
   that category.
7. Update the skill list and selection table in `README.md` when adding a new skill.
8. Verify all README links and test both setup install and remove commands.

## Contribution guidelines

- Submit focused changes with a clear description.
- Do not include credentials, personal data, private targets, or destructive payloads.
- Keep examples limited to authorized labs, local fixtures, staging systems, or synthetic data.
- Explain and test any behavior changes to `setup.sh`.
- Update `CHANGELOG.md` under `[Unreleased]` for any user-facing change.

Feel free to open an issue or pull request with your improvement.
