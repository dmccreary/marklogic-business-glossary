xquery version "1.0";


declare namespace mm="http://easymetahub.com/metamodel";

let $model-name := ./marklogic-entities/info/title/text()

return
element { 'mm:Model' } { 
    element { 'mm:Name' } { $model-name },
    for $entity in .//entities/entity
    return 
        element { 'mm:Entity' } { 
        <mm:Name>{$entity/name/text()}</mm:Name>,
        <mm:Mode>unallocated</mm:Mode>,
        <mm:SourceModel>{$model-name}</mm:SourceModel>,
        <mm:SourceType>entity-services</mm:SourceType>,
        <mm:SourceName>{$entity/name/text()}</mm:SourceName>,
        <mm:SourceTableType>TABLE</mm:SourceTableType>,
        <mm:RawDescription>{$entity/description/text()}</mm:RawDescription>,
        for $attribute in $entity/properties/property
        return element { 'mm:Attribute' } { 
            <mm:Name>{$attribute/property-name/text()}</mm:Name>,
            <mm:Type>{$attribute/datatype/text()}</mm:Type>,
            <mm:SourceName>{$attribute/property-name/text()}</mm:SourceName>,
            <mm:RawDescription>{$attribute/description/text()}</mm:RawDescription>
                }
        } 
}
