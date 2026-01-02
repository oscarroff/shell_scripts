#!/bin/zsh

# A very nice little script to fetch and display the poem of the day from
# the even nicer blog tinywords.com
# Written for zsh but easily portable to your shell of choice
#
# Oscar Roff December 2025

feed_url="https://tinywords.com/feed/"
feed_data=$(curl -s "$feed_url")

decode_html() {
	sed 's/&quot;/"/g; s/&apos;/'\''/g; s/&lt;/</g; s/&gt;/>/g; s/&#39;/'\''/g; s/&#8217;/'\''/g; s/&#8216;/'\''/g; s/&#8220;/"/g; s/&#8221;/"/g; s/&#8211;/–/g; s/&#8212;/—/g; s/&nbsp;/ /g; s/&amp;/\&/g;'
}

echo "Ｏ＿ＲＯＦＦ  Ｔｉｎｙ  Ｐｏｅｍ  ｏｆ  ｔｈｅ  Ｄａｙ"
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
	| decode_html)"
