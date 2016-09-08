xquery version "1.0-ml";
import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";

declare namespace rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#";
declare namespace skos="http://www.w3.org/2004/02/skos/core#";

(:

<skos:Concept
    rdf:about="http://www.w3.org/2003/03/glossary-project/data/glossaries/xpath20#dataModel">
    <skos:prefLabel xml:lang="en">data model</skos:prefLabel>
    <skos:definition xml:lang="en" rdf:parseType="Literal">XPath operates on the abstract, logical
      structure of an XML document, rather than its surface syntax. This logical structure, known as
      the data model, is defined in .</skos:definition>
    <rdfs:isDefinedBy rdf:resource="http://www.w3.org/TR/2007/REC-xpath20-20070123/"/>
  </skos:Concept>:)
  
let $title := 'Split SKOS Concepts into Files'

let $uri := xdmp:get-request-field('uri', '/inputs/rdf-glossaries/xforms-skos.rdf')
let $rdf-doc := doc($uri)/rdf:RDF

let $concepts := $rdf-doc/skos:Concept

let $content := 

    <div class="content">
       <h4>Split Concepts</h4>
       URI: {$uri}<br/>
       {count($concepts)} concepts inserted.
       {for $concept in $concepts
        return
           <div>
              {$concept/skos:prefLabel/text()}
           </div>
       }
    </div>                                           

return style:assemble-page($title, $content)