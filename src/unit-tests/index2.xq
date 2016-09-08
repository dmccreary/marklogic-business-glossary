xquery version "1.0";

import module namespace style='http://danmccreary.com/style' at '/modules/style.xqm';
import module namespace util2 = "http://danmccreary.com/util2" at "/modules/util2.xqm";

let $title := 'Unit Test Status'

let $data-collection := $style:db-path-to-app-data

let $content := 
    <div class="content">
      {util2:test-status()}
    </div>                                           

return style:assemble-page($title, $content)