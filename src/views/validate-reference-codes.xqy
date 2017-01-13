xquery version "1.0-ml";
import module namespace style = "http://uhc.com/odm/style" at "/modules/style.xqy";
import module namespace oref = "http://optum.com/odm/c360/common/optum-specific-referece-data" at "/modules/reference-optum.xqy"; 

declare namespace cod="http://uhc.com/odm/c360/reference-data";
declare namespace map="http://uhc.com/odm/c360/reference-mapping";
declare namespace prop="http://marklogic.com/xdmp/property";
declare option xdmp:output "method=html";
(: Note, in order for this to work the maintain last modified property of the
database MUST be set to be true :)

let $title := 'Reference Data Codes'

let $uri := xdmp:get-request-field('uri')

return
   if (not(doc-available($uri)))
      then
      <error>
         <message>Error: File not file at {$uri}</message>
      </error>
      else (: continue :)

let $doc := doc($uri)
let $validate-results := if(xdmp:validate($doc,'lax')) then'Schema is Valid' else 'Scehma Validation error'

let $content :=
<div class="content">
    <h4>{$title}</h4>
    
    XML Schema Validate Results: {$validate-results}<br/>
  Execution Time: {xdmp:elapsed-time() div xs:dayTimeDuration('PT1S')} seconds.<br/>
 
</div>

return style:assemble-page($title, $content)