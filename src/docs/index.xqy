xquery version "1.0-ml";
import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";
declare option xdmp:output "method=html";

let $title := 'Business Glossary Demonstration'

let $content :=
<div class="content">

  <h4>{$title}</h4>
  
  <p>Example of a typical business conversation:</p>
  
  <p style="font-size:16pt; font-style:italic">Our IBM DB2 CDB is not meeting our SLA for our CSR IVR ANI application.  
  Our CTO wants a Data Hub POC on ML STAT. What is your ROM estimate?
  </p>

  <table class="table table-striped table-bordered table-hover table-condensed">
   <thead>
      <tr>
         <th>Term</th>
         <th>Definition</th>
         <th>Entity Type</th>
      </tr>
   </thead>
   <tbody>
      <tr>
         <th>IBM</th>
         <td>Internlational Business Machines</td>
         <td>Company</td>
      </tr>
      <tr>
         <th>DB2</th>
         <td>Database 2</td>
         <td>Product Name</td>
      </tr>
      <tr>
         <th>CDB</th>
         <td>Customer Database</td>
         <td>Internal Database Name</td>
      </tr>
      <tr>
         <th>SLA</th>
         <td>Service Level Agreement</td>
         <td>Contract or Performance Agreement</td>
      </tr>
      <tr>
         <th>CSR</th>
         <td>Customer Service Representative</td>
         <td>Role in a call center</td>
      </tr>
      <tr>
         <th>IVR</th>
         <td>Interactive Voice Response</td>
         <td>Application</td>
      </tr>
      <tr>
         <th>ANI</th>
         <td>Automatic Number Identification</td>
         <td>Application Name</td>
      </tr>
      <tr>
         <th>APP</th>
         <td>Application</td>
         <td>Software component</td>
      </tr>
      <tr>
         <th>CTO</th>
         <td>Chief Technical Officer</td>
         <td>Job Title</td>
      </tr>
      <tr>
         <th>POC</th>
         <td>Proof of Concept</td>
         <td>Application category or development stage</td>
      </tr>
      <tr>
         <th>ML</th>
         <td>MarkLogic</td>
         <td>Worlds leading database that break down businss silos.</td>
      </tr>
      <tr>
         <th>STAT</th>
         <td>As soon as possible (medical term)</td>
         <td>Timeframe</td>
      </tr>
      <tr>
         <th>ROM</th>
         <td>Rough Order of Magnititude</td>
         <td>Estimate type</td>
      </tr>
     </tbody>
  </table>
  
  <p>One way to learn the meaning of these terms is to create a business glossary.  They typically have a list
  of terms and their defintions.  We can import these glossaries into MarkLogic and build a search application.</p>
  
  <p>Lets got to the US Federal Center for Medicare and Medicate and see what they have in their glossary.
  We have imported over one thousand terms into MarkLogic and built a search application.</p>
  
  <p>Lets do a search for the word "health".</p>
  
  <p>Note that we find around 300 terms that contain the word health.  In the search results we have the term name, the definition
  and a series of buttons that allow us to annotate these terms.  For example, we can serch for the word "provider" and if that
  is something that is imporant in our entity models, we can select the "Make Entity" buttion.  We can do similar actions
  to make terms properties or relationships.</p>
  
  <p>Once we have the enties, properties and relationships defined, we can run a report that lists all the entities in our glossary.
  This file can then be used as a basis for the MarkLogic-9 Entity Services system.</p>

  <a href="https://www.w3.org/2003/03/glossary-project/data/glossaries/">Sample W3C Glossaries in RDF</a>
</div>

return style:assemble-page($title, $content)