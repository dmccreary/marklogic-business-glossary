xquery version "1.0-ml";
import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";
import module namespace json = "http://marklogic.com/xdmp/json" at "/MarkLogic/json/json.xqy";
declare option xdmp:output "method=html";

let $title := 'RDF Semaphore Distinct Classes'
let $database-name := xdmp:get-request-field('database-name', 'semaphore')

(: https://stackoverflow.com/questions/2930246/exploratory-sparql-queries :)

let $query-text :=
'
# "a" is a special SPARQL (and Notation3/Turtle) syntax to represent the rdf:type predicate - 
# this links individual instances to owl:Class/rdfs:Class types (roughly equivalent to tables in SQL RDBMSes).
SELECT DISTINCT ?class
WHERE {
  ?s a ?class .
}'

let $query-in-semaphore :=
    <results>{xdmp:invoke-function( 
        function() { sem:sparql($query-text) },
        <options xmlns="xdmp:eval">
          <modules>{xdmp:modules-database()}</modules>
          <database>{xdmp:database($database-name)}</database>
        </options>
    )
    }</results>

let $content :=
<div class="content">
  <h3>{$title}</h3>
  Database Name: {$database-name}<br/>
  <ol>
  {for $value in $query-in-semaphore//json:value/text()
     return <li>{$value}</li>
  }

  </ol>
  
  <pre>{$query-text}</pre>
  Elapsed Time: {xdmp:elapsed-time() div xs:dayTimeDuration('PT1S') } seconds.<br/>
  
</div>

return style:assemble-page($title, $content)




