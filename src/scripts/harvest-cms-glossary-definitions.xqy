xquery version "1.0-ml";
import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";

declare namespace skos="http://www.w3.org/2004/02/skos/core#";
let $title := 'Harvest CMS Glossary Defintions'

let $uri := '/inputs/cms-gov/glossary.xml'

(:
<glossary-terms class="cms-glossary">
    <source>https://www.healthcare.gov/glossary/</source>
    <see-also>https://www.cms.gov/apps/acronyms/</see-also>
    <base-uri>https://www.cms.gov/apps/glossary</base-uri>
    <concept>
        <a href="/glossary/accountable-care-organization/">Accountable Care Organization</a>
    </concept>
    :)
let $doc := doc($uri)/glossary-terms
let $concepts := $doc/concept
let $concept-count := count($concepts)
let $base-uri := $doc/base-uri/text()

let $content :=
 <div class="content">
    <h4>{$title}</h4>
    Concept count = {$concept-count}<br/>>
    {count($concepts)} concepts inserted.
    {for $concept in $concepts
     let $uri-suffix := $concept/a/@href/string()
     return
        <div>
           {$concept/text()} -
           <a href="{$base-uri}{$uri-suffix}">{$base-uri}{$uri-suffix}</a>
        </div>
    }
 </div>                                           

return style:assemble-page($title, $content)