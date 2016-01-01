#!/usr/bin/env zsh

stack exec service-exe &
cd ui
./ui-devel
