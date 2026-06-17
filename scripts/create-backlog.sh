#!/usr/bin/env bash
# Creates the full Git Reflex backlog on GitHub: labels, milestones, epics, child issues.
# Idempotency note: re-running will create duplicate issues. Run once.
set -euo pipefail
REPO="Jose-Gael-Cruz-Lopez/git-reflex"

echo "==> Labels"
lbl() { gh label create "$1" --color "$2" --description "$3" --repo "$REPO" --force >/dev/null 2>&1 || true; }
lbl epic 5319e7 "Tracking epic grouping related issues"
lbl feature 0e8a16 "A user-facing feature"
lbl chore fef2c0 "Setup, tooling, or maintenance"
lbl spike d4c5f9 "Time-boxed investigation"
lbl engine 1d76db "In-browser / sandbox git engine"
lbl content 0052cc "Problems, tracks, authoring"
lbl frontend c2e0c6 "UI / client"
lbl infra bfdadc "Cloudflare / Supabase / CI"
lbl data e99695 "Schema, RLS, persistence"
lbl design fbca04 "Design system / visual"
lbl growth d93f0b "Acquisition / retention loops"
lbl social 1d76db "Sharing, leaderboards, multiplayer"
lbl retention-refinement b60205 "New retention / attention work"

echo "==> Milestones"
ms() { gh api -X POST "repos/$REPO/milestones" -f title="$1" -f description="$2" >/dev/null 2>&1 || true; }
ms "Phase 0 · Prove"   "In-browser engine + solve loop + seed content (free, proves the idea)."
ms "Phase 1 · Retain"  "Accounts, RLS, FSRS scheduling, streaks, commit-graph."
ms "Phase 2 · Grow"    "Server sandbox, leaderboards, sharing, community content, gauntlet."
ms "Phase 3 · Network" "Multiplayer races, team/edu dashboards, community authoring, CLI/extension."

P0="Phase 0 · Prove"; P1="Phase 1 · Retain"; P2="Phase 2 · Grow"; P3="Phase 3 · Network"

# epic <title> <labels> <milestone> <body>  -> echoes the new issue number
epic() { gh issue create --repo "$REPO" --title "$1" --label "$2" --milestone "$3" --body "$4" | grep -oE '[0-9]+$'; }
# child <title> <labels> <milestone> <epicnum> <body>
child() {
  gh issue create --repo "$REPO" --title "$1" --label "$2" --milestone "$3" \
    --body "Part of #$4

$5" >/dev/null
  echo "  + $1"
}

#############################################
echo "==> Phase 0 epics"

E=$(epic "[EPIC] In-browser git engine" "epic,engine" "$P0" \
"The verified-solve core: a real git running in the browser (WASM) that builds a repo from a problem's setup, runs the player's commands, and checks the goal by repository state — never by string match.")
echo "Engine epic #$E"
child "[engine] Spike: wasm-git (libgit2) vs isomorphic-git coverage" "spike,engine" "$P0" "$E" \
"Compare candidate engines for command coverage, bundle size, and Web Worker fit.
**AC:** matrix of supported subcommands across the 7 MVP tracks; recommendation + which ops must fall back to the server sandbox."
child "[engine] Build repo from setup[] in a Web Worker" "feature,engine" "$P0" "$E" \
"Execute a problem's setup[] steps to produce the starting repo state, off the main thread.
**AC:** given setup[], returns a ready repo; runs in a Worker; deterministic across runs."
child "[engine] Parse typed input into discrete git invocations" "feature,engine" "$P0" "$E" \
"Tokenize the typed line(s) into individual git commands; reject/nudge non-git input.
**AC:** multi-command lines split correctly; non-git input yields a friendly nudge, not an error."
child "[engine] Execute parsed commands against the repo" "feature,engine" "$P0" "$E" \
"Run the parsed commands in sequence against the built repo, updating state in place.
**AC:** sequential execution; per-command errors surfaced; state observable after each step."
child "[engine] Goal-assertion evaluator (refs, tree, index, files)" "feature,engine" "$P0" "$E" \
"Inspect the repo and test a problem's goal assertion — the pass/fail core. No string comparison.
**AC:** returns {solved, idiomatic}; passes for ANY sequence reaching the goal; rejects trivial non-solutions; unit-tested against the move-commit example."
child "[engine] Solution grading: solved / idiomatic / clumsy" "feature,engine" "$P0" "$E" \
"Above pass/fail, note whether the route was idiomatic/minimal vs clumsy; match against idiomatic[].
**AC:** grades the three categories; idiomatic reference compared without gating the pass."
child "[engine] Reset to starting state" "feature,engine" "$P0" "$E" \
"Restore the problem's starting repo so the player can try another approach.
**AC:** reset returns identical starting state; no leakage between attempts."
child "[engine] Error handling + friendly nudges" "feature,engine" "$P0" "$E" \
"Translate engine/parse failures into helpful, non-punishing messages.
**AC:** invalid commands and non-git input produce guidance; engine never hard-crashes the UI."

