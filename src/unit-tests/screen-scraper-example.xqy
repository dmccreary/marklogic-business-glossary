xquery version "1.0-ml";
declare namespace x="http://www.w3.org/1999/xhtml";

declare option xdmp:output "method=html";

declare function local:get-html-page($letter as xs:string) as element() {
  let $url-prefix := 'http://www.smartlogic.com/glossary?f='
  let $url := $url-prefix || $letter
  let $page := xdmp:tidy(xdmp:http-get($url)[2])[2]/x:html
  let $save-url := '/tmp/web-scrape/smartlogic/' || $letter || '.xml'
  let $insert := xdmp:document-insert($save-url, $page)
  return <ok>{$url}</ok>
};



let $number-for-a := string-to-codepoints('b')
let $number-for-z := string-to-codepoints('z')

let $get-all-letters :=
   for $number in ($number-for-a to $number-for-z)
    let $letter := codepoints-to-string($number)
    return
    local:get-html-page($letter)

return
<results>{$get-all-letters}</results>