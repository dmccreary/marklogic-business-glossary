xquery version "1.0-ml";
import module namespace search = "http://marklogic.com/appservices/search" at "/MarkLogic/appservices/search/search.xqy";

(: Suggest SKOS Label service.
This service returns a JSON array with all SKOS prefLabel in it. 
It uses search:suggest which assumes a range index on skos:prefLabel
TODO - create a field of both prefLabel and altLabel
:)
declare namespace skos="http://www.w3.org/2004/02/skos/core#";

declare option xdmp:output "method=html";


let $q := xdmp:get-request-field('q')
return
   if (not($q))
     then
        <error>
           <message>Error, q is a required parameter.  Try adding q=per to the URL.</message>
        </error> else (: continue :)

let $content-type := xdmp:set-response-content-type('application/json')
let $debug := xs:boolean(xdmp:get-request-field('debug', 'false'))

(: do a simple word query 
cts:search(/, cts:word-query($q), 'unfiltered')
:)
let $options := 
<search:options xmlns="http://marklogic.com/appservices/search">
 <default-suggestion-source>
   <range collation="http://marklogic.com/collation/codepoint" type="xs:string" facet="true">
      <element ns="http://www.w3.org/2004/02/skos/core#" name="prefLabel"/>
   </range>
 </default-suggestion-source>
</search:options>

let $strings := search:suggest($q, $options, 30)

let $sorted-preferred-lables :=
  for $label in $strings
  order by $label
  return $label

let $labels-in-quotes :=
   for $label in $sorted-preferred-lables
     return
       if (starts-with($label, '"'))
         then $label
         else concat('"', $label, '"')
     
let $internal-string := string-join($labels-in-quotes, ', ')

let $javascript-array := concat('[', $internal-string, ']')

return
   if ($debug)
      then
         ('Q', $q, 'Labels:', $sorted-preferred-lables)
      else $javascript-array