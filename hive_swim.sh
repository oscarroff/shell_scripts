#!/bin/sh

# A very nice little script to fetch and display the current sea temparature
# at the carpet jetty on Sörnäisten rantatie, the closest swimming spot
# for Hive, Helsinki
# Written for sh but easily portable to your shell of choice
# Also ironically written in the middle of a snowy winter
#
# Oscar Roff January 2026

# Define fonts
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
BOLD='\033[1;37m'
NC='\033[0m'

# Fetch data
feed_url="https://iot.fvh.fi/opendata/uiras/70B3D57050011458.geojson"
feed_data=$(curl -sk "$feed_url")

# Helper function for parsing data
json_get() {
    echo "$1" | python3 -c "import sys, json; print(json.load(sys.stdin)$2)"
}

# Fetch water temperature
temp_water=$(json_get "$feed_data" "['properties']['measurement']['temp_water']")

# Print output
echo "O _ R O F F   H i v e   S w i m ?"
echo "Source: https://uiras.fvh.io/"
echo
if [ $(echo "$temp_water < 0" | bc -l) -eq 1 ]; then
	echo "Clearly not, even the thermometer has left the water."
elif [ $(echo "$temp_water >= 0" | bc -l) -eq 1 ] \
	&& [ $(echo "$temp_water < 1" | bc -l) -eq 1 ]; then
	echo "${BLUE}Watch out for the icebergs!"
elif [ $(echo "$temp_water >= 1" | bc -l) -eq 1 ] \
	&& [ $(echo "$temp_water < 15" | bc -l) -eq 1 ]; then
	echo "${CYAN}Brave souls only."
elif [ $(echo "$temp_water >= 15" | bc -l) -eq 1 ] \
	&& [ $(echo "$temp_water < 22" | bc -l) -eq 1 ]; then
	echo "${GREEN}What are you waiting for?"
elif [ $(echo "$temp_water > 22" | bc -l) -eq 1 ] \
	&& [ $(echo "$temp_water <= 30" | bc -l) -eq 1 ]; then
	echo "${YELLOW}Err what? Somebody left the hot tap on."
elif [ $(echo "$temp_water > 30" | bc -l) -eq 1 ]; then
	echo "${RED}If you're seeing this, we're doomed and the oceans have evaporated."
fi
echo "${NC}The water off mattolaituri is currently ${BOLD}${temp_water}°C${NC}"
