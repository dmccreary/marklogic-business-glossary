xquery version "1.0-ml";
declare namespace x="http://www.w3.org/1999/xhtml";

let $title := 'pass 2 of screen scrape example'

let $uris := cts:uri-match('/tmp/web-scrape*.xml')



(:
let $first-document := doc($uris[1])
/html/body[1]/div[5]/div[1]/h4[1]/a[1]
:)
let $results :=
<results>{
    for $uri in $uris
    let $doc := doc($uri)
    let $anchors := $doc/x:html/x:body/x:div[5]//x:a
    return
      for $a in $anchors
        let $url := $a/@href/string()
        return
        if (starts-with($url, '//www.smartlogic.com/index.php/glossary/'))
          then <url>http:{$url}</url>
          else ()
}</results>

let $insert := xdmp:document-insert('/tmp/web-scrape/smartlogic/all-urls.xml', $results)
return $results