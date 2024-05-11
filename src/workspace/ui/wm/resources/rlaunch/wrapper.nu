#!/usr/bin/env nu

rlaunch ...(open $'($env.HOME)/.config/rlaunch/args' --raw | (split row ' '))
