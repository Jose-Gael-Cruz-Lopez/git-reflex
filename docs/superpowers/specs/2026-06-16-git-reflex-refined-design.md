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

