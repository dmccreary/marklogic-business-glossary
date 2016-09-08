xquery version "1.0-ml";
import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";

declare namespace skos="http://www.w3.org/2004/02/skos/core#";
let $title := 'Split Concepts'

let $concepts := /skos:concepts/skos:concept

let $uris :=
   for $concept in $concepts
   let $lc-pref-label := replace($concept/skos:prefLabel, ' ', '-')
   let $uri := '/concepts/' || lower-case($lc-pref-label) || '.xml'
   let $insert := xdmp:document-insert($uri, $concept)
   return 
      $uri

let $content := 

    <div class="content">
       <h4>Split Concepts</h4>
       {count($concepts)} concepts inserted.
       {for $uri in $uris
        return
           <div>
              <a href="/views/view-xml.xqy?uri={$uri}">{$uri}</a>
           </div>
       }
    </div>                                           

return style:assemble-page($title, $content)