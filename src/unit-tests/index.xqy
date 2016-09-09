xquery version "1.0-ml";
import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";
import module namespace l="http://danmccreary.com/list-resources" at "/modules/list-resources.xqy";
import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";

declare namespace prop="http://marklogic.com/xdmp/property";
declare namespace dir="http://marklogic.com/xdmp/directory";
declare option xdmp:output "method=html";
declare option xdmp:output "encoding=utf-8";
declare option xdmp:output "indent=yes";

(: Note, in order for this to work the maintain last modified property of the
database MUST be set to be true :)
let $title := 'List of Unit Tests'
let $lstng := l:get-listing("/unit-tests", ".xqy")
let $resource-descriptions := doc('/resource-descriptions.xml')/resource-descriptions

(:
Description Count: {count($resource-descriptions/resource)}
:)
let $content :=
<div class="container">
    <h4>{$title}</h4>
    Number of Unit Tests = {count($lstng)}<br/>
    
    <table class="table table-striped table-bordered table-hover table-condensed">
        <thead>
           <tr>
              <th>Test Name</th>
              <th>Description</th>
              <th>Last Modified</th>
              <th>Age</th>
           </tr>
        </thead>
        <tbody>{
            for $entry in $lstng
            let $uri := $entry/uri
            return
              if ( $uri = '/unit-tests/index.xqy') then ()
              else
                let $resource-description := l:resource-description($uri)
                let $name :=
                   if ($resource-description/name)
                      then
                      $resource-description/name/text()
                      else substring-after($uri, '/unit-tests/')
                let $desc := $resource-description/description/text()
                let $enable-link := $resource-description/enable-link/text()
                return
                <tr>
                  <td>
                    {if ($enable-link = 'false')
                       then $name
                       else <a href="{$entry/uri}">{$name}</a>
                    }
                  </td>
                  <td>{$desc}</td>
                  {
                  if (($entry/last-modified castable as xs:dateTime)) then
                    <td>{format-dateTime(xs:dateTime($entry/last-modified),"[FNn,*-3],  [MNn,*-3] [D01] '[Y01] [H01]:[m01]:[s01]")}</td>
                  else
                    <td>&nbsp;</td>
                  }
                  <td>
                  { if (($entry/last-modified castable as xs:dateTime)) then
                  current-dateTime() - xs:dateTime($entry/last-modified)
                  else ()
                  }
                  </td>
                </tr>
      }</tbody>
  </table>
</div>

return style:assemble-page($title, $content)
