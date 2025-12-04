#!/bin/zsh

# Neovim Open
# Open current neovim project

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
if [[ -n "$project_dir/compile_commands.json" ]]; then
	if [[ ! -x "$project_dir"/* ]] || [[ "$project_dir/Makefile" -nt "$project_dir"/* ]]; then
		(cd "$project_dir" && bear -- make)
	fi
fi
if [[ -f "$project_dir/Makefile" ]]; then
	nvim -c "lua vim.defer_fn(function() vim.cmd('Neotree $WDIR reveal_file=${project_dir}/Makefile') end, 100)"
else
	nvim -c "lua vim.defer_fn(function() vim.cmd('Neotree $WDIR dir=$project_dir') end, 100)"
fi
