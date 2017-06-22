xquery version "1.0-ml";
import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";
declare option xdmp:output "method=html";

let $title := 'List Workspace Queries'

let $uri := xdmp:get-request-field('uri')

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
      else (: continue :)
      
      
let $workspace-doc := doc($uri)/export/workspace
let $queries := $workspace-doc/query

(: &amp;mode={$query/@mode/string()} :)
let $content :=
<div class="content">
      <h4>{$title}</h4>
      Database = {xdmp:database-name(xdmp:database())}<br/>
      URI = {$uri}<br/>
      Query Count = {count($queries)}<br/>
      {for $query at $count in $queries
         return
            <div class="query">
               <span class="field-label">{$count}. {$query/@name/string()}</span>
               <div class="query-text">
                 <pre>{$query/text()}</pre>
               </div>
               <a href="run-workspace-query.xqy?uri={$uri}&amp;num={$count}">run</a><br/><br/>
            </div>
            
      }
   Elapsed Time: {xdmp:elapsed-time() div xs:dayTimeDuration('PT1S') } seconds.
</div>                                           

return style:assemble-page($title, $content)