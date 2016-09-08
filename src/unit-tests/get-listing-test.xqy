import module namespace l="http://danmccreary.com/list-resources" at "/modules/list-resources.xqy";

let $listings := l:get-listing('/unit-tests', '.xqy')
return
<results>
   $listings
</results>