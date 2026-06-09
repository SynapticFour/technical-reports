#!/usr/bin/env bash
# Re-notify Zenodo about an existing GitHub Release (needed when the release
# was created before Zenodo integration was enabled).
#
# 1. Flip ON at https://zenodo.org/account/settings/github/ for technical-reports
# 2. GitHub → technical-reports → Settings → Webhooks → Zenodo → copy access_token from URL
# 3. export ZENODO_HOOK_TOKEN='...'
# 4. ./scripts/trigger-zenodo-release.sh SF-TR-2026-001-v1.0.0
#
# Alternative: edit the release notes on GitHub (trivial change) to fire the webhook.
set -euo pipefail

RELEASE_TAG="${1:?Release tag required, e.g. SF-TR-2026-001-v1.0.0}"
REPO="${GITHUB_REPO:-SynapticFour/technical-reports}"
TOKEN="${ZENODO_HOOK_TOKEN:?Set ZENODO_HOOK_TOKEN from the Zenodo webhook URL on GitHub}"
ZENODO_HOOK="${ZENODO_HOOK_URL:-https://zenodo.org/api/hooks/receivers/github/events/}"

if ! command -v gh >/dev/null 2>&1; then
  echo "gh CLI required" >&2
  exit 1
fi

echo "Fetching release ${RELEASE_TAG} from ${REPO}..."
RELEASE_JSON=$(gh api "repos/${REPO}/releases/tags/${RELEASE_TAG}")
REPO_JSON=$(gh api "repos/${REPO}")

PAYLOAD=$(jq -n \
  --argjson release "$RELEASE_JSON" \
  --argjson repository "$REPO_JSON" \
  '{action: "published", release: $release, repository: $repository}')

echo "Posting to Zenodo hook..."
HTTP=$(curl -fsS -o /tmp/zenodo-hook-response.json -w '%{http_code}' \
  -X POST "${ZENODO_HOOK}?access_token=${TOKEN}" \
  -H 'Content-Type: application/json' \
  -d "$PAYLOAD")

echo "Zenodo responded HTTP ${HTTP}"
cat /tmp/zenodo-hook-response.json
echo
echo "Check Zenodo uploads in a few minutes: https://zenodo.org/me/uploads"
