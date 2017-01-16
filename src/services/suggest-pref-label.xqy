xquery version "1.0-ml";
import module namespace search = "http://marklogic.com/appservices/search" at "/MarkLogic/appservices/search/search.xqy";

let $q := xdmp:get-request-field('q')

return
   if (not($q))
     then
        <error>
           <message>Error, q is a required parameter.  Try adding q=per to the URL.</message>
        </error> else (: continue :)

let $options :=
<options xmlns="http://marklogic.com/appservices/search">
 <values name="prefLabel">
   <range type="xs:string">
     <element ns="http://www.w3.org/2004/02/skos/core#" name="prefLabel"/>
   </range>
 </values>
</options>

return search:suggest($q, $options)