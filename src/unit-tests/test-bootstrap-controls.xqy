xquery version "1.0-ml";
import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";
import module namespace b = "http://danmccreary.com/bootstrap" at "/modules/bootstrap.xqy";
declare option xdmp:output "method=html";

let $title := 'Test Bootstrap Controls'

let $content :=
<div>
   <form action="/unit-tests/echo-form-parameters.xqy">
      {b:bootstrap-radio('color', ('Red', 'Green', 'Blue'))}
      <input type="submit"/>
   </form>
</div>

return style:assemble-page($title, $content)
