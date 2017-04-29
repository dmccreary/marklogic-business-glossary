xquery version "1.0-ml";
declare namespace x="http://www.w3.org/1999/xhtml";

let $url := xdmp:get-request-field('url', 'https://www.cms.gov/apps/glossary/default.asp?Letter=ALL&amp;Language=English')

let $tmp-uri := xdmp:get-request-field('tmp-uri', '/tmp/tidy.xml')

(: only fetch if we are running the first time :)
let $tidy :=
   if (doc-available($tmp-uri))
      then doc($tmp-uri)/x:html
      else
      xdmp:tidy(
       xdmp:document-get($url,
         <options xmlns="xdmp:document-get">
           <format>text</format>
          </options>))[2]

(: only insert if we are running the first time :)
let $insert-if-not-present :=
  if (doc-available($tmp-uri))
     then ()
     else xdmp:document-insert($tmp-uri, $tidy)

let $tables := $tidy//x:table
let $sample-rows := $tables[2]/x:tr//x:table/x:tr
return
<results>
   <table-count>{count($tables)}</table-count>
   <sample-table>
     {for $row in $sample-rows
     return
        <concept>
           <prefLabel>{data($row/x:td[1])}</prefLabel>
           <defintion>{data($row/x:td[2])}</defintion>
        </concept>
     }
   </sample-table>
</results>
