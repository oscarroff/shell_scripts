#!/bin/zsh

# Neovim Load
# Open current neovim project and load all src and inc files into buffer

if [[ $# -eq 0 ]]; then
	local project_dir="$PWD"
else
	local project_dir="$1"
fi
if [[ ! -d "$project_dir" ]]; then
	echo "Error: Directory does not exist: $project_dir" >&2
	exit 1
fi
local project_name=$(basename "$project_dir" | sed 's/_public$//')
if [[ ! -f "$project_dir/compile_commands.json" ]] \
	|| grep -q '\[[^]]*\]' "$project_dir/compile_commands.json"; then
	if [[ ! -x "$project_dir"/* ]] || [[ "$project_dir/Makefile" -nt "$project_dir"/* ]]; then
		(cd "$project_dir" && bear -- make)
	fi
fi
if [[ -d "$project_dir/src" ]] && [[ -f "$project_dir/src/main.c" ]]; then
	nvim -c "cd $project_dir" \
	-c 'args src/**/*.{c,h}' \
	-c 'argadd inc/**/*.{c,h}' \
	-c 'edit src/main.c' \
	-c "lua vim.defer_fn(function() vim.cmd('Neotree $WDIR reveal_file=${project_dir}/src/main.c') end, 100)"
else
	nvim -c "cd $project_dir" \
	-c 'args src/**/*.{c,h}' \
	-c 'argadd inc/**/*.{c,h}' \
	-c "lua vim.defer_fn(function() vim.cmd('Neotree $WDIR dir=$project_dir') end, 100)"
fi
