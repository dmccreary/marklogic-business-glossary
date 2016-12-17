xquery version "1.0-ml";
module namespace b = "http://danmccreary.com/bootstrap";
(:
import module namespace b = "http://danmccreary.com/bootstrap" at "/modules/bootstrap.xqy";
:)

(: create a sequence of div elements to be used within a form for a set of checkboxes 
http://getbootstrap.com/components/#input-groups-checkboxes-radios

b:bootstrap-button-radio('Pick A Color', ('Red', 'Green', 'Blue'))
:)
declare function b:bootstrap-radio($name as xs:string, $labels as xs:string*) as element(div)* {
for $label in $labels
return
   <div class="radio">
      <label>
         <input type="radio" name="{$name}" value="{$label}" />
         {$label}
      </label>
   </div>
};

(: http://getbootstrap.com/components/#btn-groups-toolbar 
   b:bootstrap-button-toolbar('Pick A Color', ('Red', 'Green', 'Blue'))
:)
declare function b:bootstrap-button-toolbar($group-label as xs:string, $labels as xs:string*) as element(div)* {
<div class="btn-toolbar" role="toolbar" aria-label="...">
  <div class="btn-group" role="group" aria-label="...">...</div>
  <div class="btn-group" role="group" aria-label="...">...</div>
  <div class="btn-group" role="group" aria-label="...">...</div>
</div>
};

(:http://getbootstrap.com/components/#pagination:)
declare function b:pagination($labels as xs:string*, $uris as element()* ) as element(nav) {
<nav aria-label="Page navigation">
  <ul class="pagination">
    <li>
      <a href="#" aria-label="Previous">
        <span aria-hidden="true">Previous</span>
      </a>
    </li>
    {for $label at $count in $labels
      return
         <li><a href="{$uris[$count]}">{$label}</a></li>
    }
    <li>
      <a href="#" aria-label="Next">
        <span aria-hidden="true">Next</span>
      </a>
    </li>
  </ul>
</nav>
};
