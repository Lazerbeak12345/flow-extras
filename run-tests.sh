#!/bin/sh
rm -f luacov*.out
busted --coverage && luacov "^init" "^tools" "^widgets"
# Keep above in sync with github workflows
