#!/usr/bin/env bash
set -euo pipefail

REPO="AlexanderErdelyi/smart-inbox"

if ! command -v gh >/dev/null 2>&1; then
  echo "Error: GitHub CLI (gh) is required."
  exit 1
fi

if ! gh auth status >/dev/null 2>&1; then
  echo "Error: gh is not authenticated. Run: gh auth login"
  exit 1
fi

echo "Roadmap Progress for $REPO"
echo
printf "%-3s | %-34s | %-5s | %-6s | %-6s | %-10s\n" "#" "Milestone" "Open" "Closed" "Total" "Progress"
printf '%s\n' "----+------------------------------------+-------+--------+--------+----------"

while IFS=$'\t' read -r number title due; do
  open_count=$(gh issue list --repo "$REPO" --state open --milestone "$title" --json number --jq 'length')
  closed_count=$(gh issue list --repo "$REPO" --state closed --milestone "$title" --json number --jq 'length')
  total=$((open_count + closed_count))

  if [[ "$total" -eq 0 ]]; then
    progress="0%"
  else
    progress="$((closed_count * 100 / total))%"
  fi

  printf "%-3s | %-34s | %-5s | %-6s | %-6s | %-10s\n" "$number" "$title" "$open_count" "$closed_count" "$total" "$progress"
done < <(gh api "repos/$REPO/milestones?state=open&per_page=100" --jq '.[] | [.number,.title,(.due_on // "n/a")] | @tsv')
