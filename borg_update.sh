#!/bin/sh

# use the same SCRIPT_DIR from the last conversation
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

# Run git pull on the SCRIPT_DIR folder
cd "$SCRIPT_DIR" && git pull