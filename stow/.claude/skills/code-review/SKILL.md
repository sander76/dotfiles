---
name: code-review
description: Review code changes and produce a structured findings report
---

## What I do
- Analyse the code changes for bugs, correctness issues, design problems, and
  style issues.
- Classify each finding by severity: high, medium, low, trivial.
- Present findings as numbered items with file and line references where
  applicable.
- Before flagging an inconsistency, check the source to confirm whether there is
  a legitimate reason for it.
- Summarise all findings in a severity-ranked table at the end.

## When to use me
Use this when the user asks to review a diff, a set of changes or a branch. When
asked to review a branch, first find the most-recent tag with `git
describe --tags --abbrev=0 <branch>` and diff against that tag.

## Output format
For each finding, write a short heading with the severity in parentheses,
followed by an explanation and any relevant code references. End the response
with a markdown table with columns: #, Location, Issue, Severity.
 