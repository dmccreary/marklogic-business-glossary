xquery version "1.0-ml";
import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";
declare namespace skos="http://www.w3.org/2004/02/skos/core#";
declare option xdmp:output "method=html";

let $title := 'View Concept'

let $uri := xdmp:get-request-field('uri')

return
  if (not($uri))
     then
      <error code="400">
         <message>Error. {$uri} is a required parameter</message>
      </error>
     else if (not(doc-available($uri)))
       then
       <error code="404">
          <message>Error. {$uri} is not available.</message>
       </error>
     else 

let $concept := doc($uri)/skos:concept

let $content := 
    <div class="content">
       <div>
          <span class="field-label">Term: </span> {$concept/skos:prefLabel/text()}
       </div>
       <div>
          <span class="field-label">Definition: </span> {$concept/skos:definition/text()}
       </div>
       
      {for $element in $concept/*
       let $element-name := local-name($element)
       return
       if ($element-name ne 'prefLabel' and $element-name ne 'definition')
         then
         <div>
            <span class="field-label">{$element-name}: </span>{$element/text()}
         </div> else ()
       }

    </div>                                           

return style:assemble-page($title, $content)