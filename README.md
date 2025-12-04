# shell_scripts
Some cute scripts and curiosities written for bash and zsh

## tinypoem_of_the_day
A very nice little Zsh script to fetch and display the poem of the day from
the even nicer blog [tinywords](tinywords.com), please check them out!
This was a first attempt at fetching data from a website using a shell script. The function `xmllint` came in especially handy for parsing the xml source. `perl` also proved useful for formatting HTML text.
Written for zsh but easily portable to your shell of choice

*Oscar Roff December 2025*

## cproject_build
A Bash script for starting a new C project, developed while studying at Hive, Helsinki.
Usage:
- The script expects 1 argument giving the project name
- Follow the prompts to set up the rest of the project
- `$WIP` stands for Work-in-Progress, an envp used for a set of shell alias shortcuts
- Add alias sets up a `cd $(project)` shortcut
- Git repo expects a URL to an active repository
- If Libft (a custom C library) is required, it is either cloned from its own repository (preferred) or copied locally
This script can optionally be used with a Zsh wrapper script called project_build_wrapper.zsh that makes room for future scripts adapted to other languages (e.g. CPP, likely the first addition) that could be specified with a flag (e.g. -c, -cpp etc.).

*Oscar Roff November 2025*

## neovim_open & neovim_load
Two simple Zsh scripts for making opening projects with Neovim quicker.
Usage:
- Use without argument to open the current directory (`$PWD`) OR
- Specify a `/path/to/directory` with an argument
Both scripts check if a compilation database exists for the project (`compile_commands.json`) and recompiles if necessary before opening. The open script simply focuses `Neotree` on the project's Makefile or project directory. While the load script (as the name suggests) loads all the project's `*.{c,h}` (.c and .h files) into the Neovim buffer and focuses the main.c (if it exists) or the project directory.

*Oscar Roff November 2025*
