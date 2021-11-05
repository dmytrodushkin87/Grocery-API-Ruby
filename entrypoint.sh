#!/bin/bashset -e 
# Remove a potentially pre-existing server.pid for Rails.
set -e

rm -f /grocery-api_test/tmp/pids/server.pid
# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"