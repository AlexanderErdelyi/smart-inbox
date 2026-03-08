#!/usr/bin/env bash
set -euo pipefail

if ! command -v gh >/dev/null 2>&1; then
  echo "Error: GitHub CLI (gh) is required."
  exit 1
fi

if ! gh auth status >/dev/null 2>&1; then
  echo "Error: gh is not authenticated. Run: gh auth login"
  exit 1
fi

REPO="${REPO:-$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null || true)}"
if [[ -z "${REPO}" ]]; then
  echo "Error: Could not determine repository. Set REPO=owner/name."
  exit 1
fi

M1_DUE="${M1_DUE:-2026-04-15T23:59:59Z}"
M2_DUE="${M2_DUE:-2026-05-15T23:59:59Z}"
M3_DUE="${M3_DUE:-2026-06-15T23:59:59Z}"
ISSUE_START="${ISSUE_START:-1}"
ISSUE_END="${ISSUE_END:-18}"

if [[ "$ISSUE_START" -gt "$ISSUE_END" ]]; then
  echo "Error: ISSUE_START must be <= ISSUE_END."
  exit 1
fi

echo "Using repository: $REPO"

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

M1=$(ensure_milestone "M1 - Gmail MVP" "OAuth, provider connection, initial sync, and inbox baseline for Gmail." "$M1_DUE")
M2=$(ensure_milestone "M2 - Intelligence v1" "Classification pipeline, AI abstraction, and persisted confidence outputs." "$M2_DUE")
M3=$(ensure_milestone "M3 - Multi-provider foundation" "Provider capabilities, abstraction hardening, and readiness for Outlook/IMAP." "$M3_DUE")

for issue in $(seq "$ISSUE_START" "$ISSUE_END"); do
  if [[ "$issue" -eq 3 ]]; then
    assign_issue_to_milestone "$issue" "M2 - Intelligence v1"
  elif [[ "$issue" -eq 4 ]]; then
    assign_issue_to_milestone "$issue" "M3 - Multi-provider foundation"
  elif [[ "$issue" -ge 12 && "$issue" -le 14 ]]; then
    assign_issue_to_milestone "$issue" "M2 - Intelligence v1"
  elif [[ "$issue" -ge 15 && "$issue" -le 18 ]]; then
    assign_issue_to_milestone "$issue" "M3 - Multi-provider foundation"
  else
    assign_issue_to_milestone "$issue" "M1 - Gmail MVP"
  fi
done

echo "Milestones ready: M1=$M1 M2=$M2 M3=$M3"
