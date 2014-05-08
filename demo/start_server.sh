#!/bin/bash
#
# Run a local http server from this directory on port 8000
#
PORT=8000

if [ -z `which python` ]; then
  echo "FATAL: python must be installed"
  exit 1
fi

python -m SimpleHTTPServer $PORT