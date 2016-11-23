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

let $concept := doc($uri)/skos:concept

let $content := 
    <div class="content">
       <span class="field-label">Preferred Label:</span> {$concept/skos:prefLabel/text()}<br/>
       <span class="field-label">Definition:</span> {$concept/skos:definition/text()}<br/>
    </div>                                           

return style:assemble-page($title, $content)