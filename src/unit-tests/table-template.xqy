xquery version "1.0-ml";
import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";

let $title := 'Table Template'

let $items := cts:uri-match('/inputs/glossary-inputs/*-skos.rdf')

let $content :=
<div class="content">
  <table class="table table-striped table-bordered table-hover table-condensed">
    <thead>
      <tr>
         <th>#</th>
         <th>Type</th>
         <th>Source System</th>
         <th>Source Table</th>
         <th>Document Count</th>
      </tr>
      </thead>
    <tbody>{
     for $item at $count in $items
     return
        <tr>
           <td>{$count}</td>
           <td>{$item}</td>
        </tr>
      }</tbody>
   </table>
   Elapsed Time: {xdmp:elapsed-time() div xs:dayTimeDuration('PT1S') } seconds.
</div>

return style:assmeble-page($title, $content)