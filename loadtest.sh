#!/usr/bin/env bash
# Staged load test for GET /api/count; stages are 70 s apart so each one lands in its own CloudWatch minute.
# Usage: ./loadtest.sh [cloudfront-domain]   (default: terraform output of infra/)

DOMAIN="${1:-$(terraform -chdir="$(dirname "$0")/infra" output -raw cloudfront_domain_name)}"
URL="https://${DOMAIN}/api/count"

for spec in "200 1" "500 5" "500 10" "500 25" "500 50"; do
  set -- $spec
  echo "=== n=$1 c=$2 start $(date -u +%H:%M:%S)Z"
  ab -q -n "$1" -c "$2" "$URL" 2>&1 | grep -E 'Complete requests|Failed requests|Non-2xx|Requests per second|Time per request.*mean\)|Time taken'
  echo "=== end $(date -u +%H:%M:%S)Z"
  sleep 70
done
curl -s "$URL"; echo
