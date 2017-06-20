xquery version "1.0-ml";
declare namespace skos="http://www.w3.org/2004/02/skos/core#";

let $set-html-content := xdmp:set-response-content-type("text/html")

let $concepts := (/skos:concept)[1 to 20]
return 
<html>
   <head>
     <title>List of concepts</title>
   </head>
   <body>
        <ol>{
          for $concept in $concepts 
          order by $concept/skos:prefLabel
          return 
             <li>
                <b>{$concept/skos:prefLabel/text()}</b>
                <br/>
                {$concept/skos:definition/text()}

             </li>
        }</ol>
  </body>
  </html>