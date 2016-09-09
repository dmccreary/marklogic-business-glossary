xquery version "1.0-ml";
import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";
declare namespace dc="http://purl.org/dc/elements/1.1/";
declare namespace rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#";
declare namespace skos="http://www.w3.org/2004/02/skos/core#";

let $title := 'List Input SKOS Glossary Concepts'

let $uri := xdmp:get-request-field('uri')

return
  if (not($uri))
     then
       <error>
          <message>URI is a required parameter</message>
       </error> else

let $doc := doc($uri)/rdf:RDF
let $first-title := ($doc//dc:title)[1]
let $concepts := $doc//skos:Concept
     
let $content :=
<div class="content">
  <h4>{$title}</h4>
  <span class="field-label">URI:</span> {$uri}<br/>
  <span class="field-label">First Title:</span> {$first-title}<br/>
  <table class="table table-striped table-bordered table-hover table-condensed">
    <thead>
      <tr>
         <th>#</th>
         <th>Preferred Label</th>
         <th>Definition</th>
      </tr>
      </thead>
    <tbody>{
     for $concept at $count in $concepts
     let $prefLabel := $concept/skos:prefLabel
     let $definition := $concept/skos:definition
     return
        <tr>
           <td>{$count}</td>
           <td>{$prefLabel}</td>
           <td>{$definition}</td>
        </tr>
      }</tbody>
   </table>
   Elapsed Time: {xdmp:elapsed-time() div xs:dayTimeDuration('PT1S') } seconds.
</div>

return style:assemble-page($title, $content)