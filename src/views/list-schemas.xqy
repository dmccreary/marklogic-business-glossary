xquery version "1.0-ml";
import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";
declare option xdmp:output "method=html";

let $title := 'List Schemas'

let $schema-uris := xdmp:eval(cts:uri-match('*.xsd'),
      (),
      <options xmlns="xdmp:eval">
        <database>{xdmp:schema-database(xdmp:database())}</database>
      </options>
    )

return $schema-uris