E=$(epic "[EPIC] Solve-loop UI" "epic,frontend" "$P0" \
"The keyboard-first drill: type a command, press Enter, see the repo state update and the goal check — fast enough for a two-minute gap in the day.")
echo "Solve-loop epic #$E"
child "[frontend] Terminal drill component (type -> Enter -> feedback)" "feature,frontend" "$P0" "$E" \
"The core terminal-style input with immediate feedback.
**AC:** Enter submits; correct/incorrect state flashes; blinking cursor; mobile-friendly."
child "[frontend] Live repo-state readout above the prompt" "feature,frontend" "$P0" "$E" \
"Compact branch / recent commits / working-tree status shown above the prompt, updating live.
**AC:** reflects engine state after each command; readable on small screens."
child "[frontend] Multi-command sequences with in-place updates" "feature,frontend" "$P0" "$E" \
"Allow issuing several commands until the goal is met; state updates in place.
**AC:** sequence kept until solved; history visible; can keep typing after a partial step."
child "[frontend] Hint reveal (subcommand nudge)" "feature,frontend" "$P0" "$E" \
"A hint that nudges toward the relevant subcommand without giving the line away.
**AC:** hint shown on request; using a hint is recorded for grading/scheduling."
child "[frontend] Show idiomatic solution (counts as a miss)" "feature,frontend" "$P0" "$E" \
"Reveal a clean reference solution; revealing counts the problem as a miss for scheduling.
**AC:** idiomatic route + one-sentence why shown; marked as miss."
child "[frontend] Reset control" "feature,frontend" "$P0" "$E" \
"UI control to restore the starting state.
**AC:** wired to engine reset; clears transient UI state."
child "[frontend] 'Which solves it?' warm-up multiple-choice mode" "feature,frontend" "$P0" "$E" \
"Pick from four candidate commands; the engine still runs the pick to confirm.
**AC:** four options; chosen command executed + verified; lower-stakes mobile flow."
child "[frontend] Commit-history node strip (run record)" "feature,frontend" "$P0" "$E" \
"A thin green/red node strip recording the session — the run literally draws a commit history.
**AC:** one node per attempt; color encodes solved/missed; seeds the commit-graph history feature."
child "[frontend] Keyboard-first loop + sub-second transitions" "feature,frontend" "$P0" "$E" \
"No mouse required; type -> Enter -> feedback -> Enter.
**AC:** full loop reachable by keyboard; transitions feel instant; reduced-motion honored."

