#!/usr/bin/env zsh

stack build && stack exec service-exe &
cd ui
./ui-devel
