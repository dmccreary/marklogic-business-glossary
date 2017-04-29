xquery version "1.0-ml"; 
 
import module namespace pkg = "http://marklogic.com/manage/package" 
      at "/MarkLogic/manage/package/package.xqy";

let $database := xdmp:database()
let $database-name := xdmp:database-name($database)
return
pkg:database-configuration($database-name)