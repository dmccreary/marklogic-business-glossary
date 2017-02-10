xquery version "1.0-ml";
declare namespace skos="http://www.w3.org/2004/02/skos/core#";

let $names := xdmp:get-request-field-names()

let $doc :=
<concept xmlns="http://www.w3.org/2004/02/skos/core#">
  {for $name in $names
   return
     element
        {fn:QName('http://www.w3.org/2004/02/skos/core#', $name)} {xdmp:get-request-field($name)}
    }
</concept>

return $doc