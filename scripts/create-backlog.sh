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

