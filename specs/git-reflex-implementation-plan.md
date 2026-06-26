# Git Reflex — Implementation Plan — Spec

**Date:** 2026-06-25
**Type:** Execution / implementation-plan spec (the *product* is already specified)
**Source design:** `docs/superpowers/specs/2026-06-16-git-reflex-refined-design.md`
**Backlog:** 113 GitHub issues already created (`Jose-Gael-Cruz-Lopez/git-reflex`), across 4 milestones.

> This spec defines **how** the existing Git Reflex backlog gets implemented and committed — not what the product is. The product, epics, and 113 issues already exist. This is the strategy for turning that backlog into code, commits, and PRs. Building happens in a **separate step** (e.g. `/build`), not as part of writing this spec.

---

## Objective

Kick off implementation of the entire Git Reflex backlog with a **breadth-first / coverage** strategy: every one of the **113 existing issues** receives real, meaningful commits, organized into **4 pull requests (one per milestone)**, reaching a target of **≥250 commits total**. The priority is full backlog coverage and contribution activity across every issue and every PR — *structure-first*, with full functional polish deferred to a later pass. No live cloud services are required for this pass.

---

## Requirements

### R1 — Repository structure (monorepo)
1. Establish a monorepo with these top-level areas:
   - `apps/web/` — React + Vite PWA (frontend).
   - `workers/` — Cloudflare Workers API (edge backend).
   - `packages/engine/` — shared git-WASM engine module (browser, Web Worker).
   - `supabase/` — Postgres migrations + RLS policies + seed.
   - `content/` — problem JSON, schema, validator, seed problems.
2. Root tooling: workspace config (package manager workspaces), shared lint/format config, `.gitignore`, root `README` pointer.

### R2 — Issue coverage
3. **Every one of the 113 issues** is referenced by **at least one commit** (commit message contains its `#<number>`).
4. **Every one of the 25 epic issues** is closed when its child issues' commits land in the phase PR.
5. No new issues are created and no existing issue is renumbered — the build references the existing issue numbers only.

### R3 — Commit target & distribution
6. Total commits across the four merged phase branches: **≥250**.
7. Commits are distributed proportionally to each phase's issue count (target, not hard limit):
   - **Phase 0 · Prove** (44 issues) → **~98 commits**
   - **Phase 1 · Retain** (30 issues) → **~66 commits**
   - **Phase 2 · Grow** (26 issues) → **~58 commits**
   - **Phase 3 · Network** (13 issues) → **~28 commits**
8. Larger / foundational issues may carry multiple commits; every issue carries at least one. Overshooting 250 from genuinely granular work is acceptable.

### R4 — PR structure (one PR per milestone)
9. Exactly **4 PRs**, one per milestone, each from a long-lived branch into `main`:
   - `phase-0-prove` → PR "Phase 0 · Prove"
   - `phase-1-retain` → PR "Phase 1 · Retain"
   - `phase-2-grow` → PR "Phase 2 · Grow"
   - `phase-3-network` → PR "Phase 3 · Network"
10. Each PR body lists every issue it closes (`Closes #x, #y, ...`) covering all that milestone's issues (44 / 30 / 26 / 13).
11. Phases are built and merged **sequentially** (Phase 0 merged before Phase 1 branches) to avoid cross-branch drift and conflicts.

### R5 — Commit convention
12. Conventional-commit style with scope and trailing issue ref, e.g.:
    - `feat(engine): parse typed input into git invocations (#4)`
    - `chore(infra): scaffold Cloudflare Pages deploy (#43)`
    - `docs(content): problem JSON schema (#21)`
13. Each commit ends with the required co-author trailer:
    `Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>`

