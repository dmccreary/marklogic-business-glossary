xquery version "1.0-ml";

module namespace api = "http://danmccreary.com/api";
(:
import module namespace api = "http://danmccreary.com/api" at "/modules/api.xqy";
:)

import module namespace rxq="http://exquery.org/ns/restxq" at "/modules/rxq.xqy";

declare
   %rxq:GET
   %rxq:path('/hello')
   %rxq:produces('text/html')
   %rxq:description('This is a simple test that returns an single element')
function api:hello() as element() {
   <hello>Hello World!</hello>
};

declare
   %rxq:GET
   %rxq:path('/address/id/(.*)')
   %rxq:produces('text/html')
function api:address($id as xs:string) as element() {
   <address>{$id}</address>
};

declare
   %rxq:GET
   %rxq:path('/opt/(.*)')
   %rxq:produces('text/html')
function api:opt($id as xs:string) as element() {
let $format := xdmp:get-request-field('format')
return
<html>
   <address>{$id}</address>
   <format>{$format}</format>
</html>
};

