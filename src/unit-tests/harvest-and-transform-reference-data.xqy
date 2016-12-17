xquery version "1.0-ml";
import module namespace style = "http://uhc.com/odm/style" at "/modules/style.xqy"; 
declare option xdmp:output "method=html";

let $title := "Convert CDC Vaccine forms to Optum Reference Data Formats" 
let $source := 'https://www2a.cdc.gov/vaccines/iis/iisstandards/XML.asp?rpt=tradename'
let $uri := '/input-reference-data/vaccine-product-list-in-name-value-pairs.xml'

let $doc-available := doc-available($uri)
(:
<productnames>
<prodInfo>
  <Name>CDC Product Name</Name>
  <Value>ACAM2000</Value>
  <Name>Short Description</Name>
  <Value>vaccinia (smallpox)</Value>
  <Name>CVXCode</Name>
  <Value>75 </Value>
  <Name>Manufacturer</Name>
  <Value>sanofi pasteur</Value>
  <Name>MVX Code</Name>
  <Value>PMC </Value>
  <Name>MVX Status</Name>
  <Value>Active</Value>
  <Name>Product name Status</Name>
  <Value>Active</Value>
  <Name>Last Updated</Name>
  <Value>5/28/2010</Value>
  :)
  
let $products := doc($uri)/productnames/prodInfo
let $product-count := count($products)

let $new-format :=
<codes xmlns="http://uhc.com/odm/c360/reference-data">
    <code-name>vaccine-products</code-name>
    <desc>Source: {$source}</desc>
    <items>
       {for $product in $products
           return
            <item>
               <value>{$product/Value[1]}</value>
               <label>{$product/Value[2]}</label>
            </item>
        }
    </items>
</codes>

let $insert := xdmp:document-insert('/reference-data/vaccine-codes.xml', $new-format)
  
let $content :=
<div class="container">
    <h4>{$title}</h4>
    Document Available = {$doc-available}<br/>
    Number of Vaccine Products = { $product-count }<br/>

</div>

return style:assemble-page($title, $content)