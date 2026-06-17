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

### Backend track

#### Phase 0 · Prove
| # | Order | Issue | Depends on |
|---|------|-------|-----------|
| [#2](../../issues/2) | 1 | Spike: wasm-git vs isomorphic-git | — |
| [#3](../../issues/3) | 2 | Build repo from `setup[]` in a Web Worker | #2 |
| [#4](../../issues/4) | 3 | Parse typed input into git invocations | #2 |
| [#5](../../issues/5) | 4 | Execute parsed commands | #3, #4 |
| [#6](../../issues/6) | 5 | Goal-assertion evaluator | #5 |
| [#7](../../issues/7) | 6 | Solution grading (solved/idiomatic/clumsy) | #6 |
| [#8](../../issues/8) | 7 | Reset to starting state | #3 |
| [#9](../../issues/9) | 8 | Error handling + friendly nudges | #4 |
| [#21](../../issues/21) | 9 | Problem JSON schema + validator | — |
| [#22](../../issues/22) | 10 | Author ~45 seed problems | #21, #6 |
| [#23](../../issues/23) | 11 | Author "oh no" disaster track ⚡ | #21, #6 |
| [#24](../../issues/24) | 12 | Content loader + content-hashing | #21 |
| [#26](../../issues/26) | 13 | Leitner 5-box state model | — |
| [#27](../../issues/27) | 14 | Weighted card picker | #26 |
| [#28](../../issues/28) | 15 | Mastery = box 5 surfacing | #26 |
| [#30](../../issues/30) | 16 | Anonymous progress store (IndexedDB) | #26 |

Epics: In-browser git engine [#1](../../issues/1) · Seed content [#20](../../issues/20) · Leitner SR [#25](../../issues/25) · Anonymous progress [#29](../../issues/29)

#### Phase 1 · Retain
| # | Order | Issue | Depends on |
|---|------|-------|-----------|
| [#46](../../issues/46) | 1 | Supabase project + Auth (magic link/OAuth) | — |
| [#50](../../issues/50) | 2 | Postgres migrations: all core tables | #46 |
| [#51](../../issues/51) | 3 | RLS own-row policies | #50 |
| [#47](../../issues/47) | 4 | supabase-js client + RLS reads/writes | #51 |
| [#52](../../issues/52) | 5 | Seed content into Postgres | #50, content #24 |
| [#53](../../issues/53) | 6 | `review_log` SoT + `user_card_state` recompute | #50 |
| [#48](../../issues/48) | 7 | Anonymous → account migration | #53, data #30 |
| [#55](../../issues/55) | 8 | FSRS memory model | #53 |
| [#56](../../issues/56) | 9 | Solve → FSRS rating mapping | #55, engine #7 |
| [#57](../../issues/57) | 10 | Daily queue construction | #55 |
| [#58](../../issues/58) | 11 | `get_due_queue` RPC | #57, #51 |
| [#60](../../issues/60) | 12 | Worker API scaffold (JWT verify + rate limit) | #46 |
| [#63](../../issues/63) | 13 | KV namespace (public decks + flags) | #60 |
| [#61](../../issues/61) | 14 | `/v1/decks` + `/v1/decks/:id/cards` | #60, #63 |
| [#62](../../issues/62) | 15 | `/v1/migrate` endpoint | #60, #48 |
| [#66](../../issues/66) | 16 | Optional reminder email | #46 |
| [#70](../../issues/70) | 17 | Expand to 100–150 problems | content #21 |
| [#71](../../issues/71) | 18 | Expand "oh no" disaster track ⚡ | #23 |
| [#72](../../issues/72) | 19 | Solution-quality grading polish | engine #7 |

Epics: Accounts & auth [#45](../../issues/45) · Data model [#49](../../issues/49) · FSRS scheduling [#54](../../issues/54) · Workers API + KV [#59](../../issues/59) · Content depth [#69](../../issues/69)

#### Phase 2 · Grow
| # | Order | Issue | Depends on |
|---|------|-------|-----------|
| [#76](../../issues/76) | 1 | Cloudflare-brokered isolated git runtime | infra #60 |
| [#77](../../issues/77) | 2 | Sandbox security (allowlist, caps, fresh FS) | #76 |
| [#78](../../issues/78) | 3 | `/v1/validate` broker endpoint | #77 |
| [#79](../../issues/79) | 4 | Route advanced problems to sandbox | #78, engine #6 |
| [#80](../../issues/80) | 5 | Cache results by (problem, command) | #78 |
| [#82](../../issues/82) | 6 | `leaderboard_entries` schema | data #50 |
| [#83](../../issues/83) | 7 | Aggregation via Queues/DO + KV snapshots | #82 |
| [#84](../../issues/84) | 8 | `/v1/leaderboard` endpoint | #83 |
| [#85](../../issues/85) | 9 | Global & friends boards + Turnstile | #84 |
| [#87](../../issues/87) | 10 | Shareable recap card image (R2/Workers) | infra #60 |
| [#100](../../issues/100) | 11 | Gauntlet leaderboard ⚡ | #83, frontend #98 |
| [#91](../../issues/91) | 12 | `content_submissions` schema + submit flow | data #50 |
| [#92](../../issues/92) | 13 | Review queue + moderation | #91 |
| [#93](../../issues/93) | 14 | Attribution display | #92 |

Epics: Server sandbox [#75](../../issues/75) · Leaderboards [#81](../../issues/81) · Social & sharing [#86](../../issues/86) · Community content [#90](../../issues/90)

#### Phase 3 · Network
| # | Order | Issue | Depends on |
|---|------|-------|-----------|
| [#102](../../issues/102) | 1 | Durable Object race rooms | infra #60 |
| [#103](../../issues/103) | 2 | `WS race/:roomId` + first-to-correct | #102 |
| [#104](../../issues/104) | 3 | Persist race results | #103, data #50 |
| [#107](../../issues/107) | 4 | Team accounts + roles | #51 |
| [#109](../../issues/109) | 5 | Full authoring tools + versioning | content #21 |
| [#110](../../issues/110) | 6 | Broader moderation + governance | #92 |
| [#112](../../issues/112) | 7 | CLI companion: drill in the terminal | engine #6, API #61 |
| [#113](../../issues/113) | 8 | Browser extension: explain + drill-this | content #21 |

Epics: Multiplayer races [#101](../../issues/101) · Team/edu dashboards [#105](../../issues/105) · Community authoring [#108](../../issues/108) · CLI + extension [#111](../../issues/111)

---

