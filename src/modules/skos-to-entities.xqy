xquery version "1.0-ml";

module namespace se = "http://danmccreary.com/skos-to-entities";
(:
import module namespace se = "http://danmccreary.com/skos-to-entities" at "/modules/skos-to-entities.xqy";
:)

(:
    Tools to turn SKOS concept into MarkLogic Entities
:)

declare namespace skos="http://www.w3.org/2004/02/skos/core#";

(:
se:properites('DRUG')
:)
declare function se:properites($entity as xs:string) as xs:string* {
/skos:concept[skos:property-of = $entity]/skos:prefLabel/text()
};

declare function se:properites-html($entity as xs:string) as element(div) {

<div class="properties">
    <h5>Properties</h5>
   {for $property in se:properites($entity)
    return
       <div class="property-name"><a href="/views/view-concept.xqy?uri={se:prefLabel-to-uri($property)}">{$property}</a></div>
   }
</div>};

(: return the first one :)
declare function se:prefLabel-to-uri($prefLabel as xs:string) as xs:string* {
   
let $concept := /skos:concept[skos:prefLabel = $prefLabel][1]
return
   if ($concept)
      then xdmp:node-uri($concept)
      else 'Error: No concept with prefLabe of ' || $prefLabel
};

