#!/bin/sh
rm luacov*.out; busted --coverage && luacov "^init.lua" "^widgets/" "^tools.lua"
