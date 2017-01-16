xquery version "1.0-ml";
declare option xdmp:output "method=json";
declare option xdmp:output "indent=yes";

let $rootmap := map:new()

let $add-name := map:put($rootmap, "entity-file-name", "test")

let $add-desc := map:put($rootmap, "entity-file-desc", "This is descriptive text")

let $entities := 
<entities>
    <entity>
         <entity-name>Provider</entity-name>
         <entity-desc>A provider of healthcare services</entity-desc>
    </entity>
    <entity>
         <entity-name>Claim</entity-name>
         <entity-desc>A document sent to a payor requestiong reimbursement.</entity-desc>
    </entity>
    <entity>
         <entity-name>Drug</entity-name>
         <entity-desc>A chemical taken by a person.</entity-desc>
    </entity>
        <entity>
         <entity-name>Preseription</entity-name>
         <entity-desc>A document authorizing the purchase of a drug.</entity-desc>
    </entity>
</entities>

let $add-entities :=
   for $entity in $entities/entity
      let $entity-map := map:new()
      let $name := map:put($entity-map, 'entity-name', $entity/entity-name/text())
      let $desc := map:put($entity-map, 'entity-desc', $entity/entity-desc/text())
      return map:put($rootmap, 'entity', $entity-map)
      
return

  $rootmap
