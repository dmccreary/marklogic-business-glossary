xquery version "1.0-ml";

module namespace l="http://danmccreary.com/list-resources";
(:
import module namespace l="http://danmccreary.com/list-resources" at "/modules/list-resources.xqy";
:)
declare namespace x="http://www.w3.org/1999/xhtml";

declare variable $l:resource-descriptions-uri := '/resource-descriptions.xml';
declare variable $l:resource-descriptions-doc := doc($l:resource-descriptions-uri)/resource-descriptions;
declare variable $l:resources := $l:resource-descriptions-doc/resource;

declare function l:resource-description($uri as xs:string) as element() {
let $resource := $l:resources[uri=$uri]
return
  if ($resource)
     then $resource
     else <error><message>No resoruce description for {$uri}</message></error>
};

(: Check to see if a directory exists.  Make sure to add the trailing slash.
Not sure why there is no built-in version of this like fn:doc-available() :)
declare function l:directory-available($uri as xs:string) as xs:boolean {
if (cts:uri-match($uri))
  then true()
  else false()
};

(: functions for database or disk-based modules are here :)
declare function l:get-listing($path as xs:string, $end-filter as xs:string?)
{
  let $module-database := xdmp:modules-database()
  return
    if ($module-database != 0 ) then
      l:get-uris($module-database, $path, $end-filter)
    else
      l:get-files($path, $end-filter)
};

declare function l:get-uris($module-db-id as xs:unsignedLong, $path as xs:string, $end-filter as xs:string?)
{
  let $qs := "cts:uri-match('" || $path || '/*' || $end-filter || "')"
  let $options :=
    <options xmlns="xdmp:eval">
      <database>{$module-db-id}</database>
    </options>
  let $uris := xdmp:eval($qs, (), $options)
  for $uri in $uris
    let $properties := xdmp:eval("xdmp:document-properties('" || $uri || "')", (), $options)
    return
      <entry>
        <uri>{$uri}</uri>
        <description/>
        <last-modified>{$properties//prop:last-modified/text()}</last-modified>
      </entry>
};

declare function l:get-files( $path as xs:string, $end-filter as xs:string)
{
  let $dir := xdmp:filesystem-directory(xdmp:modules-root() || $path )/dir:entry[dir:filename/fn:ends-with(., $end-filter)]
  for $d in $dir
  return
    <entry>
      <uri>{$path || "/" || $d/dir:filename}</uri>
      <description></description>
      <last-modified>{$d/dir:last-modified/text()}</last-modified>
    </entry>
};


