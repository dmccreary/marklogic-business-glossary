xquery version "1.0-ml";

(: Site Landing Page :)

import module namespace style="http://danmccreary.com/style" at "/modules/style.xqy";
declare option xdmp:output "method=html";

let $title := 'MarkLogic Business Glossary'

let $content := 
<div class="content">
      <h4>Welcome to the {$title}</h4>
      
      <p>This application is a a training tool to demonstrate the power of
      using MarkLogic to manage business metadata.</p>
       
      <a href="/views/index.xqy">List Views</a> List of read-only views (no transactions).<br/>
      <a href="/scripts/index.xqy">List Scripts</a> XQuery scripts to import and transform data.<br/>
      <a href="/services/index.xqy">List Services</a> Data services such as the autocomplete data service.<br/>
      <a href="/unit-tests/index.xqy">Unit Tests</a> Manual unit tests.<br/>
      <a href="/admin/index.xqy">Admin</a> Administrative tools such as viewing range indexes.<br/>
</div>

return style:assemble-page($title, $content)
