xquery version "1.0-ml";
declare option xdmp:output "method=html";
let $content-type := xdmp:set-response-content-type('text/html')

let $html :=
('<!doctype html>',
<html>
   <head>
     <title>autocomplete demo</title>
     <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css"/>
     <script src="//code.jquery.com/jquery-1.10.2.js"></script>
     <script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
   </head>
   <body>
      <p>The full data dictionary is loaded when the form loads.</p>
      <label for="autocomplete">Select a color (try red): </label>
      <input id="autocomplete"/>
      <script>
      $( "#autocomplete" ).autocomplete({{
        source: [ "red", "orange", "yellow", "green", "blue", "indigo", "violet" ]
      }});
      </script>
   </body>
</html>)

return $html