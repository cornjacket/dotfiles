---
name: writing-docs
description: Write or revise human-facing technical documents — READMEs, runbooks, RCAs / incident reports, design or decision docs, how-to guides, status reports, task docs — in plain technical English (~80% ASD-STE100). Use whenever you create a document for a person to read, or rewrite one for clarity, even if the user does not mention style.
---

# Writing docs — plain technical English

The core rules live in the global `CLAUDE.md` ("Plain technical English"). They always apply.
This skill adds what only matters while you write a document: the word list, the sentence
details, the templates, and a final check. Do not restate the core rules in the document you
write.

## Sentence rules (detail)

- **Length.** Procedure sentences ≤20 words. Descriptive sentences ≤25. Paragraphs ≤6 sentences.
- **Procedures use the imperative.** "Run `make test`." Not "You should run `make test`."
- **One instruction per step.** Two actions → two steps. A condition goes first: "If the build
  fails, read `build.log`."
- **Simple tenses.** Use present, simple past, and future. Avoid "would have been", "is being".
- **No noun clusters over three words.** "The cache eviction policy" is fine. "The cache
  eviction policy configuration file path" is not. Use "of" or split the sentence.
- **Keep articles.** Write "Restart the service," not "Restart service."
- **No vague pronouns.** If "it" or "this" could mean two things, repeat the noun.
- **Numbers and names exactly.** Write the real command, path, flag, or value. Do not write
  "the config file" when you know the path.

## Word list

Prefer the left column. The right column is not banned, but each use needs a reason.

| Use | Instead of |
|---|---|
| use | utilize, leverage, employ |
| start / stop | initialize, initiate / terminate |
| check, look at | verify, validate (unless it is a formal validation) |
| make sure | ensure |
| help | facilitate |
| show | demonstrate, illustrate |
| about | approximately, regarding, with respect to |
| because | due to the fact that |
| to | in order to |
| now | at this point in time |
| can | is able to, has the ability to |
| if | in the event that |
| before / after | prior to / subsequent to |
| enough | sufficient |
| change | modify (fine as a code term) |

**Approved technical words.** Domain terms (endpoint, idempotent, worktree, lockfile) are
allowed. Define a term the first time you use it if the reader may not know it. Then use only
that term.

**Filler to delete.** "It is important to note that", "As you can see", "Generally speaking",
"Basically", "In order to", "Please note", "It should be mentioned", "Simply", "Just",
opening restatements of the request, and closing summaries that repeat the body.

## Choose the medium

Prose is the last choice for structure.

| Content | Medium |
|---|---|
| Ordered actions | Numbered list |
| Parallel facts, options, trade-offs | Table or bullets |
| Commands, config, file contents | Fenced code block, with the language tag |
| A flow, sequence, or state machine | Mermaid diagram |
| A calculation, config preview, or interactive explanation | A self-contained HTML/JS page |
| A reason or a decision | Prose — short paragraphs |

If an explanation needs more than three paragraphs, change the medium before you write the
fourth.

## Templates

Use the template that fits. Delete a section that has no content. Do not fill it with "N/A".

**README**
1. One line: what this is.
2. Quick start — the shortest path to a working result.
3. Usage — the common tasks.
4. Layout or architecture — only if a reader needs it to make a change.
5. Links — related repos and docs.

**Runbook**
1. When to use this runbook (the symptom or the alert).
2. Before you start — access, tools, risks.
3. Steps — numbered, one action each, with the expected result after each command.
4. How to check that the fix worked.
5. Rollback.

**RCA / incident report**
1. Summary — one or two sentences: what failed, the impact, and the duration.
2. Timeline — a table: time, event.
3. Root cause — the mechanism, not the person.
4. Why detection was late, if it was.
5. Actions — a table: action, owner, due date.

**Decision doc / ADR**
1. Decision — one sentence.
2. Context — the problem and the constraints.
3. Options — a table with trade-offs.
4. Why this option.
5. Consequences — what becomes easier and what becomes harder.

**Status report**
1. One line: the state (on track / at risk / blocked) and the main reason.
2. Done — bullets.
3. Next — bullets.
4. Blockers — each with what you need and from whom.

## Final check

Before you deliver the document, read it once against this list:

- [ ] The first line tells the reader what the document is or what happened.
- [ ] No sentence is over the length limit.
- [ ] No filler phrase from the list above.
- [ ] Each concept has one name throughout.
- [ ] Each step has one action.
- [ ] Commands, paths, and values are exact and in code formatting.
- [ ] No section repeats information that is authoritative elsewhere. Link to it.
- [ ] Any real uncertainty is stated once, plainly.
