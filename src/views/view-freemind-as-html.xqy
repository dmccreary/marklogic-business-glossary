xquery version "1.0-ml";
declare namespace skos="http://www.w3.org/2004/02/skos/core#";

(: recursive function to convert freemind  tree 
<map version="1.0.1">
   <node CREATED="1473517661099" ID="ID_25648870" MODIFIED="1473519398950" TEXT="Modern Metadata Management">
      <node CREATED="1473518113546" ID="ID_712699946" MODIFIED="1473521989965" POSITION="right"
         TEXT="Part 1: The Art of Modern Metadata Management">
         <node CREATED="1473518338260" FOLDED="true" ID="ID_1378580231" MODIFIED="1473521984684"
            TEXT="Preface">
            <node CREATED="1473517943392" ID="ID_90496833" MODIFIED="1473518313880" TEXT="Welcome"/>
:)
declare function local:view-taxonomy($node as element()*, $depth as xs:positiveInteger) as element() {
let $this-label :=  $node/@TEXT/string()
let $children-nodes := $node/node
return
   <li>
       <b>{$this-label}</b>
       {if ($children-nodes)
          then
             <ol>{
             for $child at $count in $children-nodes
             return
               local:view-taxonomy($child, $depth + 1)
            }</ol>
            else ()
        }
   </li>
};

let $title := 'View Freemind as XML'

let $uri := xdmp:get-request-field('uri', '/inputs/taxonomies/Data-Hubs.xml')

return
   if (not(doc-available($uri)))
   then
   <error>
      <message>{$uri} is not available</message>
   </error> else (: continue :)

let $depth := xs:positiveInteger(xdmp:get-request-field('uri', '3'))

let $map := doc($uri)/map
let $freemind-version :=$map/@version/string()
let $root-node := $map/node
let $root-label := $root-node/@TEXT/string()

let $set-header := xdmp:set-response-content-type('text/html')

return
<html>
  <h1>{$root-label}</h1>
  <span>Freemind Version:</span> {$freemind-version}<br/>
  <span>URI:</span> {$uri}<br/>
  <span>Node Count:</span> {count($root-node//node)}<br/>
  <ol>
    {local:view-taxonomy($root-node, $depth)}
  </ol>
</html>