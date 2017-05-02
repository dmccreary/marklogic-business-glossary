xquery version "1.0-ml";
declare namespace x="http://www.w3.org/1999/xhtml";

let $title := 'pass 3 of screen scrape example'

let $urls := doc('/tmp/web-scraper/smartlogic/all-urls.xml')/results/url/text()

return
<concepts>
 {for $url in $urls
  let $doc := xdmp:tidy(xdmp:http-get($url[1])[2])[2]/x:html/x:body/x:div[3]/x:div[1]
  return
     <concept>
        <prefLabel>{$doc//x:h1/x:a/text()}</prefLabel>
        <definition>{$doc//x:p/text()}</definition>
     </concept>
   }
</concepts>
