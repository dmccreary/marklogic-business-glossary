xquery version "1.0-ml";
import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";
import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";
declare namespace db="http://marklogic.com/xdmp/database";

declare option xdmp:output "method=html";
let $title := 'List Current Element Range Indexes'
		
  let $config := admin:get-configuration()
  return
  (:
  <range-element-index xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   xmlns="http://marklogic.com/xdmp/database">
   <scalar-type>dateTime</scalar-type>
   <namespace-uri>http://marklogic.com/xdmp/dls</namespace-uri>
   <localname>created replaced</localname>
   <collation/>
   <range-value-positions>false</range-value-positions>
   <invalid-values>reject</invalid-values>
</range-element-index>
:)

let $all-element-range-indexes :=   admin:database-get-range-element-indexes($config, xdmp:database() )


let $all-range-indexes :=
  for $element in $all-element-range-indexes
      let $namespace-uri := $element/db:namespace-uri
      return 
         if (starts-with($namespace-uri, 'http://marklogic.com'))
              then ()
              else $element

let $element-range-indexes-count := count($all-range-indexes)

let $content :=
<div class="content">
   <h4>{$title}</h4>
      <div class="row">
      <div class="col-md-12">
      Total Element Range Indexes  = {format-number($element-range-indexes-count, '#,###')}
         
         <table class="table table-striped table-bordered table-hover table-condensed">
            <thead>
               <tr>
                  <th>Namespace</th>
                  <th>Name</th>
                  <th>Type</th>
                  <th>Count</th>
                  <th>Distinct-Value Count</th>
                  <th>List Values XML</th>
                  <th>Distinct-Values Text</th>
                  <th>SKOS</th>
               </tr>
            </thead>
            <tbody>
                {for $element-range-index in $all-range-indexes
                let $namespace-uri := $element-range-index/db:namespace-uri
                let $localname := $element-range-index/db:localname
                let $qname := QName($namespace-uri, $localname)
                let $index-scalar-type := $element-range-index/db:scalar-type/text()
                let $element-reference := cts:element-reference($qname)
                 (: order by $namespace-uri, $localname :)
                return    
                   <tr> 
                        <td>{$namespace-uri/text()}</td>
                        <td>{$localname/text()}</td>
                        <td>{$index-scalar-type}</td>
                        <td class="number">{format-number(cts:count-aggregate($element-reference), '#,###')}</td>
                        <td class="number">{format-number(count(cts:element-values($qname)), '#,###')}</td>
                        <td><a href="list-element-range-values.xqy?localname={$localname/text()}&amp;namespace={xdmp:url-encode($namespace-uri/text())}">list values</a></td>
                        <td><a href="list-element-range-values-text.xqy?namespace={$namespace-uri/text()}&amp;localname={$localname/text()}">text</a></td>
                        
                        <td>
                           {if ($index-scalar-type = 'string')
                           then
                           <a href="element-range-values-to-skos.xqy?namespace={$namespace-uri/text()}&amp;localname={$localname/text()}">skos</a>
                           else 'na'
                           }
                        </td>

                   </tr>
                }
            </tbody>
         </table>
         <a href="/views/convert-all-element-range-indexes-to-skos.xqy">Generate All Strings to SKOS RDF File</a>
         </div>
     </div>
     Elapsed Time = {xdmp:elapsed-time() div xs:dayTimeDuration('PT1S') }
</div>

return style:assemble-page($title, $content)
       