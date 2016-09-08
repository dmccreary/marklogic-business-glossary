xquery version "1.0-ml";
import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";

let $title := 'List of Resourse for Business Glossary'

let $content :=
<div class="content">
  <a href="https://www.w3.org/2003/03/glossary-project/data/glossaries/">Sample W3C Glossaries in RDF</a>
</div>

return style:assmeble-page($title, $content)