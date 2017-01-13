xquery version "1.0-ml";
import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";
declare namespace skos="http://www.w3.org/2004/02/skos/core#";
declare option xdmp:output "method=html";

let $title := 'List Concepts'
let $start := xs:positiveInteger(xdmp:get-request-field('start', '1'))
let $page-length := xs:positiveInteger(xdmp:get-request-field('page-length', '10'))
(: we could just use /skos:concept :)
let $all-concepts := cts:search(/skos:concept, cts:true-query(), ('unfiltered', 'score-zero'), 0)
let $concept-count := count($all-concepts)

let $sorted-concepts :=
  for $concept in $all-concepts
  order by $concept/skos:prefLabel
  return $concept
  
let $content := 
<div class="content">
   <span class="field-label">Total Concept Count:</span> {format-number($concept-count, '#,###')}<br/>
   {style:prev-next-pagination-links($start, $page-length, $concept-count)}

      {for $concept at $count in subsequence($sorted-concepts, $start, $page-length)
       let $uri := xdmp:node-uri($concept)
       return
         <div class="concept-div">
            {$start + $count - 1}). <a href="/views/view-concept.xqy?uri={$uri}"><b>{$concept/skos:prefLabel/text()}</b></a> - {$concept/skos:definition/text()}
         </div>
       }

   Elapsed Time: {xdmp:elapsed-time() div xs:dayTimeDuration('PT1S') } seconds.
</div>                                           

return style:assemble-page($title, $content)