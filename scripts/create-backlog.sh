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
