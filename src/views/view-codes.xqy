xquery version "1.0-ml";
import module namespace style = "http://uhc.com/odm/style" at "/modules/style.xqy";
declare namespace cod="http://uhc.com/odm/c360/reference-data";
declare option xdmp:output "method=html";
declare option xdmp:output "encoding=utf-8";
declare option xdmp:output "indent=yes";

let $uri := xdmp:get-request-field('uri')
let $title := 'View Codes'

return
  if (not($uri))
     then
        <error>
          <message>uri is a required parameter.</message>
        </error>
   else if (not(doc-available($uri)))
      then
      <error code="404">
         <message>{$uri} not found.</message>
      </error>
      else

let $codes := doc($uri)/cod:codes
let $items := $codes/cod:items/cod:item

let $content :=
<div class="content">
    <h4>{$title}</h4>
    <span class="field-label">Description:</span> {$codes/cod:desc/text()}<br/>
    <span class="field-label">Number of codes:</span> {count($items)}
    <table class="table table-striped table-bordered table-hover table-condensed">
        <thead>
           <tr>
              <th>Value</th> 
              <th>Label</th>
              <th>Description</th> 
           </tr>
        </thead>
        <tbody>
         {for $item in $items
         return
         <tr>
            <td>{$item/cod:value/text()}</td>
            <td>{$item/cod:label/text()}</td>
            <td>{$item/cod:desc/text()}</td>
         </tr>
         }
         </tbody>
  </table>
  <br/>
  Execution Time: {xdmp:elapsed-time() div xs:dayTimeDuration('PT1S')} seconds.<br/>
 
</div>

return style:assemble-page($title, $content)   
