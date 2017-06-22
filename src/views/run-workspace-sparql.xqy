xquery version "1.0-ml";
import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";
declare option xdmp:output "method=html";

let $title := 'Run Workspace SPARQL'

let $uri := xdmp:get-request-field('uri')
(: the number query in the workspace :)
let $num := xs:positiveInteger(xdmp:get-request-field('num', ''))
let $mode := xdmp:get-request-field('mode', 'sparql')

return
  if (not($uri) or not($num))
     then
        <error>
          <message>Both the workspace uri and num are required parameters.</message>
        </error>
   else if (not(doc-available($uri)))
      then
      <error code="404">
         <message>{$uri} not found.</message>
      </error>
      else (: continue :)


let $workspace-doc := doc($uri)/export/workspace
let $query := $workspace-doc/query[$num]
let $query-name := $query/@name/string()
let $query-results := sem:sparql($query/text())

let $types := xdmp:type($query-results)
      
let $node-count := count($query-results)

let $content :=
<div class="container">
  <h4>{$title}</h4>
  <span class="field-label">Query Name:</span> {$query-name}<br/>
  <span class="field-label">Database:</span> {xdmp:database-name(xdmp:database())}<br/>
  <span class="field-label">URI:</span> {$uri}<br/>
  <span class="field-label">Query Number:</span>{$num}<br/>    
  <span class="field-label">Result node-count:</span>{$node-count}<br/>
    <div class="query">
       <div class="query-text">
          <pre>{$query/text()}</pre>
        </div>
       <div>
          <span class="block-label">Results</span> <span> types = {$types}</span>
       </div>
       <div class="results">
          {for $result in $query-results
            return
              <div class="result">
                 <span class="type">{xdmp:type($result)}</span>
                 <pre>{$query-results}</pre>
              </div>
          }
       </div>
    </div>
   Elapsed Time: {xdmp:elapsed-time() div xs:dayTimeDuration('PT1S') } seconds.
</div>                                           

return style:assemble-page($title, $content)