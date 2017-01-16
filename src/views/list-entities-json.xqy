xquery version "1.0-ml";
import module namespace se = "http://danmccreary.com/skos-to-entities" at "/modules/skos-to-entities.xqy";

declare namespace skos="http://www.w3.org/2004/02/skos/core#";
declare option xdmp:output "method=json";
declare option xdmp:output "indent=yes";

let $title := 'List Entities - JSON'
let $start := xs:positiveInteger(xdmp:get-request-field('start', '1'))
let $page-length := xs:positiveInteger(xdmp:get-request-field('page-length', '10'))
(: we could just use /skos:concept :)
let $entity-concepts := cts:search(/skos:concept, cts:element-value-query(xs:QName('skos:entity'), 'true'), ('unfiltered', 'score-zero'), 0)
let $entity-count := count($entity-concepts)


let $add-entities := 
   for $concept at $count in $entity-concepts
       let $entity-map := json:object()
       let $property-maps :=
          for $property in se:properites($concept/skos:prefLabel/text())
             let $property-map := map:new()
             let $add := map:put($property-map, 'property',$property)
           return $property-map
        let $add-entity-name := map:put($entity-map, 'name', normalize-space($concept/skos:prefLabel/text()))
        let $add-entity-description := map:put($entity-map, 'description', normalize-space($concept/skos:definition/text()))
        let $add-properties := map:put($entity-map, 'properties', $property-maps)
        return $entity-map

(: these are not really definitions, they are entities :)

let $info := json:object()
let $add-info := 
      (
         map:put($info, "title", "Healthcare Entities"),
         map:put($info, "description", "Sample entities file for Healthcare.  Many taken from the glossary at cms.gov/healthcare"),
         map:put($info, "baseUri", "http://github.com/dmccreary/marklogic-business-glossary"),
         map:put($info, "version", "0.0.1"),
         map:put($info, "entity-count", $entity-count)
      )

let $root := json:object()
let $assemble-root := 
   (
      map:put($root, "info", $info),
      map:put($root, "definitions", $add-entities)
   )

return xdmp:to-json($root)
