
# Style and Export a Confluence Space to PDF


## [Confluence | How to Style PDFs](https://confluence.atlassian.com/doc/customize-exports-to-pdf-190480945.html "Confluence PDF Styling Guide")

This confluence page tells us how to

- set a space PDF stylesheet
- change the page size (A4, A5) and orientation (portrait, landscape)
- set margis so that on printing we have a gutter on the left
- set page breaks so that the PDF has decent delineation
- add the HTML which will be formatted to create a title page
- add an image to the title page
- enable or disable the table of contents
- add header and footers including page numbers

## Confluence PDF StyleSheet Example

The below PDF stylesheet for Confluence spaces includes page numbers, centred header and footer titles and page breaks between pages.

```css
.pagetitle  
{  
   page-break-before: always;  
}  
  
@page
{  
      @bottom-right
      {   
            content: counter(page) " / " counter(pages);   
      }  
}  
  
  
@page  
{  
    @top-center  
    {  
        content: "Grand Designs Title"; /* Appears on each page header. */  
        font-family: ConfluenceInstalledFont, Helvetica, Arial, sans-serif;  
        font-size: 8pt;  
    }  

    @bottom-center  
    {  
        content: "Hello World " counter(page); /* This footer text is centred with a space then page number. */  
        font-family: ConfluenceInstalledFont, Helvetica, Arial, sans-serif;  
        font-size: 8pt;  
    }  
    /* Any other page-specific rules */  
}  
```



## Exporting a multi-page confluence space.

To export a multi-page confluence space to a professional PDF you

- produce a one-page cover PDF
- use Confluence to export the space to a PDF
- attach your cover PDF to the Confluence PDF

Why not also append one or more **end (trailing) PDF pages** to your Confluence PDF - perfect for producing a wow factor at your project meeting.


<pre>
## How to Export a Multi-Page Confluence Space into PDF

To export pages to HTML, XML, or PDF:

- Go to the space and choose Space tools > Content Tools from the bottom of the sidebar
- Choose Export
- Select either HTML, XML, or PDF, then choose Next
- Select either a normal or custom export to PDF
- Choose Export

When the export process has finished, you can download the PDF.
</pre>

If you do this frequently - you can consider automating it with Selinium (through Java, Ruby, Python or Go).
