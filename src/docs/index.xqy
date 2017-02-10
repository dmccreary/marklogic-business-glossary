xquery version "1.0-ml";
import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";
declare option xdmp:output "method=html";

let $title := 'Business Glossary Demonstration'

let $content :=
<div class="content">

  <h4>{$title}</h4>
  
  <p>How do we accelerate the creation of Data Hubs?  
  I believe that the fundamental difference between a costly data Data Lake and a valuable Data Hub is semantics (with a small s).
  And by that I mean strong data definitions for every element in a Data Hub.
  
  To be useful, Data Hubs need precise definitions for documents, and their elements.  This means we need to excel at data governance and stewardship.  Here is
  one suggestion on how to get started in this area.</p>
  
  <p>Whenever I start on a new project, I listen carefully to the words customers use to state their requirements.</p>
  
  <p>Here is an example of a typical business conversation I had with a customer:</p>
  
  <p style="font-size:16pt; font-style:italic">Our IBM DB2 CDB is not meeting our SLA for our CSR IVR ANI application.  
  Our CTO wants a Data Hub POC on ML STAT. What is your ROM estimate?
  </p>
  
  <p>Notice how many terms and acronyms are used that have specific meaning within a given context.  We an usually
  work with the stakeholders in our pilot projects to create a business glossary of terms we will be using.
  Here is an example of these terms.</p>

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
         <td>International Business Machines</td>
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
         <th>Data Hub</th>
         <td>An integration pattern that stores data in consistent and semantically precise documents.</td>
         <td>Integration Pattern</td>
      </tr>
      <tr>
         <th>POC</th>
         <td>Proof of Concept</td>
         <td>Application category or development stage</td>
      </tr>
      <tr>
         <th>ML</th>
         <td>MarkLogic</td>
         <td>Worlds leading database that break down business silos.</td>
      </tr>
      <tr>
         <th>STAT</th>
         <td>As soon as possible (medical term)</td>
         <td>Time frame</td>
      </tr>
      <tr>
         <th>ROM</th>
         <td>Rough Order of Magnitude</td>
         <td>Estimate type</td>
      </tr>
     </tbody>
  </table>
  
  <p>Most business glossaries typically start with a list of terms and their definitions.
  
  Lets take a look at a typical business glossary.  Some of you might be familiar with the cms.gov site.
  Here is their business glossary:
  <br/><br/>
  <a href="https://www.cms.gov/apps/glossary/">Glossary for Center for Medicare and Medicaid</a>.
  <br/>
  <br/>
  <a href="https://www.cms.gov/apps/acronyms/">Acronyms in Center for Medicare and Medicaid</a>.  Note that CMS has event started to classify their abbreviations.
  
  <br/>
  <br/>
  We can also start to classify each term by assigning types to each term.  We can also arrange terms into tree-like
  structures called taxonomies by indicating that some terms have a narrower meaning than other terms.
  More importantly, by looking at terms and their types, we often start to get a sense of the key entities, 
  entity properties and relationships within a project.</p>
  
  <p>We can also import these terms into MarkLogic and build a search application.  If we put the terms into a standard format called
  SKOS, we can use a pre-built application.</p>
  
  <p>Lets got to the US Federal Center for Medicare and Medicate and see what they have in their glossary.
  We have imported over one thousand terms into MarkLogic and built a search application.</p>
  
   <p>Lets do a search for the word "health".  When we do a search we can see that there are facets to the left of the search results.
  This shows that some of these terms have been flagged as entities.</p>
  
  <p>Note that we found around 300 terms that contain the word health.  In the search results we have the term name, the definition
  and a series of buttons that allow us to annotate these terms.  For example, we can search for the word "provider" and if that
  is something that is important in our entity models, we can select the "Make Entity" button.  We can do similar actions
  to make terms properties or relationships.</p>
  
  <p>Once we have the entities, properties and relationships defined, we can run a report that lists all the entities in our glossary.
  This file can then be used as a basis for the MarkLogic-9 Entity Services system.</p>
  
  <p>Classification, enrichment and management of business glossaries in the foundation of good data stewardship. and data governance.  We
  can add other properties to each term, such as who created and approved each term.  Once specific terms have been approved and business
  entities, properties and relationships they can also be used as a foundation of building a entity model.  Entity models are critical
  for quickly building Data Hubs.</p>
  
  <p>If you use these tools to convert your business glossaries to SKOS format, you can also import them into other third party taxonomy and ontology editing tools.
  Our hope is that in the near future, there will be third part tools that display these entities.</p>
  
  <p>Don't get me wrong.  Building Enterprise Class data hubs in hard.  Finding the relationships between data, business rules, workflows and taxonomies
  can't be done with any single tool or process.  Our teams need to be trained in creating and customizing tools that accelerate this process.</p>
  
  <p>The bottom line is that to be a great integration company, we have to do more than build search applications.  We need
  to be able to build tools and workflows that leverage semantics standards and work with third parties that embrace these standards.</p>

  <a href="https://www.w3.org/2003/03/glossary-project/data/glossaries/">Sample W3C Glossaries in RDF</a>
</div>

return style:assemble-page($title, $content)