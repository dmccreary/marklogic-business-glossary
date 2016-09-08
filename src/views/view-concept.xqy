xquery version "1.0-ml";
import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";
declare namespace skos="http://www.w3.org/2004/02/skos/core#";

let $title := 'View Concept'

let $uri := xdmp:get-request-field('uri')

return
  if (not($uri))
     then
     <error code="404">
        <message>Error. {$uri} is a required parameter</message>
     </error> else 

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