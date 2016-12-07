xquery version "1.0-ml";

(: Site Landing Page :)

import module namespace style="http://danmccreary.com/style" at "/modules/style.xqy";
declare option xdmp:output "method=html";

let $title := 'MarkLogic Business Glossary'

let $content := 
<div class="content">
     <form action="/search/search-glossary-service.xqy">
        <div class="input-group">
             <input type="search" class="form-control" size="50" placeholder="Search Concepts" name="q"/>
             <input id="autocomplete" type="hidden"  name="debug" value="false"/>
                 <div class="input-group-btn">
                     <button class="btn btn-default" type="submit">Search</button>
                 </div>
         </div>
     </form>
     <script>
      $( "#autocomplete" ).autocomplete({{
        source: function(request, response) {{
         jQuery.get('/services/suggest-concept-label.xqy', {{
            q: request.term
         }}, function(data) {{  
            response(data);
         }})
        }},  
        minLength: 3
      }});
    </script>
</div>

return style:assemble-page($title, $content)