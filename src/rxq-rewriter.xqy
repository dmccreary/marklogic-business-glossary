xquery version "1.0-ml";

import module namespace rxq="http://exquery.org/ns/restxq" at "/modules/rxq.xqy";
import module namespace api = "http://danmccreary.com/api" at "/modules/api.xqy";

declare default function namespace "http://www.w3.org/2005/xpath-functions";

declare option xdmp:mapping "false";

declare variable $ENABLE-CACHE as xs:boolean := fn:false();

rxq:process-request($ENABLE-CACHE)