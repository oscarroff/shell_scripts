#!/bin/sh

# You've had a productive morning at Hive, Helsinki but now the belly begins to rumble,
# and disaster! You've forgotten your lunchbox at home. But wait, there's a canteen
# across the road. So what's on the menu?
#
# Oscar Roff January 2026

# Define fonts
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
BOLD='\033[1;37m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
NC='\033[0m'

# Fetch data
feed_url="https://www.compass-group.fi/menuapi/feed/json?costNumber=3067&language=en"
feed_data=$(curl -s "$feed_url")

# Helper function for parsing data
json_get() {
	printf '%s' "$feed_data" | python3 -c "import sys, json; print(json.load(sys.stdin)$2)"
}

# Get today's date in readable format
today_date=$(python3 -c "
from datetime import datetime
print(datetime.now().strftime('%a, %d %b %Y'))
")

# Check if today's menu exists
menu_exists=$(printf '%s' "$feed_data" | python3 -c "
import sys, json
from datetime import datetime
data = json.load(sys.stdin)
today = datetime.now().strftime('%Y-%m-%d')

for day in data['MenusForDays']:
    if today in day['Date'] and day. get('SetMenus'):
        print('yes')
        break
")

# Helper function for parsing today's menu
get_meal() {
    printf '%s' "$feed_data" | python3 -c "
import sys, json
from datetime import datetime
data = json.load(sys.stdin)
today = datetime.now().strftime('%Y-%m-%d')
meal_name = '$1'

for day in data['MenusForDays']:
    if today in day['Date']:
        for item in day.get('SetMenus', []):
            if item.get('Name') == meal_name:
                components = item.get('Components', [])
                print(', '.join(components))
                break
        break
"
}

echo "Ｏ＿ＲＯＦＦ  ＴｅａＫ  Ｍｅｎｕ"
echo
# Check if menu exists for today
if [ "$menu_exists" != "yes" ]; then
    echo "${RED}No menu found for today's date! ${NC}Looks like you'll have to use your legs and your imagination."
    exit 0
fi

# Fetch meals
vegetarian=$(get_meal "Vegetarian lunch")
vegan=$(get_meal "Vegan lunch")
meat=$(get_meal "Lunch")
soup=$(get_meal "Vegan soup")
dessert=$(get_meal "Dessert")

echo "${NC}Today's lunch at ${BOLD}Kookos, TEAK${NC} on ${today_date}"
echo "${BLUE}Vegan: ${NC}${vegan}"
echo "${GREEN}Vegetarian: ${NC}${vegetarian}"
echo "${RED}Meat: ${NC}${meat}"
echo "${CYAN}Soup: ${NC}${soup}"
echo "${YELLOW}Dessert: ${NC}${dessert}"
