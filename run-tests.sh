#!/bin/sh
rm -f luacov*.out
busted --coverage && luacov "^[^/.s]"
# Above is ugly hack to ignore ./spec/
# Keep in sync with github workflows
