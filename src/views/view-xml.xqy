xquery version "1.0-ml";

let $uri := xdmp:get-request-field('uri')

return
  if (not($uri))
     then
        <error>
          <message>uri is a required parameter.</message>
        </error>
   else if (doc-available($uri))
      then doc($uri)/*
      else
      <error code="404">
         <message>{$uri} not found.</message>
      </error>
