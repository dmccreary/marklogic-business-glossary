xquery version "1.0-ml";
import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";
import module namespace json = "http://marklogic.com/xdmp/json" at "/MarkLogic/json/json.xqy";
declare option xdmp:output "method=html";

let $title := 'RDF Semaphore Distinct Properties'

(: https://stackoverflow.com/questions/2930246/exploratory-sparql-queries :)

let $query-text :=
'SELECT DISTINCT ?property
WHERE {
  ?s ?property ?o .
}'

let $query-in-semaphore :=
    <results>{xdmp:invoke-function( 
        function() { sem:sparql($query-text) },
        <options xmlns="xdmp:eval">
          <modules>{xdmp:modules-database()}</modules>
          <database>{xdmp:database("semaphore")}</database>
        </options>
    )
    }</results>
(:
<json:object xmlns:json="http://marklogic.com/xdmp/json" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	  <json:entry key="property">
	    <json:value xsi:type="sem:iri" xmlns:sem="http://marklogic.com/semantics">http://example.com/Benefit#hasABenefitSectionRoot</json:value>
	  </json:entry>
	</json:object><json:object xmlns:json="http://marklogic.com/xdmp/json" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	  <json:entry key="property">
	    <json:value xsi:type="sem:iri" xmlns:sem="http://marklogic.com/semantics">http://example.com/Benefit#isContainedInBenefitSectionGroup</json:value>
	  </json:entry>
	</json:object><json:object xmlns:json="http://marklogic.com/xdmp/json" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	  <json:entry key="property">
	    <json:value xsi:type="sem:iri" xmlns:sem="http://marklogic.com/semantics">http://example.com/BenefitSectionDetails#hasRelatedPrescription</json:value>
	  </json:entry>
	  :)
let $content :=
<div class="content">
  <h3>{$title}</h3>
  <ol>
  {for $value in $query-in-semaphore//json:value/text()
     return <li>{$value}</li>
  }

  </ol>
  
  <pre>{$query-text}</pre>
  Elapsed Time: {xdmp:elapsed-time() div xs:dayTimeDuration('PT1S') } seconds.<br/>
  
</div>

return style:assemble-page($title, $content)




