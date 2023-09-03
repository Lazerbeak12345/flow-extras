#!/bin/sh
rm -f luacov*.out
busted --coverage && luacov "^init.lua" "^widgets/" "^tools.lua"
# Be sure to apply changes to luacov to the CI as well
