xquery version "1.0-ml";
let $triple :=
<sem:triples xmlns:sem="http://marklogic.com/semantics">
 <!-- AI is a SKOS concept -->
 <sem:triple>
  <sem:subject>http://mantis.ai/business-glossary/concepts/deep-learning</sem:subject>
  <sem:predicate>http://www.w3.org/1999/02/22-rdf-syntax-ns#type/</sem:predicate>
  <sem:object>http://www.w3.org/2004/02/skos/core#Concept</sem:object>
 </sem:triple>
</sem:triples>

let $insert := xdmp:document-insert('/tmp/triples/test/deep-learning.xml', $triple)

return
<results>
{cts:triple-value-statistics()}
</results>