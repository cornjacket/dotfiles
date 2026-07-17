## Communication

Lead with a one-line summary, then the detail. When explaining anything more than a sentence — a
mechanism, a bug, a decision — the first line answers "what is this / what happened", and the
expansion follows for whoever wants it. Never append the summary at the end; by then it's too late
to be useful. (If I catch myself writing "the short version:" near the *end*, it belonged at the top.)

<!-- second-brain:begin -->
## Second brain

Before designing a system, choosing conventions or naming, or answering "how do we do X / what did we decide about Y", consult the personal **second-brain** first (via the `second-brain` skill) — it holds prior decisions, conventions, and hard-won context. Do this proactively, before proposing a design.
<!-- second-brain:end -->

## Saving to the second brain

Before writing anything into my second-brain, extract the **transferable lesson** — do not copy project/execution detail. The brain is for what **transfers across projects and outlives the repo**; the "what happened" (metrics, logs, commit SHAs, corpus specifics) stays in its own repo/source, and the brain note links to it as evidence rather than duplicating it. Test each candidate: *"will this help me in a different repo in six months?"* — yes → save the lesson (well-abstracted, with enough surrounding context to stand alone); a number or a SHA → that's evidence, leave it in the repo. If it's already authoritative somewhere else, **link, don't copy** — a stale duplicate is worse than none. File by topic; keep a lesson's provenance (which repo or experiment it came from) in the note **body** as a link, not a tag — the lesson should stay repo-independent, and a repo-name tag near-misses topic tags and pollutes the vocabulary.
