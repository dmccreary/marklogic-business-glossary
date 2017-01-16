xquery version "1.0-ml";
import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";
import module namespace se = "http://danmccreary.com/skos-to-entities" at "/modules/skos-to-entities.xqy";

declare namespace skos="http://www.w3.org/2004/02/skos/core#";
declare option xdmp:output "method=xml";

let $title := 'List Entities XML'
let $start := xs:positiveInteger(xdmp:get-request-field('start', '1'))
let $page-length := xs:positiveInteger(xdmp:get-request-field('page-length', '10'))
(: we could just use /skos:concept :)
let $all-concepts := cts:search(/skos:concept, cts:element-value-query(xs:QName('skos:entity'), 'true'), ('unfiltered', 'score-zero'), 0)
let $concept-count := count($all-concepts)

let $sorted-concepts :=
  for $concept in $all-concepts
  order by $concept/skos:prefLabel
  return $concept
  
return
<marklogic-entities>
   <info>
       <title>Sample Healthcare Entities</title>
       <baseURI>http://github.com/dmccreary/marklogic-business-glossary</baseURI>
       <description>Sample entities file for Healthcare.  Many taken from the glossary at cms.gov/healthcare</description>
       <version>0.0.1</version>
   </info>
   <entities>
      {for $concept at $count in subsequence($sorted-concepts, $start, $page-length)
       let $uri := xdmp:node-uri($concept)
       let $prefLabel := $concept/skos:prefLabel/text()
       return
         <entity>
            <name>{$prefLabel}</name>
            <description>{normalize-space($concept/skos:definition/text())}</description>
            
            <properties>
            {for $property in se:properites($concept/skos:prefLabel/text())
             let $property-concept := se:concept-from-pref-label($property)
             return
                <property>
                   <property-name>{$property}</property-name>
                   <datatype>string</datatype>
                   <description>{normalize-space($property-concept/skos:definition/text())}</description>
                </property>
            }
            </properties>
         </entity>
       }
</entities>
   
</marklogic-entities>                                           

