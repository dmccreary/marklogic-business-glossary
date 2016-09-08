xquery version "1.0-ml";
import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";
declare namespace skos="http://www.w3.org/2004/02/skos/core#";

let $title := 'List Concepts'
let $concepts := /skos:concepts/skos:concept

let $content := 
<div class="content">
   <ol>
  {for $concept in $concepts
   return
   <li>
      <b>{$concept/skos:prefLabel/text()}</b> - {$concept/skos:definition/text()}
   </li>
   }
   </ol>
   
</div>                                           

return style:assemble-page($title, $content)