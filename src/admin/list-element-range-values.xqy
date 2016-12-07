xquery version "1.0-ml";
import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";
import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";

let $namespace := xdmp:get-request-field('namespace')

let $localname := xdmp:get-request-field('localname')

let $qname := QName($namespace, $localname)

let $values := cts:element-values($qname)

return
<values>
   {for $value in $values
      return
        if ($value)
           then
              <value>{$value}</value>
           else ()
   }
</values>