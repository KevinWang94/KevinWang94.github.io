function get_url ()
{
    curl 'https://ctrlq.org/google/photos/graph.php' \
     -H 'Connection: keep-alive' \
     -H 'Accept: */*' \
     -H 'DNT: 1' \
     -H 'X-Requested-With: XMLHttpRequest' \
     -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.129 Safari/537.36' \
     -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' \
     -H 'Origin: https://ctrlq.org' \
     -H 'Sec-Fetch-Site: same-origin' \
     -H 'Sec-Fetch-Mode: cors' \
     -H 'Sec-Fetch-Dest: empty' \
     -H 'Referer: https://ctrlq.org/google/photos/' \
     -H 'Accept-Language: en-US,en;q=0.9' \
     -s \
     --data "googlephotos=$1" \
     --compressed \
	| jq -r '.image'
}

function fix_file () {
while read line
do
    if [[ "$line" =~ \!\[\]\((https://photos.app.goo.gl.*)\) ]];
    then
	photo=$(get_url "${BASH_REMATCH[1]}")
	echo "![]($photo)"
    else
	echo $line
    fi
    
done
}

file=$1
cp "$file" "$file.bak"

cat "$file.bak" | fix_file > "$file"
