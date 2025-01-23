#!/bin/bash

QUARTZ_DIR="$HOME/Notes/publish/quartz"
COMMAND="npx quartz build --serve"

echo "Checking directory: $QUARTZ_DIR"
echo "Contents:"
ls -la "$QUARTZ_DIR"

if [ -d "$QUARTZ_DIR" ] && [ -f "$QUARTZ_DIR/package.json" ]; then
  (
    cd "$QUARTZ_DIR" || exit 1
    echo "Running command: $COMMAND"
    $COMMAND
  )
else
  echo "Error: $QUARTZ_DIR does not exist or is missing a package.json file."
  exit 1
fi
