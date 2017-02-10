xquery version "1.0-ml";
import module namespace style = "http://uhc.com/odm/style" at "/modules/style.xqy";
declare namespace r="http://uhc.com/odm/c360/reference-data";

(:
Our data looks like this:
<codes xmlns="http://uhc.com/odm/c360/reference-data">
    <code-name>gender-code</code-name>
    <desc>HIPAA 834 Gender Code</desc>
    <items>
        <item>
            <value>F</value>
            <label>Female</label>
        </item>
        <item>
            <value>M</value>
            <label>Male</label>
        </item>
    </items>
</codes>
:)

declare option xdmp:output "method=html";
declare option xdmp:output "encoding=utf-8";
declare option xdmp:output "indent=yes";

let $title := 'Edit Reference Codes'
let $uri := xdmp:get-request-field('uri')

return
  if (not($uri))
     then
        <error>
          <message>uri is a required parameter.</message>
        </error>
   else if (not(doc-available($uri)))
      then 
        <error code="404">
           <message>{$uri} not found.</message>
        </error>
      else
let $codes := doc($uri)/r:codes
let $items := $codes/r:items/r:item

let $content :=
<div class="content">
    <h2>{$title}</h2>
   <form method="post" action="/forms/save-reference-code.xqy">
         <div class="form-group">
              <label for="code-name">Code Name: </label>
              <input class="form-control" id="code-name" name="name" xize="50" value="{$codes/r:code-name/text()}"/><br/>
        </div>
        
        <div class="form-group">
            <label for="desc">Code Description: </label>
            <textarea class="form-control" id="desc" name="desc" rows="5">{$codes/r:desc/text()}</textarea>
        </div>
        
        <div class="form-group row">
            <h4>Code Items</h4>
            <table class="table table-striped table-bordered table-hover table-condensed">
              <thead>
                 <tr>
                    <th class="col-md-2">Label</th>
                    <th class="col-md-2">Value</th>
                    <th class="col-md-5">Description</th>
                    <th class="col-md-1">Actions</th>
                 </tr>
              </thead>
              <tbody>
                
                    {for $item in $items
                     return
                        <tr>
                            <td class="col-md-2">
                               <input name="{$item/r:label/text()}" value="{$item/r:label/text()}"/>
                            </td>
                            <td class="col-md-2">
                               <input style="text-align:right" name="{$item/r:value/text()}" value="{$item/r:value/text()}"/>
                             </td>
                             <td class="col-md-5">
                               <input class="col-md-10" name="{$item/r:desc/text()}" value="{$item/r:desc/text()}"/>
                             </td>
                             <td>
                                 <button class="btn btn-default" type="submit">Add</button>
                                 <a href="/forms/delete-code-confirm.xqy?uri={$uri}&amp;label={{$item/r:label/text()}}">Delete</a>
                             </td>
                        </tr>
                     }
                 
              </tbody>
           </table>
       </div>
       <button class="btn btn-default" type="submit">Add New Item</button>
       <button class="btn btn-primary" type="submit">Save</button>
   </form>
   <a href="/views/view-xml.xqy?uri={$uri}">view-xml</a>
</div>

return style:assemble-page($title, $content)
