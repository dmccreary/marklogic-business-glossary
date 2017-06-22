xquery version "1.0-ml";
import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";
declare option xdmp:output "method=html";

let $title := 'List Training Workspaces'

(: remove URIs that do not start with '/workspaces' and are not the collection :)
let $workspaces := xdmp:directory('/workspaces/', 'infinity')

let $content :=
<div class="content">
      <style type="text/css">
          .name {{font-weight: bold;}}
          .query-text {{font-name:courier;}}
          .block-label {{font-weight: bold}}
          .type {{float:right; border:solid silver 1px;}}
      </style>

      <h4>{$title}</h4>
         Workspace count = {count($workspaces)} <br/>
         <table class="table table-striped table-bordered table-hover">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Workspace Name</th>
                    <th>Query Count</th>
                </tr>
            </thead>
            <tbody>
            {for $workspace at $count in $workspaces/export/workspace
                let $uri := xdmp:node-uri($workspace)
                let $workspace-name := $workspace/@name/string()
                return
                  <tr>
                     <td>{$count}</td>
                     <td><a href="list-workspace-queries.xqy?uri={$uri}">{$workspace-name}</a>
                     </td>
                     <td>{count($workspace/query)}</td>
                  </tr>
            }
            </tbody>
        </table>
        Elapsed Time: {xdmp:elapsed-time() div xs:dayTimeDuration('PT1S') } seconds.
</div>

return style:assemble-page($title, $content)