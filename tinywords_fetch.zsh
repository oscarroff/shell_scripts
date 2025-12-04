#!/bin/zsh

# A very nice little script to fetch and display the poem of the day from
# the even nicer blog tinywords.com
# Written for zsh but easily portable to your shell of choice
#
# Oscar Roff December 2025

feed_url="https://tinywords.com/feed/"
feed_data=$(curl -s "$feed_url")

echo "Ｏ＿ＲＯＦＦ  Ｐｏｅｍ  ｏｆ  ｔｈｅ  Ｄａｙ"
echo "Source: https://tinywords.com/"
echo
echo "Published: $(echo "$feed_data" \
	| xmllint --xpath '//item[1]/pubDate/text()' \
	- 2>/dev/null \
	| awk '{print $1, $2, $3, $4}')"
echo "Author: $(echo "$feed_data" \
	| xmllint --xpath 'string(//item[1]/*[local-name()="creator"])' \
	- 2>/dev/null)"
echo "Issue: $(echo "$feed_data" \
	| xmllint --xpath 'string(//item[1]/category)' \
	- 2>/dev/null \
	| sed 's/Issue //')"
echo
echo "$(echo "$feed_data" \
	| xmllint --xpath 'string(//item[1]/description)' \
	- 2>/dev/null \
	| perl -MHTML::Entities -C -pe 'decode_entities($_);')"
