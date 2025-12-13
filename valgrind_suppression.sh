#!/bin/bash

shopt -s nullglob
args=()
for supp in *.supp; do
	args+=(--suppressions="$supp")
done
valgrind --leak-check=full "${args[@]}" "$@"
