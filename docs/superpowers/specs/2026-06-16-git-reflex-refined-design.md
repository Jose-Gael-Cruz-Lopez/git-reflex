# Git Reflex — Refined Design & Build Backlog

**Date:** 2026-06-16
**Status:** Approved structure → issues
**Source:** `git-reflex-spec.pdf` (Product & Architecture Specification v1.0, June 2026)

This document refines the original Git Reflex spec with a focused **retention + attention layer**, then defines the complete GitHub backlog (milestones, labels, epics, issues) to build the entire app across all four phases.

---

## 1. What Git Reflex is (unchanged core)

A git problem gym. You're handed a repository in a known state plus a goal, and you type whatever git command(s) you think solve it. A **real git engine** (WASM, in-browser) runs your input against an actual repo and checks whether the result satisfies the goal. There is no expected string — **any command that reaches the goal passes**. Miss one and spaced repetition brings it back until it's reflex.

The architectural keystone (from the spec): the git execution engine lives at the **core** (real git running in the browser via WebAssembly), not as a far-future add-on. Everything else — content, scheduling, accounts, social — is scaffolding around that verified-solve loop.

**Stack:** Cloudflare (edge: Pages, Workers, KV, Durable Objects, Queues, Cron, R2, Turnstile) + Supabase (Postgres, Auth, RLS, Realtime). Client: React (Vite), PWA.

---

## 2. Refinements (the new value layer)

These four refinements layer on top of the existing spec. They target the two weakest dimensions of the original: **grabbing attention** and **bringing people back**.

### 2.1 Disaster-first brand hook `retention-refinement`
The "oh no" recovery track is promoted from a difficulty-3 afterthought to the **lead narrative**. Positioning shifts from "learn git" to **"when git goes wrong, get it right."**
- Landing copy and onboarding lead with panic moments developers actually fear.
- Onboarding offers an optional **"survive a git disaster"** warm-up.
- Author ~8–10 disaster scenarios: force-push recovery, lost commit via reflog, detached HEAD, committed-to-wrong-branch, hard-reset recovery, bad merge, accidental `git clean`, dropped stash.
- Cheap to build (mostly content + copy), highest virality ceiling.

### 2.2 Interactive 10-second hero `retention-refinement`
The landing-page terminal becomes **live**. A visitor solves one curated real problem by typing — before any signup or navigation. Time-to-aha drops to seconds.
- Requires factoring the WASM engine into a **shared module** the marketing page lazy-loads.
- On first solve → "start solving" CTA into a full track.

### 2.3 Commit-graph history `retention-refinement`
Practice history renders as **GitHub-style green squares + a heatmap**, derived from `review_log`. Identity-driven retention; instantly shareable. The in-session "your run draws a commit history" node strip (already in the spec) is the seed of this surface.

### 2.4 Challenge + gauntlet modes `retention-refinement`
- **Challenge cards:** a recap card becomes a "can you solve it?" dare with a deep link to a specific problem.
- **Gauntlet / survival mode:** a timed run of escalating disasters, lives-based, with its own leaderboard. The thing people screenshot and race on.

---

## 3. Backlog structure

### Milestones (one per phase)
- **Phase 0 · Prove** — in-browser engine + solve loop + seed content (free, proves the idea).
- **Phase 1 · Retain** — accounts, RLS, FSRS scheduling, streaks, commit-graph.
- **Phase 2 · Grow** — server sandbox, leaderboards, sharing, community content, gauntlet.
- **Phase 3 · Network** — multiplayer races, team/edu dashboards, community authoring, CLI/extension.

### Labels
- **Type:** `epic`, `feature`, `chore`, `spike`, `documentation`
- **Domain:** `engine`, `content`, `frontend`, `infra`, `data`, `design`, `growth`, `social`
- **Cross-cutting:** `retention-refinement` (the four refinements above)

---

## 4. Epics & issues

Legend: ⚡ = contains refinement work. Each issue carries its domain/type labels and milestone; child issues reference their epic.

### Phase 0 · Prove

**EPIC: In-browser git engine** `engine`
1. **spike:** evaluate `wasm-git` (libgit2) vs `isomorphic-git` for command coverage
2. Build a repo from a problem's `setup[]` steps inside a Web Worker
3. Parse typed input into discrete git invocations; reject/nudge non-git input
4. Execute parsed commands against the built repo
5. Goal-assertion evaluator (refs, working-tree cleanliness, index, file content)
6. Solution grading: `solved` / `idiomatic` / `clumsy` + idiomatic match
7. Reset to starting state
8. Engine error handling + friendly nudges for invalid input