E=$(epic "[EPIC] Seed content & authoring" "epic,content" "$P0" \
"Content is the product. Define the problem model and author the seed set across the 7 tracks.")
echo "Content epic #$E"
child "[content] Problem JSON schema + validator" "feature,content" "$P0" "$E" \
"Define the problem record (prompt, setup[], goal, idiomatic[], explanation, track, difficulty, tags, engine, version) and validate it.
**AC:** schema documented; validator rejects malformed problems in CI."
child "[content] Author ~45 seed problems across 7 tracks" "content" "$P0" "$E" \
"basics, branching, undoing, remote, stash, rebase, inspect.
**AC:** ~45 problems; each tested against its idiomatic solution and a known clumsy route; goals assert refs+tree+index."
child "[content] Author the 'oh no' disaster track (featured)" "content,retention-refinement" "$P0" "$E" \
"The disaster-first hook: force-push recovery, lost commit via reflog, detached HEAD, wrong-branch commit, hard-reset recovery, bad merge, accidental clean, dropped stash.
**AC:** ~8-10 panic scenarios; each robustly goal-asserted; surfaced as a featured track."
child "[content] Content loader + content-hashing" "feature,content" "$P0" "$E" \
"Load problems from JSON into the app; content-hash public sets for caching.
**AC:** loader reads /content/*.json; immutable sets carry a content hash."

E=$(epic "[EPIC] Leitner spaced repetition (in-session)" "epic,engine" "$P0" \
"MVP scheduling with no real time: five boxes, weighted so weaker cards resurface more often.")
echo "Leitner epic #$E"
child "[engine] Leitner 5-box state model" "feature,engine" "$P0" "$E" \
"Correct promotes a card one box; a miss sends it to box 1.
**AC:** box transitions match spec; mastery = box 5."
child "[engine] Weighted card picker" "feature,engine" "$P0" "$E" \
"Lower boxes appear more often (weight ~= 6 - box), simulating 'due' without real time.
**AC:** distribution favors weak cards; no card starved indefinitely."
child "[engine] Mastery = box 5 surfacing" "feature,engine" "$P0" "$E" \
"Expose per-card mastery for the recap.
**AC:** box distribution available to UI; box-5 marked mastered."

E=$(epic "[EPIC] Anonymous progress" "epic,data" "$P0" \
"Drill with zero sign-up; progress lives in the browser until an account is created.")
echo "Anonymous epic #$E"
child "[data] IndexedDB/localStorage anonymous progress store" "feature,data" "$P0" "$E" \
"Persist an anonymous review log + card state locally.
**AC:** survives reload; structured to replay into Postgres later (account migration)."
child "[frontend] Session recap" "feature,frontend" "$P0" "$E" \
"Accuracy, streak, box distribution, weakest tracks, 'retry the ones you missed'.
**AC:** shown after a session; links back into weak cards."

E=$(epic "[EPIC] Landing + interactive hero" "epic,growth,retention-refinement" "$P0" \
"Grab attention in seconds: a disaster-first landing page whose hero is a live, solvable drill — no signup.")
echo "Landing epic #$E"
child "[frontend] Landing page (design-system-driven)" "feature,frontend" "$P0" "$E" \
"Ramp-inspired restraint; product surfaces as the hero.
**AC:** responsive; uses design tokens; 'start solving' + 'see how it works' CTAs."
child "[frontend] Interactive 10-second hero (live drill)" "feature,frontend,retention-refinement" "$P0" "$E" \
"Visitors solve one curated real problem by typing, before any signup, via a shared lazy-loaded engine module.
**AC:** engine factored into a shared module; hero is playable; first solve -> CTA into a track."
child "[growth] Disaster-first positioning + copy" "growth,retention-refinement" "$P0" "$E" \
"Lead with 'when git goes wrong, get it right' and panic moments.
**AC:** hero/subhead/CTA copy; onboarding offers a 'survive a git disaster' warm-up."
child "[frontend] 'See how it works' demo flow" "feature,frontend" "$P0" "$E" \
"A short scripted walkthrough of the solve loop.
**AC:** reachable from landing; no account; ends in 'start solving'."

E=$(epic "[EPIC] Design system foundation" "epic,design" "$P0" \
"Ramp's discipline: quiet neutrals, one reserved accent (#345695), confident type, dark terminal as the one tactile hero.")
echo "Design epic #$E"
child "[design] Design tokens" "design" "$P0" "$E" \
"Color, type ramp (Inter/JetBrains Mono), radius, shadow, spacing.
**AC:** tokens map to the prototype variables; light/dark terminal defined."
child "[design] Core components (buttons, terminal, cards)" "feature,design" "$P0" "$E" \
"Filled/decisive buttons, the terminal surface, card primitives.
**AC:** primary=accent, secondary=ink, tertiary=text; no outline buttons by default."
child "[design] Reduced-motion + accessibility baseline" "feature,design" "$P0" "$E" \
"Motion only when it shows progress/state; honor reduced-motion.
**AC:** prefers-reduced-motion respected; focus states; color-contrast checked."

E=$(epic "[EPIC] Project setup & CI" "epic,infra" "$P0" \
"Scaffold the app, deploy the static slice, and set up open-source hygiene.")
echo "Setup epic #$E"
child "[chore] Scaffold React + Vite (PWA-ready) + lint/test" "chore,infra" "$P0" "$E" \
"Project skeleton with linting and a test runner.
**AC:** app builds; tests run in CI; PWA-ready structure."
child "[chore] Cloudflare Pages deploy for the SPA" "chore,infra" "$P0" "$E" \
"Static hosting + CDN for the SPA and assets.
**AC:** main deploys to Pages; preview deploys on PRs."
child "[documentation] Open-source hygiene: README, LICENSE, CONTRIBUTING" "documentation,chore" "$P0" "$E" \
"Make the repo credible and contributable (a launch motion).
**AC:** README pitch + setup; OSI license; CONTRIBUTING + content-authoring guide."

#############################################
echo "==> Phase 1 epics"

E=$(epic "[EPIC] Accounts & auth" "epic,infra" "$P1" \
"Supabase Auth issues JWTs; user data flows through supabase-js under RLS. Anonymous progress migrates on sign-up.")
echo "Auth epic #$E"
child "[infra] Supabase project + Auth (magic link + GitHub/Google OAuth)" "feature,infra" "$P1" "$E" \
"Stand up Supabase, enable auth providers.
**AC:** magic link + GitHub/Google sign-in working; JWTs issued."
child "[data] supabase-js client + RLS-guarded reads/writes" "feature,data" "$P1" "$E" \
"Wire the client for direct, RLS-enforced access to user data.
**AC:** reads/writes scoped to auth.uid(); no service role on the client."
child "[data] Anonymous -> account migration (replay review_log)" "feature,data" "$P1" "$E" \
"On first sign-up, POST the local review_log to a Worker; recompute user_card_state.
**AC:** merge is exact and idempotent; local progress preserved."

E=$(epic "[EPIC] Data model & persistence" "epic,data" "$P1" \
"Relational core in Postgres; user tables protected by RLS; content world-readable. review_log is the immutable source of truth.")
echo "Data-model epic #$E"
child "[data] Postgres migrations: all core tables" "feature,data" "$P1" "$E" \
"decks, cards, card_versions, profiles, user_card_state, review_log, sessions, session_items, streaks.
**AC:** migrations apply cleanly; indexes on review_log(user_id,reviewed_at) and user_card_state(user_id,due)."
child "[data] RLS own-row policies on learner tables" "feature,data" "$P1" "$E" \
"Per-user isolation enforced in the database.
**AC:** users can only touch their own rows; content readable by anon+authenticated."
child "[chore] Seed content into Postgres" "chore,data" "$P1" "$E" \
"Load the authored problem set into decks/cards.
**AC:** seed script idempotent; matches /content/*.json."
child "[data] review_log source-of-truth + user_card_state recompute" "feature,data" "$P1" "$E" \
"Treat review_log as immutable; derive user_card_state as a cache.
**AC:** state recomputable from log; trigger or sync keeps cache fresh; deterministic merges."

E=$(epic "[EPIC] FSRS scheduling" "epic,engine" "$P1" \
"Graduate from Leitner to FSRS: per-card stability/difficulty, due dates at a target retention, daily queues.")
echo "FSRS epic #$E"
child "[engine] FSRS memory model" "feature,engine" "$P1" "$E" \
"Stability, difficulty, due, reps, lapses, state per card.
**AC:** model updates after each review; next due set at target retention (~90%)."
child "[engine] Solve -> FSRS rating mapping" "feature,engine" "$P1" "$E" \
"Map how the solve went to again/hard/good/easy (clean+fast=easy; hint/clumsy=hard; reveal/fail=again).
**AC:** mapping matches spec table; reveal counts as a miss."
child "[engine] Daily queue construction" "feature,engine" "$P1" "$E" \
"Due cards (oldest first) + up to N new/day; interleave tracks; cap session; carry overflow.
**AC:** queue respects caps; tracks interleaved; overflow carried to tomorrow."
child "[data] get_due_queue RPC" "feature,data" "$P1" "$E" \
"Supabase RPC returning due + new cards for today.
**AC:** RLS-safe; honors per-user daily_goal."

E=$(epic "[EPIC] Workers API + KV" "epic,infra" "$P1" \
"Thin Cloudflare Worker API: JWT verify at the edge, rate limiting, edge-cached public decks.")
echo "Workers epic #$E"
child "[infra] Worker API scaffold: JWT verify (JWKS) + rate limit" "feature,infra" "$P1" "$E" \
"Base Worker that verifies Supabase JWTs against JWKS and rate-limits per IP/user.
**AC:** invalid tokens rejected; limits enforced at the edge."
child "[infra] /v1/decks + /v1/decks/:id/cards (KV edge cache)" "feature,infra" "$P1" "$E" \
"Serve public, content-hashed decks/cards from KV.
**AC:** edge-cached; near-free global reads."
child "[infra] /v1/migrate endpoint" "feature,infra" "$P1" "$E" \
"Import an anonymous review_log on sign-up (used by account migration).
**AC:** inserts under new user_id; idempotent."
child "[infra] KV namespace: public decks + feature flags" "chore,infra" "$P1" "$E" \
"Hot config + cached public decks.
**AC:** namespace provisioned; flags readable at the edge."

E=$(epic "[EPIC] Motivation & commit-graph" "epic,growth,retention-refinement" "$P1" \
"Reasons to come back: streaks, a lifetime dashboard, and practice history rendered as GitHub-style green squares.")
echo "Motivation epic #$E"
child "[frontend] Streaks + daily goal + streak counter" "feature,frontend" "$P1" "$E" \
"Daily goal, streak count, 'due now' surfacing.
**AC:** streak increments on a qualifying day; daily goal user-adjustable."
child "[infra] Optional reminder email" "feature,infra" "$P1" "$E" \
"Opt-in nudge to keep the streak.
**AC:** opt-in only; unsubscribe; sent via Cron."
child "[frontend] Lifetime dashboard & history" "feature,frontend" "$P1" "$E" \
"Mastery over time, review heatmap, retention rate.
**AC:** reads from review_log; per-track breakdown."
child "[frontend] Commit-graph history (green squares + heatmap)" "feature,frontend,retention-refinement" "$P1" "$E" \
"Render practice history as a GitHub-style contribution graph derived from review_log.
**AC:** per-day intensity squares; shareable; ties into the in-session node strip."

E=$(epic "[EPIC] Content depth" "epic,content" "$P1" \
"Grow the problem set and difficulty tiers; keep the disaster track expanding.")
echo "Content-depth epic #$E"
child "[content] Expand to 100-150 problems + difficulty tiers" "content" "$P1" "$E" \
"Beginner -> advanced across all tracks.
**AC:** 100-150 problems; tiers tagged; each tested against idiomatic + clumsy routes."
child "[content] Expand the 'oh no' disaster track" "content,retention-refinement" "$P1" "$E" \
"More recovery scenarios to deepen the hook.
**AC:** additional robustly-asserted disaster problems."
child "[engine] Solution-quality grading polish (flag destructive)" "feature,engine" "$P1" "$E" \
"Flag needlessly destructive routes; refine clumsy detection.
**AC:** destructive routes flagged in feedback without failing a valid solve."

E=$(epic "[EPIC] Settings & accessibility" "epic,design" "$P1" \
"User control over the experience.")
echo "Settings epic #$E"
child "[design] Settings: reduced motion, keyboard map, font size, theme, data export" "feature,design" "$P1" "$E" \
"Accessibility and personalization controls + data export.
**AC:** all settings persist; data export produces the user's review_log."

#############################################
echo "==> Phase 2 epics"

E=$(epic "[EPIC] Server sandbox (advanced ops)" "epic,infra" "$P2" \
"A Cloudflare-brokered isolated runtime running stock git for the advanced operations the browser engine can't cover. Deferred until problems demand it.")
echo "Sandbox epic #$E"
child "[infra] Cloudflare-brokered isolated git runtime" "feature,infra" "$P2" "$E" \
"Run stock git in an isolated environment for advanced ops (interactive rebase, exotic reflog).
**AC:** brokered invocation; returns resulting state."
child "[infra] Sandbox security: allowlist, no network, resource caps, fresh FS" "feature,infra" "$P2" "$E" \
"git subcommands from an allowlist only; CPU/memory/time caps; fresh isolated FS per attempt.
**AC:** no network; caps enforced; no cross-attempt leakage."
child "[infra] /v1/validate broker endpoint" "feature,infra" "$P2" "$E" \
"Validate advanced-track solves server-side; browser handles the rest.
**AC:** request {problemId,commands} -> {solved,idiomatic,resultState}."
child "[engine] Route advanced-track problems to the sandbox" "feature,engine" "$P2" "$E" \
"Per-problem engine flag ('browser' | 'sandbox') decides the path.
**AC:** browser default; sandbox only when required."
child "[infra] Cache results by (problem, command)" "feature,infra" "$P2" "$E" \
"Cache sandbox outcomes to cut cost.
**AC:** identical (problem,command) served from cache."

E=$(epic "[EPIC] Leaderboards" "epic,social" "$P2" \
"Aggregated, bot-protected boards computed off the hot path.")
echo "Leaderboard epic #$E"
child "[data] leaderboard_entries + per-period schema" "feature,data" "$P2" "$E" \
"Store entries per period (weekly etc.).
**AC:** schema + indexes; RLS for reads."
child "[infra] Aggregation via Queues/Durable Objects + KV snapshots" "feature,infra" "$P2" "$E" \
"Aggregate off the hot path; snapshot to KV for fast reads.
**AC:** no contended rows; periodic snapshots via Cron."
child "[infra] /v1/leaderboard endpoint" "feature,infra" "$P2" "$E" \
"Serve aggregated, cached boards.
**AC:** ?period=week works; edge-cached."
child "[social] Global & friends boards + Turnstile bot protection" "feature,social" "$P2" "$E" \
"Global and friends views; protect against bots.
**AC:** friends scoping; Turnstile on write paths."

E=$(epic "[EPIC] Social & sharing + challenge cards" "epic,social,retention-refinement" "$P2" \
"Make sharing automatic and turn fumbles into dares.")
echo "Social epic #$E"
child "[social] Shareable recap card image (R2/Workers)" "feature,social" "$P2" "$E" \
"Auto-generate a screenshot-worthy result image.
**AC:** image generated to R2; OG tags for social unfurls."
child "[social] 'Can you solve it?' challenge cards + deep links" "feature,social,retention-refinement" "$P2" "$E" \
"Recap becomes a dare aimed at a friend, deep-linking to a specific problem.
**AC:** deep link opens the exact problem; attribution; works without an account."
child "[social] Achievements / mastery badges" "feature,social" "$P2" "$E" \
"Track completion, perfect sessions, shareable badges.
**AC:** achievements awarded + displayed; shareable."

E=$(epic "[EPIC] Community content" "epic,content" "$P2" \
"Let players propose problems, with review and attribution.")
echo "Community-content epic #$E"
child "[content] content_submissions schema + submit flow (/v1/content + Turnstile)" "feature,content" "$P2" "$E" \
"Capture community-proposed scenarios.
**AC:** submit endpoint guarded by Turnstile; stored for review."
child "[content] Review queue + moderation" "feature,content" "$P2" "$E" \
"Moderate submissions before publishing.
**AC:** queue with approve/reject; published problems versioned."
child "[content] Attribution display" "feature,content" "$P2" "$E" \
"Credit authors of accepted problems.
**AC:** attribution shown on community problems."

E=$(epic "[EPIC] PWA & offline" "epic,frontend" "$P2" \
"Installable app with offline review that syncs on reconnect.")
echo "PWA epic #$E"
child "[frontend] Installable PWA + service worker (app shell + active deck)" "feature,frontend" "$P2" "$E" \
"Cache the app shell and the active deck.
**AC:** installable; works offline for review."
child "[frontend] Offline review queue (IndexedDB) + replay on reconnect" "feature,frontend" "$P2" "$E" \
"Queue reviews offline; replay the log on reconnect.
**AC:** offline reviews persist and sync deterministically."

E=$(epic "[EPIC] Gauntlet / survival mode" "epic,growth,retention-refinement" "$P2" \
"A timed run of escalating disasters with its own leaderboard — the competitive, screenshot-worthy mode.")
echo "Gauntlet epic #$E"
child "[frontend] Gauntlet session type + escalating-disaster scoring" "feature,frontend,retention-refinement" "$P2" "$E" \
"A distinct run of increasingly hard problems with a score.
**AC:** escalating difficulty; score recorded; uses the disaster track."
child "[frontend] Gauntlet timer + lives/survival logic" "feature,frontend,retention-refinement" "$P2" "$E" \
"Time pressure and lives; run ends on time-out or lives lost.
**AC:** timer + lives enforced; clean end-of-run summary."
child "[social] Gauntlet leaderboard" "feature,social,retention-refinement" "$P2" "$E" \
"Dedicated board for gauntlet scores.
**AC:** per-period board; bot-protected; shareable."

#############################################
