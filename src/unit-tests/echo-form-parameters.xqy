xquery version "1.0-ml";

let $names := xdmp:get-request-field-names()

return
<results>
  {for $name in $names
   return
     <field>
        <name>{$name}</name>
        <value>{xdmp:get-request-field($name)}</value>
     </field>
    }
</results>