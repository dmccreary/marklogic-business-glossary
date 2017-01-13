xquery version "1.0-ml";
import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";
import module namespace b = "http://danmccreary.com/bootstrap" at "/modules/bootstrap.xqy";

declare namespace skos="http://www.w3.org/2004/02/skos/core#";
declare option xdmp:output "method=html";

(: Given a URL, make the SKOS Concept an abstract entity :)

let $title := "Create an Entity Property"

let $uri := xdmp:get-request-field('uri')
return
   if (not(doc-available($uri)))
     then
        <error>
           <message>Error: Document {$uri} is not available.</message>
        </error> else (: continue :)

let $debug := xs:boolean(xdmp:get-request-field('debug', 'false'))
let $property-concept := doc($uri)/skos:concept
let $property-prefLabel := $property-concept/skos:prefLabel
let $entity := xdmp:get-request-field('entity')

return
   if ($debug)
      then
         <debug>
            <uri>{$uri}</uri>
            <entity>{$entity}</entity>
            <doc>{$property-concept}</doc>
         </debug>
      else



let $content :=
  if ($entity)
     then
         let $update :=
          if (exists($property-concept/skos:property-of))
             then xdmp:node-replace($property-concept/skos:property-of, <skos:property-of>{$entity}</skos:property-of>)
             else xdmp:node-insert-child($property-concept, <skos:property-of>{$entity}</skos:property-of>)
         return
          <div class="content">
             The entity {$entity} now has a new property {$property-prefLabel}.
             <a href="/views/view-concept.xqy?uri={$uri}">View Concept</a><br/>
             <a href="/views/view-xml.xqy?uri={$uri}">View XML</a>
          </div>
    else
        let $entities := /skos:concept[skos:entity='true']/skos:prefLabel/text()
        return
         <div class="content">
             For the Property <b>{$property-prefLabel}</b> please select an entity to add this property to:
             <form action="/services/make-property.xqy">
                 <input type="hidden" name="uri" value="{$uri}"/>
                 {b:bootstrap-radio('entity', $entities)}
                 <button type="submit">Save</button>
             </form>
             <a href="/views/view-concept.xqy?uri={$uri}">View Concept</a><br/>
             <a href="/views/view-xml.xqy?uri={$uri}">View XML</a>
          </div>
          
return style:assemble-page($title, $content)