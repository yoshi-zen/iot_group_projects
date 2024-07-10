#!/bin/sh

OUTPUT=$(/usr/lib/bin/sample)
OUTPUT1=$(/usr/lib/sample02)
OUTPUT2=$(/usr/lib/bin/sample01)

echo "Content-type: text/html"
echo ""

# ここでOUTPUTの値に基づいて背景画像を決定します
if [ "$OUTPUT2" -gt 65 ] && [ "$OUTPUT2" -lt 70 ]; then
    BACKGROUND_IMAGE="/IoT_image/good.jpg"
elif [ "$OUTPUT2" -gt 55 ] && [ "$OUTPUT2" -lt 80 ]; then
    BACKGROUND_IMAGE="/IoT_image/soso.jpg"
else
    BACKGROUND_IMAGE="/IoT_image/bad.jpg"
fi

echo "<html>"
echo "<head>"
echo "<link href=\"style.css\" rel=\"stylesheet\" type=\"text/css\" media=\"all\">"
echo "<meta http-equiv=\"refresh\" content=\"5\">"  # ページを5秒ごとにリロします
echo "<script>"
echo "function autoReload() {"
echo "    setTimeout(function() {"
echo "        location.reload();"
echo "    }, 5000);"  # 5000ミリ秒 (5秒) 後にページをリロードします
echo "}"
echo "</script>"
echo "<style>"
echo "body {"
echo "    background-image: url('$BACKGROUND_IMAGE');"
echo "    background-size: cover;"
echo "}"
echo "</style>"
echo "</head>"
echo "<body onload=\"autoReload()\">"
echo "<div class=\"field\">"
echo "<b><div class=\"box1 box\">$OUTPUT</div></b>"
echo "<b><div class=\"box2 box\">$OUTPUT1</div></b>"
echo "</div>"
echo "</body>"
echo "</html>"
