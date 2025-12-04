#!/bin/zsh

# New Project Wrapper

echo "Ｏ＿ＲＯＦＦ  Ｐｒｏｊｅｃｔ  Ｂｕｉｌｄｅｒ"
echo
# Set project type e.g. C, CPP
if [ -n "$1" ]; then
	if [ "$1" = "-c" ]; then
		local type="C"
	elif [ "$1" = "-cpp" ]; then
		local type="CPP"
	else
		echo "Error: No type specified"
		echo "Usage: <script> -<type> <name>"
		exit 1
	fi
	echo "Project Type: $type"
fi

# Set project name
if [ -n "$2" ]; then
	local project_name="$2"
	echo "Project name: $project_name"
else
	echo "Error: No project name provided"
	echo "Usage: <script> -<type> <name>"
	exit 1
fi
if [ -e "$PWD/${project_name}" ]; then
	echo "Error: Project '${project_name}' already exists!" >&2
fi

# Run project builder, update shell (.zshrc) and load project
$WDIR/shell_scripts/new_c_project.sh "$project_name"
local DST="$PWD/${project_name}/${project_name}_public"
echo "Opening project..."
echo
$WDIR/shell_scripts/neovim_load.zsh "$DST"
