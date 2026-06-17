# git reflex

**Commit git to muscle memory.** A git problem gym: you're handed a repository in a known state and a goal, then you type whatever command solves it. A real git engine (WASM, in the browser) runs your command and checks the result — so *any* command that adequately solves the problem passes. Miss one and spaced repetition brings it back until it's reflex.

- **Stack:** Cloudflare (Pages · Workers · KV · Durable Objects · Queues · Cron · R2 · Turnstile) + Supabase (Postgres · Auth · RLS · Realtime). Client: React (Vite), PWA.
- **Full design & backlog:** [`docs/superpowers/specs/2026-06-16-git-reflex-refined-design.md`](docs/superpowers/specs/2026-06-16-git-reflex-refined-design.md)
- **Backlog:** 113 GitHub issues (25 epics + 88 child issues) across 4 milestones. Labels: type (`epic`/`feature`/`chore`/`spike`), domain (`engine`/`content`/`frontend`/`infra`/`data`/`design`/`growth`/`social`), and `retention-refinement`.

---

## Build roadmap

Two parallel tracks. The **backend track** (git engine, data, scheduling, infra) generally leads, because the solve loop can't render without an engine to verify against. The **frontend track** (UI, design system, screens) follows close behind, consuming the engine and APIs. Within each phase, issues are listed in the recommended order to pick them up.

> **Start here (shared foundation — unblocks both tracks):**
> [#42](../../issues/42) Scaffold React + Vite (+lint/test) → [#43](../../issues/43) Cloudflare Pages deploy → [#44](../../issues/44) OSS hygiene (README/LICENSE/CONTRIBUTING). Epic: [#41](../../issues/41).

### Frontend track

