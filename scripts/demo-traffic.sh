#!/usr/bin/env bash
# Demo: hit cloud.arguswatcher.net for DURATION seconds and show which cloud
# answered each request, with a running tally.

set -euo pipefail

URL="${URL:-https://cloud.arguswatcher.net/api/}"
DURATION="${DURATION:-120}"
SLEEP="${SLEEP:-1}"

end=$(( $(date +%s) + DURATION ))
declare -A count

printf 'GET %s  (duration=%ss, sleep=%ss)\n\n' "$URL" "$DURATION" "$SLEEP"

while [ "$(date +%s)" -lt "$end" ]; do
  cloud=$(curl -s --max-time 5 "$URL" | jq -r '.cloud_provider // "error"')
  count[$cloud]=$(( ${count[$cloud]:-0} + 1 ))
  printf '%s  %-6s   (aws=%d azure=%d error=%d)\n' \
    "$(date +%H:%M:%S)" "$cloud" \
    "${count[aws]:-0}" "${count[azure]:-0}" "${count[error]:-0}"
  sleep "$SLEEP"
done

echo
echo "Final tally:"
for c in "${!count[@]}"; do
  printf '  %-6s %d\n' "$c" "${count[$c]}"
done
