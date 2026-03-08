#!/usr/bin/env bash
set -euo pipefail

REPO="AlexanderErdelyi/smart-inbox"

ensure_milestone() {
  local title="$1"
  local desc="$2"
  local due="$3"

  local existing
  existing=$(gh api "repos/$REPO/milestones?state=all&per_page=100" --jq ".[] | select(.title == \"$title\") | .number" | head -n1 || true)

  if [[ -n "${existing:-}" ]]; then
    gh api --method PATCH "repos/$REPO/milestones/$existing" \
      -f title="$title" \
      -f description="$desc" \
      -f due_on="$due" >/dev/null
    echo "$existing"
  else
    gh api --method POST "repos/$REPO/milestones" \
      -f title="$title" \
      -f description="$desc" \
      -f due_on="$due" \
      --jq '.number'
  fi
}

assign_issue_to_milestone() {
  local issue_number="$1"
  local milestone_title="$2"
  gh issue edit "$issue_number" --repo "$REPO" --milestone "$milestone_title" >/dev/null
}

M1=$(ensure_milestone "M1 - Gmail MVP" "OAuth, provider connection, initial sync, and inbox baseline for Gmail." "2026-04-15T23:59:59Z")
M2=$(ensure_milestone "M2 - Intelligence v1" "Classification pipeline, AI abstraction, and persisted confidence outputs." "2026-05-15T23:59:59Z")
M3=$(ensure_milestone "M3 - Multi-provider foundation" "Provider capabilities, abstraction hardening, and readiness for Outlook/IMAP." "2026-06-15T23:59:59Z")

assign_issue_to_milestone 1 "M1 - Gmail MVP"
assign_issue_to_milestone 2 "M1 - Gmail MVP"
assign_issue_to_milestone 3 "M2 - Intelligence v1"
assign_issue_to_milestone 4 "M3 - Multi-provider foundation"
assign_issue_to_milestone 5 "M1 - Gmail MVP"
assign_issue_to_milestone 6 "M1 - Gmail MVP"
assign_issue_to_milestone 7 "M1 - Gmail MVP"
assign_issue_to_milestone 8 "M1 - Gmail MVP"
assign_issue_to_milestone 9 "M1 - Gmail MVP"
assign_issue_to_milestone 10 "M1 - Gmail MVP"
assign_issue_to_milestone 11 "M1 - Gmail MVP"
assign_issue_to_milestone 12 "M2 - Intelligence v1"
assign_issue_to_milestone 13 "M2 - Intelligence v1"
assign_issue_to_milestone 14 "M2 - Intelligence v1"
assign_issue_to_milestone 15 "M3 - Multi-provider foundation"
assign_issue_to_milestone 16 "M3 - Multi-provider foundation"
assign_issue_to_milestone 17 "M3 - Multi-provider foundation"
assign_issue_to_milestone 18 "M3 - Multi-provider foundation"

echo "Milestones ready: M1=$M1 M2=$M2 M3=$M3"
