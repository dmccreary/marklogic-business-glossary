xquery version "1.0-ml";
import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";
declare namespace dc="http://purl.org/dc/elements/1.1/";
declare namespace rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#";
declare namespace skos="http://www.w3.org/2004/02/skos/core#";
declare option xdmp:output "method=html";

let $title := 'List Input W3C SKOS Glossaries'

let $uris := cts:uri-match('/inputs/rdf-glossaries/*-skos.rdf')

let $content :=
<div class="content">
  <h4>{$title}</h4>
  
  <table class="table table-striped table-bordered table-hover table-condensed">
    <thead>
      <tr>
         <th>#</th>
         <th>Title</th>
         <th>URI</th>
         <th>Split</th>
         <th>Concept Count</th>
         <th>List Concepts</th>
         <th>View XML</th>
      </tr>
      </thead>
    <tbody>{
     for $uri at $count in $uris
     let $doc := doc($uri)/rdf:RDF
     let $first-title := ($doc//dc:title)[1]
     let $concepts := $doc//skos:Concept
     return
        <tr>
           <td>{$count}</td>
           <td>{$first-title}</td>
           <td>{$uri}</td>
           <td><a href="/scripts/splitter-rdf-to-concept-files.xqy?uri={$uri}">split</a></td>
           <td>{count($concepts)}</td>
           <td><a href="/views/list-input-skos-glossary-concepts.xqy?uri={$uri}">list concepts</a></td>
           <td><a href="/views/view-xml.xqy?uri={$uri}">view xml</a></td>
        </tr>
      }</tbody>
   </table>
   Elapsed Time: {xdmp:elapsed-time() div xs:dayTimeDuration('PT1S') } seconds.
</div>

return style:assemble-page($title, $content)