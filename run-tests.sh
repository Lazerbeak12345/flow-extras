#!/bin/sh
rm -f luacov*.out; busted --coverage && luacov "^init.lua" "^widgets/" "^tools.lua"
