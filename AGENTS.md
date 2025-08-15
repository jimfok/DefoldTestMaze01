# AGENTS.md
- Codex should modify only Lua / script / *.md files (e.g. *.script, *.gui_script, *.render_script).
- Any tasks related to Defold collections, GUIs, or game objects should be escalated to a human.
- Update codexlog.md whenever Codex makes a change, grouping all modifications made on the same day under a single section.
- Comments
  - Prioritize intent over mechanics: Always explain why the code is written this way.
  - Document contracts: Preconditions, postconditions, side effects.
  - Note future-proofing rationale: Explain design choices that help adapt to likely future needs.
  - Expose hidden assumptions: Clarify what is taken for granted in the code logic.
  - Avoid noise: No trivial comments that repeat the code.