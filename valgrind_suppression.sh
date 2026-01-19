#!/bin/bash

shopt -s nullglob
args=()
for supp in *.supp; do
	args+=(--suppressions="$supp")
done
valgrind --leak-check=full --show-leak-kinds=all --track-fds=yes --track-origins=yes --trace-children=yes "${args[@]}" "$@"
