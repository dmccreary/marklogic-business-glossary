xquery version "1.0-ml";

module namespace style = "http://danmccreary.com/style";
(:
import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";
:)

declare function style:assemble-page($title as xs:string, $content as element()) as element() {

let $set-html-content := xdmp:set-response-content-type("text/html")

(: site.css is for site-specific CSS rules.  Don't change the bootstrap.min.css file. :)
return
<html>
   <head>
      <title>{$title}</title>
      <link rel="stylesheet" href="/resources/css/bootstrap.min.css"/>
      <link rel="stylesheet" href="/resources/css/site.css"/>
      <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css"/>
      <script src="//code.jquery.com/jquery-1.10.2.js"></script>
      <script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
   </head>
   <body>
      <div class="container">
         {style:header()}
         {$content}
         {style:footer()}
      </div>
   </body>
</html>
};

declare function style:header() as element() {
<nav class="navbar navbar-default navbar-static-top">
    <div class="container">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                    <span class="sr-only">Toggle navigation</span>
                </button>
                <a class="navbar-brand" href="/index.xqy"><img 
                src="/resources/images/marklogic.png" alt="MarkLogic Logo"/></a>
            </div>
            <div id="navbar" class="navbar-collapse collapse">
                <ul class="nav navbar-nav">
                    <li class="active"><a href="/index.xqy">Home</a></li>
                </ul>

                <ul class="nav navbar-nav navbar-form navbar-center">
                <!-- Main Searchbar -->
                  <li>
                     <form class="navbar-form" role="search" action="/search/search-glossary-service.xqy">
                        <div class="input-group">
                            <input type="search" class="form-control" size="50" placeholder="Search Glossary" name="q"/>
                            <input type="hidden"  name="debug" value="false"/>
                                <div class="input-group-btn">
                                    <button class="btn btn-default" type="submit">Search</button>
                                </div>
                        </div>
                     </form>
                    </li>
                    <li><a href="/search/advanced-search-form.xqy">Advanced Search</a></li>
                    <li><a href="#">User: {xdmp:get-current-user()}</a></li>
                </ul>

            </div>
        </div>
    </nav>
};

declare function style:footer() as element() {
<div class="footer">
  <center>
    <a href="http://marklogic.com"><img src="/resources/images/powered-by-marklogic.png"/></a>
    <span class="title-in-footer">MarkLogic Business Glossary Manager</span>
  </center>
  <script>
      $( "#autocomplete" ).autocomplete({{
        source: function(request, response) {{
         jQuery.get('/services/suggest-skos-label.xqy', {{
            q: request.term
         }}, function(data) {{  
            response(data);
         }})
        }},  
        minLength: 3
      }});
    </script>
</div>
};

(: display the previous to next with page counters between 
call it like this:
   style:prev-next-pagination-links($start, $page-length, $total-count)
:)
declare function style:prev-next-pagination-links(
   $start as xs:positiveInteger, 
   $page-length as xs:positiveInteger, 
   $total-count as xs:positiveInteger) as element() {

(: convert from document number to page numbers :)
let $current-page := round($start div $page-length) + 1
let $last-page := round($total-count div $page-length)

(: used to calculate the page min and maxs :)
let $page-number-min := max( ($current-page - 5, 1) )
let $page-number-max :=
   if ($last-page < 10)
      then $last-page
      else if ($current-page < 5)
        then 10
        else $current-page + 5

return
<div class="prev-next-pagination-links">
    {if ($start >= $page-length)
       then <a href="{xdmp:get-request-path()}?start={$start - $page-length}" class="btn btn-primary">Previous</a>
       (: disable and make gray but keep for spacing :)
       else <a href="{xdmp:get-request-path()}?start={$start - $page-length}" class="btn btn-primary disabled opacity">Previous</a>
    }
    
    <span class="prev-next-page-links">

      {for $page in ($page-number-min to $page-number-max)
       return
         if ($page = $current-page)
            then
            <a  class="btn btn-link link-text-black prev-next-page-link" href="{xdmp:get-request-path()}?start={(($page - 1) * $page-length) + 1}">{$page}</a>
            else
            <a class="btn btn-link prev-next-page-link" href="{xdmp:get-request-path()}?start={(($page - 1) * $page-length) + 1}">{$page}</a>
       }
     </span>
     
    {if ($start < ($total-count - $page-length))
       then <a href="{xdmp:get-request-path()}?start={$start + $page-length}" class="btn btn-primary pull-right">Next</a>
       else ()
    }
</div>
};

(: display the previous to next with page counters between
call it like this:
   style:prev-next-pagination-links($start, $page-length, $total-count)
:)
declare function style:prev-next-pagination-links(
   $start as xs:nonNegativeInteger,
   $page-length as xs:nonNegativeInteger,
   $total-count as xs:nonNegativeInteger,
   $query as xs:string) as element() {

(: convert from document number to page numbers :)
let $current-page := round($start div $page-length) + 1
let $last-page := round($total-count div $page-length)
let $query-parameter :=
   if (exists($query))
     then '&amp;q=' || $query
     else ()

(: used to calculate the page min and maxs :)
let $page-number-min := max( ($current-page - 5, 1) )
let $page-number-max :=
   if ($last-page < 10)
      then $last-page
      else if ($current-page < 5)
        then 10
        else $current-page + 5

return
<div class="prev-next-pagination-links">
    {if ($start >= $page-length)
       then <a href="{xdmp:get-request-path()}?start={$start - $page-length}{$query-parameter}" class="btn btn-primary">Previous</a>
       (: disable and make gray but keep for spacing :)
       else <a href="{xdmp:get-request-path()}?start={$start - $page-length}{$query-parameter}" class="btn btn-primary disabled opacity">Previous</a>
    }

    <span class="prev-next-page-links">

      {for $page in ($page-number-min to $page-number-max)
       return
         if ($page = $current-page)
            then
            <a  class="btn btn-link link-text-black prev-next-page-link" href="{xdmp:get-request-path()}?start={(($page - 1) * $page-length) + 1}{$query-parameter}">{$page}</a>
            else
            <a class="btn btn-link prev-next-page-link" href="{xdmp:get-request-path()}?start={(($page - 1) * $page-length) + 1}{$query-parameter}">{$page}</a>
       }
     </span>

    {if ($start < ($total-count - $page-length))
       then <a href="{xdmp:get-request-path()}?start={$start + $page-length}{$query-parameter}" class="btn btn-primary pull-right">Next</a>
       else ()
    }
</div>
};
