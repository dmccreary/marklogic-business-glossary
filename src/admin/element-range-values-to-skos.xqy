xquery version "1.0-ml";
import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";
import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";

let $nl := "&#10;"

let $namespace := xdmp:get-request-field('namespace')

let $localname := xdmp:get-request-field('localname')

let $qname := QName($namespace, $localname)

let $values := cts:element-values($qname)

let $comment := $nl || 'Reference data dump for ' || $namespace || ':' || $localname || ' in SKOS-XL format' || $nl
(:
this is what we want to create:

  <rdf:Description rdf:about="http://cbinsights.com/cb-insights-reference-data#Automotive-Transportation/Automotive-Transportation_en">
    <rdf:type rdf:resource="http://www.w3.org/2008/05/skos-xl#Label"/>
    <j.3:literalForm xml:lang="en">{$value}</j.3:literalForm>
  </rdf:Description>
  :)
return

<rdf:RDF
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
   xmlns:owl="http://www.w3.org/2002/07/owl#"
   xmlns:skos="http://www.w3.org/2004/02/skos/core#"
   xmlns:teamwork="http://topbraid.org/teamwork#"
   xmlns:semaphore-core="http://www.smartlogic.com/2014/08/semaphore-core#"
   xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
   xmlns:skosxl="http://www.w3.org/2008/05/skos-xl#"
   xmlns:spinrdf="http://spinrdf.org/spin#"
   xmlns:xsd="http://www.w3.org/2001/XMLSchema#">
   
   {comment {$comment}}
   
    <!-- #1 Import for reference data -->
   <rdf:Description rdf:about="urn:x-evn-master:reference-data">
    <rdf:type rdf:resource="http://www.w3.org/2002/07/owl#Ontology"/>
    <rdf:type rdf:resource="http://topbraid.org/teamwork#Vocabulary"/>
    <spinrdf:imports rdf:resource="http://www.smartlogic.com/2015/12/unique-concept-label-constraint"/>
    <spinrdf:imports rdf:resource="http://www.smartlogic.com/2015/12/unique-concept-label-in-class-constraint"/>
    <spinrdf:imports rdf:resource="http://www.smartlogic.com/2015/02/semaphore-spin-constraints"/>
    <owl:imports rdf:resource="http://www.smartlogic.com/2014/08/semaphore-core"/>
  </rdf:Description>
  
  <!-- #2 Concept Scheme for reference data -->
   <rdf:Description rdf:about="{$namespace}/reference-data#ConceptScheme/reference-data">
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#ConceptScheme"/>
    <rdfs:label xml:lang="en">Reference Data Scheme</rdfs:label>
    <semaphore-core:guid>{sem:uuid-string()}</semaphore-core:guid>
    <skos:hasTopConcept rdf:resource="{$namespace}/reference-data#{$localname}/{$localname}_en"/>
  </rdf:Description>
   
  <!-- #3 Top Level Concept - two rdf:Description elements, one for the label, one for the concept  
      Note that the first rdr:about must be the same as the rdf:resource -->
  <rdf:Description rdf:about="{$namespace}/reference-data#{$localname}/{$localname}_en">
    <rdf:type rdf:resource="http://www.w3.org/2008/05/skos-xl#Label"/>
    <skosxl:literalForm xml:lang="en">{$localname}</skosxl:literalForm>
    <skos:broader rdf:resource="{$namespace}/reference-data#Reference-Data"/>
  </rdf:Description>
  <rdf:Description rdf:about="{$namespace}/reference-data#{$localname}/{$localname}_en">
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
    <semaphore-core:guid>{sem:uuid-string()}</semaphore-core:guid>
    <skosxl:prefLabel rdf:resource="{$namespace}/reference-data#{$localname}/{$localname}_en"/>
  </rdf:Description>
  

    
   {
     for $value in $values
      let $convert-spaces-to-dashes := replace($value, ' ', '-')
      let $value-in-uri-form := replace($convert-spaces-to-dashes, '&amp;', 'and')
      let $uri-base := $namespace || '/reference-data/' || '#' || $value-in-uri-form
      let $uri-extended := $uri-base || '/' || $value-in-uri-form || '_en'
      return
        if ($value)
           then
            
              ($nl,
              <!-- concept and label pairs -->,
              <rdf:Description rdf:about="{$uri-base}">
               <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
               <semaphore-core:guid>{sem:uuid-string()}</semaphore-core:guid>
               <skosxl:prefLabel rdf:resource="{$uri-extended}"/>
               <skos:broader rdf:resource="{$namespace}/reference-data#{$localname}/{$localname}_en"/>
             </rdf:Description>,
             <rdf:Description rdf:about="{$uri-extended}">
               <rdf:type rdf:resource="http://www.w3.org/2008/05/skos-xl#Label"/>
               <skosxl:literalForm xml:lang="en">{$value}</skosxl:literalForm>
             </rdf:Description>,
             $nl)
             

           else ()
   }
</rdf:RDF>