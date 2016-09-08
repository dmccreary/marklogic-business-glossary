xquery version "1.0";

import module namespace style='http://danmccreary.com/style' at '/modules/style.xqm';

let $title := 'List Concepts'

let $concepts := /skos:concepts/skos:concept

let $content := 
    <div class="content">
       <ol>
      {for $concept in $concepts
       return
       <li>
          {$concept/skos:prefLabel/text()} - {$concept/skos:definition/text()}
       </li>
       }
       </ol>
    </div>                                           

return style:assemble-page($title, $content)