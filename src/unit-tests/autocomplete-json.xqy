xquery version "1.0-ml";
import module namespace search = "http://marklogic.com/appservices/search" at "/MarkLogic/appservices/search/search.xqy";

(: this service returns a JSON document with all the labels in it :)
declare namespace skos="http://www.w3.org/2004/02/skos/core#";

declare option xdmp:output "method=json";
let $content-type := xdmp:set-response-content-type('application/json')

let $q := xdmp:get-request-field('q')
let $debug := xs:boolean(xdmp:get-request-field('debug', 'false'))

return
  if (not($q))
     then ()
     else (: continue :)

let $options := 
<search:options xmlns="http://marklogic.com/appservices/search">
 <default-suggestion-source>
   <range type="xs:string" facet="true">
      <element ns="http://www.w3.org/2004/02/skos/core#" name="prefLabel"/>
   </range>
 </default-suggestion-source>
</search:options>

let $strings := search:suggest($q, $options, 30)

(: our data sources might have quotes in the labels :)
let $sorted-preferred-lables :=
  for $label in $strings
  order by $label
  return '"' || replace($label, '"', '') || '"'

let $labels-in-quotes :=
   for $label in $sorted-preferred-lables
     return $label
     
let $internal-string := string-join($labels-in-quotes, ', ')

let $javascript-array := concat('[', $internal-string, ']')

return
   if ($debug)
      then
         ('Q', $q, 'Labels:', $sorted-preferred-lables)
      else $javascript-array