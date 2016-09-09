xquery version "1.0-ml";
import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";

declare namespace rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#";
declare namespace skos="http://www.w3.org/2004/02/skos/core#";

declare function local:insert-document($uri as xs:string, $doc as element()) {
 if (doc-available($uri))
  then ()
  else xdmp:document-insert($uri, $doc, xdmp:default-permissions(), ('glossary-concept', 'w3c'))
};

(:

<skos:Concept
    rdf:about="http://www.w3.org/2003/03/glossary-project/data/glossaries/xpath20#dataModel">
    <skos:prefLabel xml:lang="en">data model</skos:prefLabel>
    <skos:definition xml:lang="en" rdf:parseType="Literal">XPath operates on the abstract, logical
      structure of an XML document, rather than its surface syntax. This logical structure, known as
      the data model, is defined in .</skos:definition>
    <rdfs:isDefinedBy rdf:resource="http://www.w3.org/TR/2007/REC-xpath20-20070123/"/>
  </skos:Concept>:)
  
let $title := 'Split SKOS Concepts into Files'

let $uri := xdmp:get-request-field('uri')

return
  if (not($uri))
     then
        <error>
          <message>uri is a required parameter.</message>
        </error>
   else

let $uri-tokens := tokenize($uri, '/')
(: the full file name with the -skos.rdf extension is the last token :)
let $full-file-name := $uri-tokens[last()]
let $glossary-dir-name := substring-before($full-file-name, '-skos.rdf')

let $rdf-doc := doc($uri)/rdf:RDF

let $concepts := $rdf-doc/skos:Concept

let $content := 

    <div class="content">
       <h4>Split Concepts</h4>
       URI: {$uri}<br/>
       {count($concepts)} concepts inserted.
       {for $concept in $concepts
        let $full-concept-uri := $concept/@rdf:about/string()
        let $concept-uri-suffix := substring-after($full-concept-uri, 'http://www.w3.org/2003/03/glossary-project/data/glossaries/')
        let $replace-hash-with-forward-slash := replace($concept-uri-suffix, '#', '/')
        let $replace-comman-with-dash := replace($replace-hash-with-forward-slash, ',', '-')
        
        let $uri := '/glossary/w3c/' || $replace-comman-with-dash || '.xml'
        
        (: async insert for performance :)
        let $insert := xdmp:spawn-function(function() {local:insert-document($uri, $concept)},
           <options xmlns="xdmp:eval">
            <transaction-mode>update-auto-commit</transaction-mode>
          </options>)
        return
           <div>
              Concept: {$concept/skos:prefLabel/text()} - URI: {$uri}
           </div>
       }
    </div>                                           

return style:assemble-page($title, $content)