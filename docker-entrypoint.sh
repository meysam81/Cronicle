#!/bin/bash

set -e

cd /opt/cronicle

if [ ! -f "./data/users/0.json" ]; then
    echo "Initializing Cronicle storage..."
    bun run bin/storage-cli.js setup
    echo "Storage initialization complete."
fi

echo "Starting Cronicle server..."
exec bun run lib/main.js
