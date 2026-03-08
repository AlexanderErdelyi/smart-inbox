#!/usr/bin/env bash
set -euo pipefail

if ! command -v gh >/dev/null 2>&1; then
  echo "Error: GitHub CLI (gh) is required."
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "Error: jq is required."
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

echo "Using repository: $REPO"

ensure_label() {
  local name="$1"
  local color="$2"
  local desc="$3"
  gh label create "$name" --repo "$REPO" --color "$color" --description "$desc" --force >/dev/null
}

ensure_issue() {
  local title="$1"
  local body="$2"
  local labels="$3"

  local existing
  existing=$(gh issue list --repo "$REPO" --state all --search "\"$title\" in:title" --json number,title | jq -r --arg t "$title" '.[] | select(.title == $t) | .number' | head -n1)

  if [[ -n "${existing:-}" ]]; then
    echo "$existing"
    return 0
  fi

  local url
  url=$(gh issue create --repo "$REPO" --title "$title" --body "$body" --label "$labels")
  echo "$url" | sed -E 's#.*/issues/([0-9]+).*#\1#'
}

echo "Creating or updating labels..."
ensure_label "type:epic" "5319E7" "High-level initiative"
ensure_label "type:feature" "1D76DB" "User-facing or platform feature"
ensure_label "type:task" "0E8A16" "Implementation task"
ensure_label "type:bug" "D73A4A" "Bug fix"

ensure_label "area:api" "0052CC" "Backend API"
ensure_label "area:web" "0366D6" "Frontend web app"
ensure_label "area:worker" "1F6FEB" "Background workers"
ensure_label "area:provider-sdk" "2B7489" "Provider adapter SDK"
ensure_label "area:infra" "6F42C1" "Infrastructure and environment"

ensure_label "provider:gmail" "FBCA04" "Gmail-specific work"
ensure_label "provider:outlook" "0C7BDC" "Outlook-specific work"
ensure_label "provider:imap" "BFDADC" "IMAP-specific work"

ensure_label "priority:p0" "B60205" "Highest priority"
ensure_label "priority:p1" "D93F0B" "Medium priority"
ensure_label "priority:p2" "FBCA04" "Lower priority"

echo "Creating or reusing epics..."
EPIC_AUTH=$(ensure_issue \
  "Epic: Auth & Provider Connections" \
  "Objective: allow users to securely connect mail providers, starting with Gmail.\n\nThis epic tracks OAuth, token handling, and provider account management.\n\nDefinition of done:\n- Gmail OAuth flow is operational\n- Provider tokens are stored securely\n- API exposes connected accounts" \
  "type:epic,area:api,provider:gmail,priority:p0")

EPIC_SYNC=$(ensure_issue \
  "Epic: Sync Pipeline & Data Model" \
  "Objective: ingest and persist normalized mailbox data through provider adapters.\n\nThis epic tracks schema, sync jobs, and message normalization.\n\nDefinition of done:\n- Initial sync runs end-to-end\n- Messages and threads persisted in normalized model\n- Sync cursor strategy established" \
  "type:epic,area:worker,area:provider-sdk,area:infra,provider:gmail,priority:p0")

EPIC_AI=$(ensure_issue \
  "Epic: Intelligence & Classification" \
  "Objective: classify and prioritize emails with explainable confidence scores.\n\nThis epic tracks AI abstraction, prompts, and classification persistence.\n\nDefinition of done:\n- Classification pipeline operational\n- Results persisted\n- Confidence and categories exposed via API" \
  "type:epic,area:api,area:worker,priority:p1")

EPIC_UX=$(ensure_issue \
  "Epic: Inbox UX & Actions" \
  "Objective: provide actionable inbox experience with transparent suggested actions.\n\nThis epic tracks inbox list, labels/actions UI, and capability-aware UX.\n\nDefinition of done:\n- Inbox view renders normalized data\n- Suggested actions visible\n- Provider capability constraints handled in UI" \
  "type:epic,area:web,priority:p1")

echo "Creating or reusing child issues..."
ensure_issue \
  "Implement Google OAuth start + callback in API" \
  "tracks #$EPIC_AUTH\n\nImplement Google OAuth start and callback endpoints in the API and validate token exchange flow." \
  "type:feature,area:api,provider:gmail,priority:p0" >/dev/null

ensure_issue \
  "Persist encrypted provider tokens" \
  "tracks #$EPIC_AUTH\n\nStore provider access/refresh tokens encrypted at rest with key management policy for local and production environments." \
  "type:task,area:api,area:infra,priority:p0" >/dev/null

ensure_issue \
  "Expose connected provider accounts endpoint" \
  "tracks #$EPIC_AUTH\n\nAdd an authenticated API endpoint to list connected mailbox accounts and provider metadata." \
  "type:task,area:api,priority:p1" >/dev/null

ensure_issue \
  "Add DB schema for mailbox accounts/messages/threads/sync cursors" \
  "tracks #$EPIC_SYNC\n\nDefine and migrate schema to support normalized mailbox entities and sync cursors." \
  "type:feature,area:infra,area:api,priority:p0" >/dev/null

ensure_issue \
  "Implement GmailAdapter listMessages + pagination cursor" \
  "tracks #$EPIC_SYNC\n\nImplement Gmail adapter message listing with stable pagination cursor handling." \
  "type:feature,area:provider-sdk,provider:gmail,priority:p0" >/dev/null

ensure_issue \
  "Create initial sync job in worker" \
  "tracks #$EPIC_SYNC\n\nImplement worker job that performs initial mailbox sync for a connected account." \
  "type:task,area:worker,priority:p0" >/dev/null

ensure_issue \
  "Store normalized messages in database" \
  "tracks #$EPIC_SYNC\n\nPersist transformed provider messages into normalized domain tables." \
  "type:task,area:api,area:infra,priority:p0" >/dev/null

ensure_issue \
  "Add AI service provider config and prompt versioning" \
  "tracks #$EPIC_AI\n\nConfigure AI provider abstraction and version prompt templates for traceability." \
  "type:feature,area:api,area:worker,priority:p1" >/dev/null

ensure_issue \
  "Classify messages into important/newsletter/promotion/other" \
  "tracks #$EPIC_AI\n\nImplement classification pipeline and category assignment in background processing." \
  "type:feature,area:worker,priority:p1" >/dev/null

ensure_issue \
  "Persist classification results and confidence" \
  "tracks #$EPIC_AI\n\nSave model classifications with confidence and expose via API contract." \
  "type:task,area:api,area:infra,priority:p1" >/dev/null

ensure_issue \
  "Build inbox list page in web app" \
  "tracks #$EPIC_UX\n\nCreate inbox list UI that renders normalized message feed from API." \
  "type:feature,area:web,priority:p1" >/dev/null

ensure_issue \
  "Show classification badges and suggested actions" \
  "tracks #$EPIC_UX\n\nDisplay category badges and recommended actions in inbox message rows." \
  "type:task,area:web,priority:p1" >/dev/null

ensure_issue \
  "Add archive/label action endpoints + UI trigger" \
  "tracks #$EPIC_UX\n\nAdd API + web wiring for archive/label actions and optimistic UI state." \
  "type:feature,area:api,area:web,priority:p1" >/dev/null

ensure_issue \
  "Add provider capability matrix endpoint (labels/folders support)" \
  "tracks #$EPIC_UX\n\nExpose provider capabilities so the UI can enable or hide unsupported actions." \
  "type:task,area:api,area:provider-sdk,priority:p1" >/dev/null

echo "Done."
echo "Epics: #$EPIC_AUTH, #$EPIC_SYNC, #$EPIC_AI, #$EPIC_UX"
