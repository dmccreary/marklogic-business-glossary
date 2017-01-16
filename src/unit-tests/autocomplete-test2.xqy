xquery version "1.0-ml";
import module namespace style = "http://marklogic.com/data-hub/style" at "/modules/style.xqy";

declare namespace r="http://westacademic.com/reference";
declare option xdmp:output "method=html";
let $content-type := xdmp:set-response-content-type('text/html')

let $title := 'Autocomplete Test'

let $items :=
<items>
   <item>red</item>
   <item>orange</item>
   <item>yellow</item>
   <item>green</item>
   <item>blue</item>
   <item>indigo</item>
   <item>violet</item>
</items>

let $items-in-double-quotes :=
   for $item in $items/item/text()
     return concat('"', $item, '"')
     
let $internal-string := string-join($items-in-double-quotes, ', ')
let $javascript-array :=
   concat('source: [', $internal-string, ']')
      

let $html :=
('<!doctype html>',
<html lang="en">
   <head>
     <title>{$title}</title>
     <link rel="stylesheet" href="/styles/css/bootstrap.min.css"/>
     <!-- must be connected to the interweb for these to work -->
     <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css"/>
     <script src="//code.jquery.com/jquery-1.10.2.js"></script>
     <script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
   </head>
   <body>
      <div class="site" style="padding:10px">
         
         {style:header()}
         <div class="site-bd" id="content">
         <div class="content">
            <div class="row">
              <div class="col-md-12">
                     <h4>{$title}</h4>
                     <label for="autocomplete">Series name: </label>
                     <input id="autocomplete" size="50"/>
                      
                      <p>This is the simplist possible demo I could create using the JQuery UI Autocomplete example.
                      This demo loads the entire JavaScript array "inline" within this XQuery script.
                      The JavaScript array is "hand built" using both the string-join() and concat() functions from
                      the seriels labels.  <br/><br/>
                      For more information about server side suggest in MarkLogic see <a href="https://docs.marklogic.com/search:suggest">search:suggest</a> <br/><br/>
                      
                      For more information about the options for JQuery UI Autocomplete see <a href="https://jqueryui.com/autocomplete/">JQuery UI Autocomplete</a>
                      <br/><br/>
                      Key Questions:
                      <ol>
                          <li>How do we control the number of characters before we send a requet to the server?</li>
                          <li>How do we control the delay?</li>
                          <li>How do we pass a prefix parameter?</li>
                      </ol>
                      </p>
                      </div>
               </div>
            </div>
            <script>
            $( "#autocomplete" ).autocomplete({{
              source: function(request, response) {{
               jQuery.get('/unit-tests/autocomplete-json.xqy', {{
                  query: request.term
               }}, function(data) {{
               
                  response(data);
               }})
              }},
              
              minLength: 3
            }});
            </script>
         </div>
         {style:footer()}
      </div>
   </body>
</html>)

return $html