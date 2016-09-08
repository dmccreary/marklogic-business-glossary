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
<div class="header">
   <a href="/index.xqy"><img src="/resources/images/marklogic-logo-small.png"/></a>
   <span class="title-in-header">MarkLogic Business Glossary Manager</span>
   <label>Search:</label>
   <input id="search" type="search"/>
   <span class="current-user"><a href="/forms/current-user.xqy">{xdmp:get-current-user()}</a></span>
</div>
};

declare function style:footer() as element() {
<div class="footer">
  <center>
    <a href="http://marklogic.com"><img src="/resources/images/powered-by-marklogic.png"/></a>
    <span class="title-in-footer">MarkLogic Business Glossary Manager</span>
  </center>
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