**EPIC: Solve-loop UI** `frontend`
9. Terminal drill component (type → Enter → feedback)
10. Live repo-state readout (branch, log, tree status) above the prompt
11. Multi-command sequences with in-place state updates
12. Hint reveal (subcommand nudge)
13. Show idiomatic solution (counts as a miss)
14. Reset control
15. "Which solves it?" warm-up multiple-choice mode
16. Commit-history node strip (run record, green/red)
17. Keyboard-first loop + sub-second transitions

**EPIC: Seed content & authoring** `content`
18. Problem JSON schema + validator
19. Author ~45 seed problems across 7 tracks
20. ⚡ Author the "oh no" disaster track (featured)
21. Content loader + content-hashing

**EPIC: Leitner spaced repetition (in-session)** `engine`
22. Leitner 5-box state model
23. Weighted card picker (lower boxes appear more often)
24. Mastery = box 5 surfacing

**EPIC: Anonymous progress** `data`
25. IndexedDB/localStorage anonymous progress store
26. Session recap (accuracy, streak, box distribution, weakest tracks)

**EPIC: Landing + interactive hero ⚡** `growth`
27. Landing page (design-system-driven)
28. ⚡ Interactive 10-second hero — live drill via shared engine module
29. ⚡ Disaster-first positioning + copy
30. "See how it works" demo flow

**EPIC: Design system foundation** `design`
31. Design tokens (color, type ramp, radius/shadow/spacing)
32. Core components (buttons, terminal, cards)
33. Reduced-motion + accessibility baseline

**EPIC: Project setup & CI** `infra`
34. Scaffold React + Vite (PWA-ready) app + lint/test
35. Cloudflare Pages deploy for the SPA
36. Open-source hygiene: README, LICENSE, CONTRIBUTING

### Phase 1 · Retain

**EPIC: Accounts & auth** `infra`
37. Supabase project + Auth (magic link + GitHub/Google OAuth)
38. supabase-js client + RLS-guarded reads/writes
39. Anonymous → account migration (replay `review_log`)

**EPIC: Data model & persistence** `data`
40. Postgres migrations: all core tables
41. RLS own-row policies on learner tables
42. Seed content into Postgres
43. `review_log` as source of truth + `user_card_state` recompute

**EPIC: FSRS scheduling** `engine`
44. FSRS memory model (stability / difficulty / due / state)
45. Solve → FSRS rating mapping (easy/good/hard/again)
46. Daily queue construction (due + new cap, interleave, session cap, overflow)
47. `get_due_queue` RPC

**EPIC: Workers API + KV** `infra`
48. Worker API scaffold: JWT verify (JWKS) + rate limit
49. `/v1/decks` + `/v1/decks/:id/cards` (KV edge cache)
50. `/v1/migrate` endpoint
51. KV namespace: public decks + feature flags

**EPIC: Motivation & commit-graph ⚡** `growth`
52. Streaks + daily goal + streak counter
53. Optional reminder email
54. Lifetime dashboard & history (mastery over time, retention rate)
55. ⚡ Commit-graph history (green squares + heatmap)

**EPIC: Content depth** `content`
56. Expand to 100–150 problems + difficulty tiers
57. ⚡ Expand the "oh no" disaster track
58. Solution-quality grading polish (flag destructive routes)

**EPIC: Settings & accessibility** `design`
59. Settings: reduced motion, keyboard map, font size, theme, data export

### Phase 2 · Grow

**EPIC: Server sandbox (advanced ops)** `infra`
60. Cloudflare-brokered isolated git runtime
61. Sandbox security: allowlist, no network, resource/time caps, fresh FS per attempt
62. `/v1/validate` broker endpoint
63. Route advanced-track problems to the sandbox
64. Cache results by `(problem, command)`

**EPIC: Leaderboards** `social`
65. `leaderboard_entries` + per-period schema
66. Aggregation via Queues/Durable Objects + KV snapshots
67. `/v1/leaderboard` endpoint
68. Global & friends boards + Turnstile bot protection

**EPIC: Social & sharing + challenge cards ⚡** `social`
69. Shareable recap card image (R2/Workers)
70. ⚡ "Can you solve it?" challenge cards + deep links
71. Achievements / mastery badges

**EPIC: Community content** `content`
72. `content_submissions` schema + submit flow (`/v1/content` + Turnstile)
73. Review queue + moderation
74. Attribution display

**EPIC: PWA & offline** `frontend`
75. Installable PWA + service worker (app shell + active deck)
76. Offline review queue (IndexedDB) + replay on reconnect

**EPIC: Gauntlet / survival mode ⚡** `growth`
77. ⚡ Gauntlet session type + escalating-disaster scoring
78. ⚡ Gauntlet timer + lives/survival logic
79. ⚡ Gauntlet leaderboard

