xquery version "1.0-ml";
import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";
import module namespace se = "http://danmccreary.com/skos-to-entities" at "/modules/skos-to-entities.xqy";

declare namespace skos="http://www.w3.org/2004/02/skos/core#";
declare option xdmp:output "method=html";

let $title := 'List Entities'
let $start := xs:positiveInteger(xdmp:get-request-field('start', '1'))
let $page-length := xs:positiveInteger(xdmp:get-request-field('page-length', '10'))
(: we could just use /skos:concept :)
let $all-concepts := cts:search(/skos:concept, cts:element-value-query(xs:QName('skos:entity'), 'true'), ('unfiltered', 'score-zero'), 0)
let $concept-count := count($all-concepts)

let $sorted-concepts :=
  for $concept in $all-concepts
  order by $concept/skos:prefLabel
  return $concept
  
let $content := 
<div class="content">
   <span class="field-label">Total Entity Count:</span> {format-number($concept-count, '#,###')}<br/>
   {style:prev-next-pagination-links($start, $page-length, $concept-count)}

      {for $concept at $count in subsequence($sorted-concepts, $start, $page-length)
       let $uri := xdmp:node-uri($concept)
       let $prefLabel := $concept/skos:prefLabel/text()
       return
         <div class="concept-div">
            {$start + $count - 1}). <b>{$prefLabel}</b> - {$concept/skos:definition/text()}
            
            <h5>Properties</h5>
            {for $property in se:properites($concept/skos:prefLabel/text())
             return
                <div class="property-name"><a href="/views/view-concept.xqy?uri={se:prefLabel-to-uri($property)}">{$property}</a></div>
            }
            <a class="btn btn-info" role="button" href="/views/view-concept.xqy?uri={$uri}">View {$prefLabel} Details</a>

         </div>
       }

   Elapsed Time: {xdmp:elapsed-time() div xs:dayTimeDuration('PT1S') } seconds.
</div>                                           

return style:assemble-page($title, $content)