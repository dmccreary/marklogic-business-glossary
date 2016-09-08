xquery version "1.0-ml";

module namespace util="http://danmccreary.com/util";
(:
import module namespace util="http://danmccreary.com/util" at "/modules/util.xqy";
:)
declare namespace x="http://www.w3.org/1999/xhtml";

(: format all document counts using commas as a group separater :)
declare function util:fmt-count($sequence as item()*) as xs:string {
format-number(count($sequence), '#,###')
};

(: format integer with commas, might be an integer or a string :)
declare function util:fmt-integer($in as item()) as xs:string {
format-number(number($in), '#,###')
};

declare function util:fmt-duration($duration as xs:dayTimeDuration) as xs:string {
let $total-days := round($duration div xs:dayTimeDuration('P1D'))
let $total-days-string :=
   if ($total-days eq 0)
      then ()
      else if ($total-days eq 1)
         then concat(string($total-days), ' d, ')
         else concat(string($total-days), ' ds, ')
      
let $hours := string(hours-from-duration($duration))
let $minutes := string(minutes-from-duration($duration))
let $seconds := string(round(seconds-from-duration($duration)))
return concat($total-days-string, $hours, ' hr ', $minutes, ' min ', $seconds, ' sec')
};

(: convert the first letter of a string to be upper case :)
declare function util:first-letter-upper-case($input as xs:string?) as xs:string? {
let $first-letter := substring($input, 1, 1)
let $rest := substring($input, 2)
return concat(upper-case($first-letter), $rest)
};

(: Sdd the bootstrap context classes attributes of we have boolean values for an input. :)
declare function util:color-background-for-boolean($input as xs:boolean) {
  if ($input)
     then attribute class {'success center'}
     else attribute class {'warning center'}
};

(: Check to see if a directory exists.  Make sure to add the trailing slash.
Not sure why there is no built-in version of this like fn:doc-available() :)
declare function util:directory-available($uri as xs:string) as xs:boolean {
if (cts:uri-match($uri))
  then true()
  else false()
};