### R6 — Per-phase content (structure-first)
14. **Phase 0 · Prove** — produces the most real code: monorepo scaffold, `apps/web` React/Vite PWA that loads on localhost, the **spiral-slider landing hero** integrated (issues #33/#34), git-WASM engine module skeleton + solve-loop UI components, problem JSON schema + ~45 seed problems incl. the "oh no" disaster track, Leitner model, anonymous progress store, design tokens/components, CI scaffold.
15. **Phases 1–3** — every issue gets real files/commits (migrations, RLS SQL, Worker route handlers, schema files, component stubs, scoped TODOs). Code that cannot run locally without cloud services (Durable Objects, multiplayer WS, sandbox) is committed as structured stubs with clear `TODO` markers — not omitted.

### R7 — Landing hero integration
16. The existing `framer-preview/` spiral-slider experiment is folded into `apps/web` as the landing-page hero (mapped to issues #33 Landing page and #34 Interactive hero), replacing the standalone preview app.

---

## Out of Scope

- **Live deployment** of Cloudflare Pages/Workers or Supabase (no real provisioning, no live URL). Backend exists as code only this pass.
- **Guaranteed build/test green** on every commit — structure-first; a later functional pass hardens builds and tests.
- **Creating or restructuring issues/milestones** — they already exist and are used as-is.
- **Real WASM git execution correctness**, multiplayer realtime behavior, server sandbox security hardening, payment/accounts going live — all deferred to the functional pass.
- **Backdating commits / contribution-graph date manipulation** — commits use real dates (not requested).
- The original Framer SpiralSlider art beyond its reuse as the hero.

---

## Constraints

- **Stack (from design):** Cloudflare (Pages, Workers, KV, Durable Objects, Queues, Cron, R2, Turnstile) + Supabase (Postgres, Auth, RLS, Realtime); client React (Vite) PWA. This pass writes code targeting that stack without deploying it.
- **Tooling:** Node + a workspace-capable package manager; Vite; TypeScript; ESLint/Prettier; Vitest (tests scaffolded, not required green this pass).
- **GitHub:** `gh` CLI authenticated as `Jose-Gael-Cruz-Lopez`; 113 issues + 4 milestones already exist; `main` is the default/integration branch.
- **Sequencing:** milestone branches merge in phase order; each phase independently mergeable (mirrors the design's "ship value at every phase").
- **Workflow:** branch off `main`; never commit straight to `main`; open the phase PR; merge; then start the next phase.

---

## Edge Cases

- **Issue already has no code area yet** → create the minimal folder/file the issue implies, commit referencing the issue, leave a scoped TODO.
- **Issue is an epic (no code of its own)** → reference it from a summary/scaffold commit (e.g. an epic README or index) and close it via the phase PR body.
- **Commit total < 250 after one-per-issue** → add granular follow-up commits on the largest foundational issues (engine, data model, design system) until ≥250.
- **Commit total naturally > 250** → acceptable; do not artificially squash to hit exactly 250.
- **Cross-phase file conflicts** → enforced sequential merge prevents divergence; rebase later phase branches on updated `main` before opening their PR.
- **framer-preview removal breaks the running localhost demo** → migrate the spiral hero into `apps/web` first, verify it still loads, then remove the standalone folder.
- **Code that can't run locally (DO/WS/sandbox/Supabase)** → committed as typed stubs with `TODO`, not skipped; counts toward issue coverage.
- **An issue spans both frontend and backend** → split into ≥2 commits (one per area) under the same phase branch.

---

## Definition of Done

A reviewer can verify the pass is complete by checking all of the following:

1. **Monorepo exists** — `apps/web/`, `workers/`, `packages/engine/`, `supabase/`, `content/` all present at repo root with real (non-empty) contents.
2. **≥250 commits** added on `main` across the four merged phase branches (`git rev-list --count` delta confirms ≥250).
3. **Every one of the 113 issues is closed**, and each was referenced by ≥1 commit message containing its `#<number>`.
4. **All 4 milestones show 0 open issues** (Phase 0: 44 closed, Phase 1: 30, Phase 2: 26, Phase 3: 13) via `gh api .../milestones`.
5. **Exactly 4 PRs** (one per milestone) were created and merged into `main`, each PR body enumerating the issues it closed.
6. **Commit distribution** roughly matches the targets (Phase 0 ~98 / Phase 1 ~66 / Phase 2 ~58 / Phase 3 ~28), each within reasonable tolerance, summing to ≥250.
7. **Spiral-slider landing hero** is integrated into `apps/web` (issues #33/#34) and `apps/web` **loads on localhost**; the standalone `framer-preview/` no longer exists (or is fully superseded).
8. **Commit messages** follow the convention (type(scope): summary (#n)) and each carries the required `Co-Authored-By` trailer.
9. **Phase order honored** — git history shows Phase 0 merged before Phase 1, etc.

---

## Open Questions (capture for build time)

- Exact per-issue commit allotment within each phase (the ~98/66/58/28 split is by issue count; can be tuned).
- Whether epic issues should be closed by the PR body or by an explicit per-epic commit.
- Package manager choice (npm / pnpm / bun workspaces) for the monorepo.
