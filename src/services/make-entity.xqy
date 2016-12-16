xquery version "1.0-ml";
import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";
declare namespace skos="http://www.w3.org/2004/02/skos/core#";
declare option xdmp:output "method=html";

(: Given a URL, make the SKOS Concept an abstract entity :)

let $title := "Make Entity"

let $uri := xdmp:get-request-field('uri')
return
   if (not(doc-available($uri)))
     then
        <error>
           <message>Error: Document {$uri} is not available.</message>
        </error> else (: continue :)

let $debug := xs:boolean(xdmp:get-request-field('debug', 'false'))
let $concept := doc($uri)/skos:concept

return
   if ($debug)
      then
         <debug>
            <uri>{$uri}</uri>
            <doc>{$concept}</doc>
         </debug>
      else

let $update :=
   if (exists($concept/skos:entity))
      then xdmp:node-replace($concept/skos:entity/text(), 'true')
      else xdmp:node-insert-child($concept, <skos:entity>true</skos:entity>)

let $content :=
<div>
   The concept {$concept/skos:prefLabel/text()} is now an entity.
   <a href="/views/view-concept.xqy?uri={$uri}">View Concept</a><br/>
   <a href="/views/view-xml.xqy?uri={$uri}">View XML</a>
</div>

return style:assemble-page($title, $content)