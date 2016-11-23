xquery version "1.0-ml";
import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";

declare namespace skos="http://www.w3.org/2004/02/skos/core#";
let $title := 'Split CMS Concepts into Small XML Files'

let $concepts := /skos:concepts/skos:concept
let $output-base-uri := '/glossary/cms/'

let $uris :=
   for $concept at $count in $concepts
   let $space-to-dash := replace($concept/skos:prefLabel, ' ', '-')
   let $remove-special-chars := replace($space-to-dash, '[^A-Za-z0-9\-]', '')
   let $uri := $output-base-uri || lower-case($remove-special-chars) || '-' || $count || '.xml'
   (:   
   
   Get rid of the extra spaces.
   let $normalize-space :=
     for $element in $concept/*
     return
        element
            {localname($element)}
            {normalize-space($element/text())}
            :)
   let $insert := xdmp:document-insert($uri, $concept)
   return 
      $uri

let $content := 

    <div class="content">
       <h4>{$title}</h4>
       {count($concepts)} concepts inserted into 
       {for $uri in $uris
        return
           <div>
              <a href="/views/view-xml.xqy?uri={$uri}">{$uri}</a>
           </div>
       }
    </div>                                           

return style:assemble-page($title, $content)