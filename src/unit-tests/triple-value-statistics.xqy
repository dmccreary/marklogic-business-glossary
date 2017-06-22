xquery version "1.0-ml";

(: Triple Value Statistics and Drill Down :)

import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";
declare namespace e="xdmp:eval";
declare namespace t="cts:triple-value-statistics";

declare option xdmp:output "method=html";

let $database-name := xdmp:get-request-field('database-name', 'semaphore')

let $title := 'Triple Value Statistics'
 
let $semaphore-stats := xdmp:invoke-function( 
        function() {cts:triple-value-statistics()},
        <options xmlns="xdmp:eval">
          <database>{xdmp:database($database-name)}</database>
        </options>)

(:<triple-value-statistics xmlns="cts:triple-value-statistics" count="2485079" 
unique-subjects="634549" 
unique-predicates="253" 
unique-objects="910108" >
</triple-value-statistics>:)

let $content := 
<div class="content">
Database: {$database-name}<br/>
<table class="table table-striped table-bordered table-hover table-condensed">
    <thead>
       <tr>
          <th>Metric Name</th>
          <th>Metric Value</th>
          <th>View</th>
       </tr>
    </thead>
    <tbody>
    <tr>
       <td>Total Number of Triples</td>
       <td class="number">{format-number($semaphore-stats/@count/number(), '#,###')}</td>
    </tr>
    <tr>
       <td>Unique Subjects</td>
       <td class="number">{format-number($semaphore-stats/@unique-subjects/number(), '#,###')}</td>
    </tr>
    <tr>
       <td>Unique Predicates</td>
       <td class="number">{format-number($semaphore-stats/@unique-predicates/number(), '#,###')}</td>
       <td><a href="/views/rdf-distinct-properties.xqy">list distinct properties</a></td>
     </tr>
     <tr>
        <td>Unique Objects</td>
        <td class="number">{format-number($semaphore-stats/@unique-objects/number(), '#,###')}</td>
     </tr>
   </tbody>
   </table>
</div>

return style:assemble-page($title, $content)