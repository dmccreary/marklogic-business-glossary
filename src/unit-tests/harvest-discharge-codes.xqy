xquery version "1.0-ml";

(: these are the namespace declarations that we got from the source file :)
declare namespace content="http://purl.org/rss/1.0/modules/content/";
declare namespace dc="http://purl.org/dc/terms/";
declare namespace foaf="http://xmlns.com/foaf/0.1/";
declare namespace og="http://ogp.me/ns#";
declare namespace rdfs="http://www.w3.org/2000/01/rdf-schema#";
declare namespace sioc="http://rdfs.org/sioc/ns#";
declare namespace sioct="http://rdfs.org/sioc/types#";
declare namespace skos="http://www.w3.org/2004/02/skos/core#";
declare namespace xsd="http://www.w3.org/2001/XMLSchema#";

(: this is what HTML Tidy puts in :)
declare namespace xhtml="http://www.w3.org/1999/xhtml";

(: ingest patient discharge codes from HTML page :)

let $url := 'https://www.resdac.org/cms-data/variables/patient-discharge-status-code'

let $http-get-results-html-body := xdmp:tidy((xdmp:http-get($url)[2]))[2]
let $tables := $http-get-results-html-body//xhtml:table
let $table-1 := $tables
let $doc :=
<tables>
   {$tables}
</tables>

let $insert := xdmp:document-insert('/tmp/tables.xml', $doc)

(: <div class="field-items" xmlns="http://www.w3.org/1999/xhtml">
         <div class="field-item even">02</div>
      </div>
      <div class="field-items" xmlns="http://www.w3.org/1999/xhtml">
         <div class="field-item even">Discharged/transferred to other short term general hospital
            for inpatient care.</div>
      </div> :)
return
<codes>
   <code-name>discharge-codes</code-name>
   <source>{$url}</source>
   
{
  for $row in $table-1/xhtml:tbody/xhtml:tr
  return
  <items>
     <value>{normalize-space(data($row/xhtml:td[1]))}</value>
     <label>{normalize-space(data($row/xhtml:td[2]))}</label>
  </items>
}</codes>
