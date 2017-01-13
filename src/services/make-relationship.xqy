xquery version "1.0-ml";
import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";
import module namespace b = "http://danmccreary.com/bootstrap" at "/modules/bootstrap.xqy";

declare namespace skos="http://www.w3.org/2004/02/skos/core#";
declare option xdmp:output "method=html";

(: Given a URL, make the SKOS Concept an abstract entity :)

let $title := "Make Relationship"

let $uri := xdmp:get-request-field('uri')
return
   if (not(doc-available($uri)))
     then
        <error>
           <message>Error: Document {$uri} is not available.</message>
        </error> else (: continue :)

let $debug := xs:boolean(xdmp:get-request-field('debug', 'false'))
let $concept := doc($uri)/skos:concept
let $entities := /skos:concept[skos:entity='true']/skos:prefLabel/text()

return
   if ($debug)
      then
         <debug>
            <uri>{$uri}</uri>
            <doc>{$concept}</doc>
         </debug>
      else

let $content :=
<div>
   <div class="content">
             For the Concept <b>{$concept/skos:prefLabel/text()}</b><br/>
             <form action="/services/make-property.xqy">
             
             <div class="form-group">
               <label for="source-entity">Source Entity:</label>:
                 
                 {b:bootstrap-radio('entity', $entities)}
            </div>
            <div class="form-group">
               <label for="source-entity">Relationships Type:</label>:
               <div class="radio">
                  <label>
                     <input type="radio" name="rel-type" value="one-to-one"/>
                     One to One
                  </label>
                  <label>
                     <input type="radio" name="rel-type" value="one-to-many"/>
                     One to Many
                  </label>
                  <label>
                     <input type="radio" name="rel-type" value="many-to-many"/>
                     Many to Many
                  </label>
               </div>
            </div>
            
            <div class="form-group">
               <label for="source-entity">Source Entity:</label>:
               {b:bootstrap-radio('entity', $entities)}
            </div>
                 
                 <input type="hidden" name="uri" value="{$uri}"/>
                 <input type="submit"/>
             </form>
   </div>
          
   <a href="/views/view-concept.xqy?uri={$uri}">View Concept</a><br/>
   <a href="/views/view-xml.xqy?uri={$uri}">View XML</a>
</div>

return style:assemble-page($title, $content)