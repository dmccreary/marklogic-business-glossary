xquery version "1.0-ml";
import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";

declare namespace skos="http://www.w3.org/2004/02/skos/core#";

(:
Our data looks like this:
<concept xmlns="http://www.w3.org/2004/02/skos/core#">
   <prefLabel>Provider</prefLabel>
   <altLabel>Doctor</altLabel>
   <altLabel>Hospital</altLabel>
   <definition>Definition Text</definition>
   <entity>true</entity>
   <property-of></property-of>
   <property-of></property-of>
</concept>
:)

declare option xdmp:output "method=html";
declare option xdmp:output "encoding=utf-8";
declare option xdmp:output "indent=yes";

let $title := 'Edit SKOS Concept'
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
      
let $concept := doc($uri)/skos:concept

let $content :=
<div class="content">
    <h2>{$title}</h2>
   <form method="post" action="/forms/save-skos-concept.xqy">
   
         <div class="row">
            <div class="form-group col-md-4">
                 <label for="code-name">Preferred Label: </label>
                 <input class="form-control" id="code-name" name="name" size="20" value="{$concept/skos:prefLabel/text()}"/>
           </div>
        </div>
        
        <div class="row">
            <div class="form-group col-md-4">
                <label for="alt-lable">Alternate Label (synonym): </label>
                <input class="form-control" id="alt-lable" name="alt-lable" size="20" value="{$concept/skos:altLabel/text()}"/>
                <a href="#">Add</a><!-- TODO add JQuery code to add another Alternate Label -->
            </div>
        </div>
        
        <div class="row">
           <div class="form-group col-md-10">
               <label for="definition">Definition: </label>
               <textarea class="form-control" id="definition" name="definition" rows="5">{normalize-space($concept/skos:definition/text())}</textarea>
           </div>
         </div>
         
         <div class="row">
            <div class="form-group col-md-4">
                <label for="alt-lable">Broader Concept: </label>
                <input class="form-control" id="broader" name="broader" size="20" value="{$concept/skos:broader/text()}"/>
                <a href="#">Add</a><!-- TODO add JQuery code to add another Alternate Label -->
            </div>
        </div>
         
        
        <div class="form-group row">
          <label>MarkLogic Entity Manager: </label>
          <br/>
        
         <div class="form-group col-md-2">
             <label for="entity">Entity: </label>
             <input class="form-control" id="entity" name="entity" width="5" value="{$concept/skos:entity/text()}"/>
         </div>
         
         <div class="form-group col-md-2">
             <label for="property-of">Property of: </label>
             <input class="form-control" id="property-of" name="property-of" value="{$concept/skos:property-of/text()}"/><br/>
         </div>
         
         <div class="form-group col-md-2">
             <label for="relationship">Related To: </label>
             <input class="form-control" id="relationship" name="relationship" value="{$concept/skos:relationship/text()}"/><br/>
         </div>
         
        </div>
        
        <div class="row">
           <div class="form-group">
               <label for="definition">Source: </label>
               <textarea class="form-control" id="source" name="source" rows="5">{$concept/skos:source/text()}</textarea><br/>
           </div>
         </div>
         
         <div class="row">
           <div class="form-group">
               <label for="scope">Scope Notes: </label>
               <textarea class="form-control" id="scope" name="scope" rows="5">{$concept/skos:scope/text()}</textarea><br/>
           </div>
         </div>
         
         <div class="form-group row">
          <label>Approvals: </label>
          <br/>
        
         <div class="form-group col-md-2">
             <label for="entity">Status Code: </label>
             <input class="form-control" id="approval-status-code" name="approval-status-code" value="{$concept/skos:approval-status-code/text()}"/>
         </div>
         
         <div class="form-group col-md-2">
             <label for="property-of">Approved By: </label>
             <input class="form-control" id="approved-by" name="approved-by" value="{$concept/skos:approved-by/text()}"/><br/>
         </div>
         
         <div class="form-group col-md-2">
             <label for="relationship">Approved Date: </label>
             <input class="form-control" id="approved-date" name="approved-date" value="{$concept/skos:approved-date/text()}"/><br/>
         </div>
         
        </div>
        
       <button class="btn btn-primary" type="submit">Save</button>
   </form>
   <a href="/views/view-xml.xqy?uri={$uri}">view-xml</a>
</div>

return style:assemble-page($title, $content)
