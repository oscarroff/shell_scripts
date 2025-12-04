#!/bin/bash

# Shell script for starting a new C project, developed while studying at Hive, Helsinki
# Usage:
# - the script expects 1 argument giving the project name
# - follow the prompts to set up the rest of the project
# - WIP stands for Work-in-Progress, an envp used for a set of shell alias shortcuts
# - add alias sets up a "cd $(project)" shortcut
# - Git repo expects a URL to an active repository
# - If Libft (a custom C library) is required, it is either cloned from its own repository (preferred) or copied locally
#
# Oscar Roff December 2025

# Error check: setup relies upon knowing the working directory and having access
if [ -z "$WDIR" ]; then
	echo "WDIR not set" >&2
	return 2 2>/dev/null || exit 2
fi
if [ ! -d "$WDIR/template" ]; then
	echo "No such directory: $WDIR/template" >&2
	return 2 2>/dev/null || exit 2
fi
SRC="$(cd "$WDIR/template" && pwd -P)" || { echo "Error: cannot fetch paths" >&2; exit 2; }
PWD_REAL="$(pwd -P)" || { echo "Error: cannot fetch paths" >&2; exit 2; }
EXCLUDE="new_project.sh"

# Error check: setup cannot occur inside template directory (danger of recursion)
if [[ "$PWD_REAL" == "$SRC"* ]]; then
	echo "Project creation not possible inside template directory!"
	exit 1
fi

# Error check: setup cannot occur inside template directory (danger of recursion)
if [[ "$PWD_REAL" == "$WDIR/libft"* ]]; then
	echo "Project creation not possible inside libft directory!"
	exit 1
fi

project_name="$1"
if [ -z "$project_name" ]; then
	echo "Error: No project name provided" >&2
	exit 1
fi
DST="$PWD/${project_name}/${project_name}_public"
mkdir -p -- "$DST"

# Input prompts
echo -n "Make WIP? [Y/n]: "
read -r work_in_progress
if [ "${work_in_progress}" = "Y" ] || [ "${work_in_progress}" = "y" ]; then
	perl -pi -e "s|(export WIP=).*|\1${DST}|" "$HOME/.zshrc"
fi

echo -n "Add alias? (blank for no, [Y] for project name): "
read -r zsh_alias
if [ "${zsh_alias}" = 'Y' ] || [ "${zsh_alias}" = 'y' ]; then
	perl -pi -e "print \"alias ${project_name}=\\\"cd ${DST}\\\"\n\" if /##ALIAS/" "$HOME/.zshrc"
elif [ -n "${zsh_alias}" ]; then
	perl -pi -e "print \"alias ${zsh_alias}=\\\"cd ${DST}\\\"\n\" if /##ALIAS/" "$HOME/.zshrc"
fi

echo -n "Git repo? (blank for local): "
read -r git_hub_origin
echo -n "Include libft? [Y/n]: "
read -r libft_inc
echo

# Copy template files to new project (excluding this script if found inside template directory)
echo "Copying template..."
for f in "$SRC"/*; do
	[ "$(basename -- "$f")" = "$EXCLUDE" ] && continue
	cp -a "$f" "$DST/" >/dev/null 2>&1 || true
done
cp -a "$SRC/.gitignore" "$DST/" >/dev/null 2>&1 || true

# Rename variables and files from "template" to "project_name"
echo "Setting up project..."
grep -rlI 'template' "$DST" | xargs -r perl -pi -e "
	s|template|${project_name}|g;
	s|TEMPLATE|\U${project_name}\E|g;
	"
( cd "$DST/src" && for f in template.*; do [ -e "$f" ] \
	&& mv "$f" "${f/template/$project_name}"; done ) 2>/dev/null || true
( cd "$DST/inc" && for f in template.*; do [ -e "$f" ] \
	&& mv "$f" "${f/template/$project_name}"; done ) 2>/dev/null || true

# Clone libft from git repo (preferred) or local copy
if [ "${libft_inc}" = "Y" ] || [ "${libft_inc}" = "y" ]; then
	echo "Copying libft..."
	if ssh -T git@github.com 2>&1 | grep -q "success"; then
		git clone git@github.com:thomas-roff/hive_mylib.git "${DST}/libft" >/dev/null 2>&1 \
			|| echo "⚠ Warning: Git clone of libft failed" >&2
		rm -rf "${DST}/libft/.git" "${DST}/libft/tst" 2>/dev/null || true
	else
		mkdir $DST/libft
		mkdir $DST/libft/src
		mkdir $DST/libft/inc
		libft_src="$WDIR/libft"
		libft_dst="$DST/libft"
		cp -a "${libft_src}/Makefile" "${libft_dst}/" >/dev/null 2>&1 || true
		cp -a "${libft_src}/inc/libft.h" "${libft_dst}/inc/" >/dev/null 2>&1 || true
		for f in "${libft_src}/src"/*; do
			[ "$(basename -- "$f")" = "$EXCLUDE" ] && continue
			cp -a "$f" "${libft_dst}/src" >/dev/null 2>&1 || true
		done
	fi
fi

# Optional: setup git repo
if [ -n "$git_hub_origin" ]; then
	echo "Initializing git..."
	(
	cd "$DST" || { echo "Error: cannot change to project directory" >&2; exit 1; }
	git init
	git add .
	git commit -m "1st commit"
	git branch -M main
	git remote add origin "$git_hub_origin"
	git push -u origin main
	) || echo "⚠ Warning: Git initialization failed" >&2
fi
