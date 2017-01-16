xquery version "1.0-ml";
import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";
declare namespace skos="http://www.w3.org/2004/02/skos/core#";
declare option xdmp:output "method=html";


let $title := 'List Concepts A-Z'

let $starts-with := xdmp:get-request-field('starts-with', 'A')
let $filter := 'starts-with=' || $starts-with
let $start := xs:positiveInteger(xdmp:get-request-field('start', '1'))
let $page-length := xs:positiveInteger(xdmp:get-request-field('page-length', '10'))
(: we could just use /skos:concept :)

let $all-concepts := cts:search(/skos:concept, cts:true-query(), ('unfiltered', 'score-zero'), 0)
let $total-concept-count := count($all-concepts)

let $filtered-concepts :=
  for $concept in $all-concepts
   let $pref-label := $concept/skos:prefLabel
   return
      if (starts-with($pref-label, $starts-with))
         then $concept
         else ()
let $filtered-concept-count := count($filtered-concepts)

let $sorted-concepts :=
  for $concept in $filtered-concepts
   order by $concept/skos:prefLabel
   return
      $concept

let $number-for-a := string-to-codepoints('A')
let $number-for-z := string-to-codepoints('Z')
   
let $content := 
<div class="content">
   <div class="letter-bar">
   {for $number in ($number-for-a to $number-for-z)
      let $letter := codepoints-to-string($number)
      return
         <a href="{xdmp:get-request-path()}?starts-with={$letter}">{$letter}</a>
   }
   </div>
   <h4>Concepts that start with "{$starts-with}"</h4>
   <span class="field-label">Total Concept Count:</span> {format-number($total-concept-count, '#,###')}<br/>
   <span class="field-label">Filtered Concept Count:</span> {format-number($filtered-concept-count, '#,###')}<br/>
   
   {style:prev-next-pagination-links($start, $page-length, $filtered-concept-count, $filter)}

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