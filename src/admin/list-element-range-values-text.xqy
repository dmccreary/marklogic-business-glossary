xquery version "1.0-ml";
import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";

let $nl := "&#10;"

let $namespace := xdmp:get-request-field('namespace')

let $localname := xdmp:get-request-field('localname')

let $qname := QName($namespace, $localname)

let $values := cts:element-values($qname)

return string-join($values, $nl)
