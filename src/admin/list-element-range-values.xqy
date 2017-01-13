xquery version "1.0-ml";
import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";

declare option xdmp:output "method=html";
declare option xdmp:output "encoding=utf-8";
declare option xdmp:output "indent=yes";

let $namespace := xdmp:get-request-field('namespace')

let $localname := xdmp:get-request-field('localname')

let $qname := QName($namespace, $localname)

let $values := cts:element-values($qname)

return
<values>
   <desc>List Range Index Values</desc>
   <namespace>{$namespace}</namespace>
   <localname>{$localname}</localname>
   <count>{count($values)}</count>
   {for $value in $values
      return
        if ($value)
           then
              <value>{$value}</value>
           else ()
   }
</values>