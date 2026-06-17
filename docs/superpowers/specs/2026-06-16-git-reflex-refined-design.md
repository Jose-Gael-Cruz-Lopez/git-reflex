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

