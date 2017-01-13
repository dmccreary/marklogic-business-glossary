xquery version "1.0-ml";
import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";

declare namespace r="http://marklogic.com/reference-data";
declare namespace prop="http://marklogic.com/xdmp/property";
declare option xdmp:output "method=html";
(: Note, in order for this to work the maintain last modified property of the
database MUST be set to be true :)

let $title := 'Reference Data Codes'

let $sort := xdmp:get-request-field('sort', 'name')

let $reference-uris := cts:uri-match('/reference-data/*.xml')

let $content :=
<div class="container">
    <br/><h4>{$title}</h4>
    
    <table class="table table-striped table-bordered table-hover table-condensed">
        <thead>
           <tr>
              <th>Code Name (file)</th>
              <th>Record Count</th>
              <th>Last Modified</th>
              <th>Validate</th>
              <th>Edit</th>
              <th>XML</th>
           </tr>
        </thead>
        <tbody>
        {for $uri in $reference-uris
            let $codes := doc($uri)/r:codes
            let $properties := xdmp:document-properties($uri)
            let $last-modified := $properties//prop:last-modified/text()
            let $formatted-date := format-dateTime($last-modified, 
              "[FNn,*-3],  [MNn,*-3] [D01] '[Y01] [H01]:[m01]:[s01]")
            let $code-name := $codes/r:code-name/text()
            let $file-base-name := substring-after($uri, '/reference-data/')
            order by $code-name
            return                   
              <tr>                 
                 <td>
                    <a href="/views/view-codes.xqy?uri={$uri}">{$uri}</a><br/>
                    <a class="green-link" href="/views/view-xml.xqy?uri={$uri}">{$file-base-name}</a>
                 </td>
                    
                 <td>{count($codes/r:items/r:item)}</td>
                 <td>{$formatted-date}</td>
                 <td>
                   <a href="/views/validate-reference-codes.xqy?uri={$uri}">validate</a>
                 </td>
                 <td>
                   <a href="/forms/edit-reference-codes.xqy?uri={$uri}">edit</a>
                 </td>
                 <td>
                   <a href="/views/view-xml.xqy?uri={$uri}">xml</a>
                 </td>
              </tr>
         }
          </tbody>
  </table><br/>
  
  <br/>
  Execution Time: {xdmp:elapsed-time() div xs:dayTimeDuration('PT1S')} seconds.<br/>
 
</div>

return style:assemble-page($title, $content)