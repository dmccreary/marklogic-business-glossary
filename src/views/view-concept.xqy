xquery version "1.0-ml";
import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";
import module namespace se = "http://danmccreary.com/skos-to-entities" at "/modules/skos-to-entities.xqy";

declare namespace skos="http://www.w3.org/2004/02/skos/core#";
declare option xdmp:output "method=html";

let $title := 'View SKOS Concept'

let $uri := xdmp:get-request-field('uri')

return
  if (not($uri))
     then
      <error code="400">
         <message>Error. uri is a required parameter</message>
      </error>
     else if (not(doc-available($uri)))
       then
       <error code="404">
          <message>Error. {$uri} is not available.</message>
       </error>
     else 

let $concept := doc($uri)/skos:concept
let $prefLabel := $concept/skos:prefLabel/text()
let $entity-indicator := xs:boolean($concept/skos:entity)

let $content := 
    <div class="content">
       <h4>{$title}</h4>
       
       <div class="view-concept">
         <div class="concept-label">
            <span class="field-label">Preferred Label: </span> <b>{$prefLabel}</b>
         </div>
         <div class="concept-definition">
            <span class="field-label">Definition: </span> {$concept/skos:definition/text()}
         </div>
        </div>
       
      {for $element in $concept/*
       let $element-name := local-name($element)
       return
         if ($element-name ne 'prefLabel' and $element-name ne 'definition')
           then
           <div>
              <span class="field-label">{$element-name}: </span>
              <a href="/views/view-concept.xqy?uri={se:prefLabel-to-uri($element/text())}">{$element/text()}</a>
           </div> else ()
       }
       
       {if ($concept/skos:entity = 'true')
           then se:properites-html($prefLabel)
           else ()
       }
       
       <br/>
         <div class="action-buttons">
         <h4>MarkLogic Entity Service Actions</h4>
            {if ($entity-indicator)
               then
                 <a class="btn btn-info" role="button" href="/services/delete-entity.xqy?uri={$uri}">Delete Entity Element</a>
               else                  
                  <a class="btn btn-info" role="button" href="/services/make-entity.xqy?uri={$uri}">Make Entity</a>
            }
            <br/>
            
            <a class="btn btn-info" role="button" href="/services/make-property.xqy?uri={$uri}">Make Property</a><br/>
            <a class="btn btn-info" role="button" href="/services/make-relationship.xqy?uri={$uri}">Make Relationship</a><br/>
            <br/>
            
            <h4>Other Actions</h4>
            <a class="btn btn-info" role="button" href="/services/set-broader.xqy?uri={$uri}">Set Broader Concept</a>
            <a class="btn btn-info" role="button" href="/services/set-reference-data.xqy?uri={$uri}">Set Reference Data</a>
            <a class="btn btn-info" role="button" href="/services/set-code-value.xqy?uri={$uri}">Set Code Value</a>
            <a class="btn btn-info" role="button" href="/services/set-business-rule.xqy?uri={$uri}">Set Business Rule</a>
            <a class="btn btn-info" role="button" href="/services/set-flat.xqy?uri={$uri}">Flag for Followup</a>
            <a class="btn btn-info" role="button" href="/services/approve.xqy?uri={$uri}">Approve</a><br/>
            <a class="btn btn-info" role="button" href="/forms/edit-skos-concept.xqy?uri={$uri}">Edit</a>
            
         </div>
         
         <a href="/views/view-xml.xqy?uri={$uri}">View XML</a>
        
    </div>                                           

return style:assemble-page($title, $content)