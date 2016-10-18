xquery version "1.0-ml";
import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";

(:
This XQuery Script Transforms NIEM Core Elements from input XML Schema file into
an HTML file.
	     
    Author:Dan McCreary
    Copyright: 2016 Kelly-McCreary & Associates, All Rights Reserved
    License: Apache 2.0
    Version History:
		
:)
declare namespace s="http://niem.gov/niem/structures/2.0";
declare namespace nc="http://niem.gov/niem/niem-core/2.0";
declare namespace niem-xsd="http://niem.gov/niem/proxy/xsd/2.0";
declare namespace xs="http://www.w3.org/2001/XMLSchema";
declare namespace j="http://niem.gov/niem/domains/jxdm/4.0";
declare namespace i="http://niem.gov/niem/appinfo/2.0";

let $title := 'NIEM Object Classe Types to HTML'

(: This is the file path.  Change this line if you put the file into another location :)
let $uri := xdmp:get-request-field('uri', '/niem-core.xsd')
let $schema := doc($uri)/xs:schema

let $set-html-content := xdmp:set-response-content-type("text/html")
(: setting this to be true slows down the report :)
let $defs := xs:boolean(xdmp:get-request-field('defs', 'false'))

let $named-complex-types := $schema//xs:complexType[@name]
let $element-count := count($schema//xs:element[@name])
let $total-count := count($named-complex-types)

let $content :=
<div class="content">
    <h4>{$title}</h4>

    <span class="field-label">Schema URI: </span> {$uri}<br/>
    <span class="field-label">View Description: </span>A simple query of the niem-core.xsd file that lists all the named complex types.<br/>
    <span class="field-label">Number of Named Complex Types (ObjectClasses): </span> {$total-count}<br/>
    <span class="field-label">Number of Elements (Object Properties): </span> {format-number($element-count, '#,###')}<br/>
    <span class="field-label">Order by: </span> name<br/>
    <span class="field-label">Target Namespace: </span>  {$schema/@targetNamespace/string()}<br/>
    <span class="field-label">Elapsed Time:</span> {xdmp:elapsed-time() div xs:dayTimeDuration('PT1S') } seconds.<br/>
    
    {if ($defs)
       then <a href="{xdmp:get-request-path()}?defs=false">Turn Off Definitions</a>
       else <a href="{xdmp:get-request-path()}?defs=true">Turn On All Definitions (large)</a>
    }
    <div class="row">
      {
        (: We first get all the complex elements in the file.  For each complex element create an owl class. :)
        for $complex-element at $count in $named-complex-types
            let $name := string($complex-element/@name)
            let $parent := string($complex-element//xs:extension/@base)
            let $parent-suffix := substring-after($parent, ':')
            let $properties := 
                for $element at $count in $complex-element//xs:element
                    let $name := string($element/@ref)
                    order by $name
                    return $element
            let $property-count := count($properties)
            order by $name
              (: Named Anchor Point: <a name="{$name}" href="#"></a> :)
              return
                 (: for each class, put the class name in and put the parent class in the subclass element :)
                 <div class="niem-complex-type" id="{$name}">
                    <div class="niem-class-description">
                     
                     {$count}
                      <span class="field-label"> Class:</span><span class="niem-class-name">{$name}</span><br/>
                      <span class="field-label">Sub class of: </span>
                      
                          {if (starts-with($parent, 'structures'))
                             then <span class="parent-name">{$parent}</span>
                             else
                               <a href="#{$parent-suffix}">{$parent}</a>
                          }
                      
                      <br/>
                      Documentation: {$complex-element/xs:annotation/xs:documentation/text()}<br/>
                    </div>
                    
                    <div class="niem-class-description">
                     {for $property in $properties
                       let $element-name-suffix := substring-after($property//@ref/string(), 'nc:')
                       let $definition :=
                         if ($defs)
                            then
                               (' - ', $schema/xs:element[@name = $element-name-suffix]/xs:annotation/xs:documentation/text())
                            else ''
                            
                       return
                         <div class="niem-property">
                            {$element-name-suffix}
                            {$definition}
                         </div>
                                 
                       }
                     </div>
             </div>     
     }
   </div> 
</div>

return style:assemble-page($title, $content)