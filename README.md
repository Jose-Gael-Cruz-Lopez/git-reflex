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

#### Phase 0 · Prove
| # | Order | Issue | Depends on |
|---|------|-------|-----------|
| [#38](../../issues/38) | 1 | Design tokens | — |
| [#39](../../issues/39) | 2 | Core components (buttons, terminal, cards) | #38 |
| [#40](../../issues/40) | 3 | Reduced-motion + accessibility baseline | #39 |
| [#11](../../issues/11) | 4 | Terminal drill component | #39, engine #5 |
| [#12](../../issues/12) | 5 | Live repo-state readout | engine #3–5 |
| [#13](../../issues/13) | 6 | Multi-command sequences | #11, engine #5 |
| [#14](../../issues/14) | 7 | Hint reveal | #11 |
| [#15](../../issues/15) | 8 | Show idiomatic solution | #11, engine #7 |
| [#16](../../issues/16) | 9 | Reset control | #11, engine #8 |
| [#17](../../issues/17) | 10 | "Which solves it?" warm-up | #11 |
| [#18](../../issues/18) | 11 | Commit-history node strip | #11 |
| [#19](../../issues/19) | 12 | Keyboard-first loop + sub-second transitions | #11 |
| [#31](../../issues/31) | 13 | Session recap | engine #26–28, data #30 |
| [#33](../../issues/33) | 14 | Landing page | #39 |
| [#34](../../issues/34) | 15 | Interactive 10-second hero ⚡ | #33, engine #6 |
| [#35](../../issues/35) | 16 | Disaster-first positioning + copy ⚡ | #33 |
| [#36](../../issues/36) | 17 | "See how it works" demo flow | #33 |

Epics: Solve-loop UI [#10](../../issues/10) · Landing + interactive hero [#32](../../issues/32) · Design system [#37](../../issues/37)

#### Phase 1 · Retain
| # | Order | Issue | Depends on |
|---|------|-------|-----------|
| [#65](../../issues/65) | 1 | Streaks + daily goal + counter | auth #46, data #50 |
| [#67](../../issues/67) | 2 | Lifetime dashboard & history | data #53 |
| [#68](../../issues/68) | 3 | Commit-graph history (green squares) ⚡ | data #53 |
| [#74](../../issues/74) | 4 | Settings & accessibility | #40 |

Epics: Motivation & commit-graph [#64](../../issues/64) · Settings & accessibility [#73](../../issues/73)

#### Phase 2 · Grow
| # | Order | Issue | Depends on |
|---|------|-------|-----------|
| [#95](../../issues/95) | 1 | Installable PWA + service worker | Phase 1 done |
| [#96](../../issues/96) | 2 | Offline review queue + replay | #95, data #53 |
| [#98](../../issues/98) | 3 | Gauntlet session type + scoring ⚡ | content #71 |
| [#99](../../issues/99) | 4 | Gauntlet timer + lives/survival ⚡ | #98 |
| [#88](../../issues/88) | 5 | "Can you solve it?" challenge cards ⚡ | social #87 |
| [#89](../../issues/89) | 6 | Achievements / mastery badges | data #50 |

Epics: PWA & offline [#94](../../issues/94) · Gauntlet [#97](../../issues/97) · Social & sharing [#86](../../issues/86)

#### Phase 3 · Network
| # | Order | Issue | Depends on |
|---|------|-------|-----------|
| [#106](../../issues/106) | 1 | Cohort progress dashboard | infra #107 |

Epic: Team / education dashboards [#105](../../issues/105)

