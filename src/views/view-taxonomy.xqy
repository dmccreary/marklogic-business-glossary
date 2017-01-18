xquery version "1.0-ml";
import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";

declare namespace skos="http://www.w3.org/2004/02/skos/core#";
declare option xdmp:output "method=html";

(: recursive function to convert a flat taxomy into a tree :)
declare function local:view-taxonomy($concepts as element()*, $prefLabel as xs:string) as element() {
let $this-concept :=  $concepts[skos:prefLabel=$prefLabel]
let $children := $concepts[skos:broader=$prefLabel]
return
   <li>
       <b>{$prefLabel}</b>
       {if ($children)
          then
             <ol>{
             for $child in $children
             return
               local:view-taxonomy($concepts, $child/skos:prefLabel)
            }</ol>
            else ()
        }
   </li>
};

let $title := 'View Taxonomy'
let $uri := xdmp:get-request-field('uri', '/inputs/taxonomies/sample-taxonomy.xml')
let $concepts := doc($uri)/skos:Concepts/skos:Concept
let $root := xdmp:get-request-field('root', 'Thing')

let $set-header := xdmp:set-response-content-type('text/html')

let $content :=
<div class="content">
     Displaying Taxonomy for: {$uri}<br/>
     Concept Count: {count($concepts)}<br/>
     <ol>
       {local:view-taxonomy($concepts, $root)}
     </ol>
  </div>
  
return style:assemble-page($title, $content)