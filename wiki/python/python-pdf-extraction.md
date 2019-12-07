
[DZone Article on Extracting PDF Data with Python](https://dzone.com/articles/exporting-data-from-pdfs-with-python)

### Excellent Book on Automation and PDF Extraction in Downloads Folder -> automating-email-sms-pdf-extraction-etc.pdf

# Extract PDF Data using Python Tools | Inject into ElasticSearch | Create Search Function




Exporting Data From PDFs With Python
In this post, we will look at a variety of different packages that you can use to extract text. We will also learn how to extract some images from PDFs.
by Mike Driscoll
·
Sep. 14, 18 · Big Data Zone · Tutorial
Like (8)

Comment (1)
Save
Tweet
29.88k Views

Join the DZone community and get the full member experience. Join For Free

There are many times where you will want to extract data from a PDF and export it in a different format using Python. Unfortunately, there aren’t a lot of Python packages that do the extraction part very well. In this post, we will look at a variety of different packages that you can use to extract text. We will also learn how to extract some images from PDFs. While there is no complete solution for these tasks in Python, you should be able to use the information herein to get started. Once we have extracted the data we want, we will also look at how we can take that data and export it in a different format.

Let’s get started by learning how to extract text!
Extracting Text With PDFMiner

Probably the most well known is a package called PDFMiner. The PDFMiner package has been around since Python 2.4. Its primary purpose is to extract text from a PDF. In fact, PDFMiner can tell you the exact location of the text on the page as well as information about fonts. For Python 2.4-2.7, you can refer to the following websites for additional information on PDFMiner:

    GitHub – https://github.com/euske/pdfminer
    PyPI – https://pypi.python.org/pypi/pdfminer/
    Webpage – https://euske.github.io/pdfminer/

PDFMiner is not compatible with Python 3. Fortunately, there is a fork of PDFMiner called PDFMiner.six that works exactly the same. You can find it here: https://github.com/pdfminer/pdfminer.six

The directions for installing PDFMiner are out-dated at best. You can actually use pip to install it:

python -m pip install pdfminer

If you want to install PDFMiner for Python 3 (which is what you should probably be doing), then you have to do the install like this:

python -m pip install pdfminer.six

The documentation on PDFMiner is rather poor at best. You will most likely need to use Google and Stack Overflow to figure out how to use PDFMiner effectively outside of what is covered in this post.
Extracting All the Text

Sometimes you will want to extract all the text in the PDF. The PDFMiner package offers a couple of different methods that you can use to do this. We will look at some of the programmatic methods first. Let’s try reading all the text out of an Internal Revenue Service W9 form. You can get a copy here: https://www.irs.gov/pub/irs-pdf/fw9.pdf

Once you have the PDF properly saved off, we can look at the code:

import io

from pdfminer.converter import TextConverter

from pdfminer.pdfinterp import PDFPageInterpreter

from pdfminer.pdfinterp import PDFResourceManager

from pdfminer.pdfpage import PDFPage

def extract_text_from_pdf(pdf_path):

    resource_manager = PDFResourceManager()

    fake_file_handle = io.StringIO()

    converter = TextConverter(resource_manager, fake_file_handle)

    page_interpreter = PDFPageInterpreter(resource_manager, converter)

    with open(pdf_path, 'rb') as fh:

        for page in PDFPage.get_pages(fh, 

                                      caching=True,

                                      check_extractable=True):

            page_interpreter.process_page(page)

        text = fake_file_handle.getvalue()

    # close open handles

    converter.close()

    fake_file_handle.close()

    if text:

        return text

if __name__ == '__main__':

    print(extract_text_from_pdf('w9.pdf'))

The PDFMiner package tends to be a bit verbose when you use it directly. Here, we import various bits and pieces from various parts of PDFMiner. Since there is no documentation of any of these classes and no docstrings either, I won’t explain what they do in depth. Feel free to dig into the source code yourself if you’re really curious. However, I think we can kind of follow along with the code.

The first thing we do is create a resource manager instance. Then we create a file-like object via Python’s io module. If you are using Python 2, then you will want to use the StringIO module. Our next step is to create a converter. In this case, we choose the TextConverter, however you could also use an HTMLConverter or an XMLConverter if you wanted to. Finally, we create a PDF interpreter object that will take our resource manager and converter objects and extract the text.

The last step is to open the PDF and loop through each page. At the end, we grab all the text, close the various handlers, and print out the text to stdout.
Extracting Text by Page

Frankly, grabbing all the text from a multi-page document isn’t all that useful. Usually, you will want to do work on smaller subsets of the document instead. So, let’s rewrite the code so it extracts text on a page-by-page basis. This will allow us to examine the text, one page at a time:

# miner_text_generator.py

import io

from pdfminer.converter import TextConverter

from pdfminer.pdfinterp import PDFPageInterpreter

from pdfminer.pdfinterp import PDFResourceManager

from pdfminer.pdfpage import PDFPage

def extract_text_by_page(pdf_path):

    with open(pdf_path, 'rb') as fh:

        for page in PDFPage.get_pages(fh, 

                                      caching=True,

                                      check_extractable=True):

            resource_manager = PDFResourceManager()

            fake_file_handle = io.StringIO()

            converter = TextConverter(resource_manager, fake_file_handle)

            page_interpreter = PDFPageInterpreter(resource_manager, converter)

            page_interpreter.process_page(page)

            text = fake_file_handle.getvalue()

            yield text

            # close open handles

            converter.close()

            fake_file_handle.close()

def extract_text(pdf_path):

    for page in extract_text_by_page(pdf_path):

        print(page)

        print()

if __name__ == '__main__':

    print(extract_text('w9.pdf'))

In this example, we create a generator function that yields the text for each page. The extract_text function prints out the text of each page. This is where we could add some parsing logic to parse out what we want. Or we could just save the text (or HTML or XML) off as individual files for future parsing.

You will note that the text may not be in the order you expect. So you will definitely need to figure out the best way to parse out the text that you are interested in.

The nice thing about PDFMiner is that you can already “export” the PDF as text, HTML or XML.

You can also use PDFMiner’s command line tools, pdf2txt.py and dumppdf.py, to do the exporting for you if you don’t want to try to figure out PDFMiner yourself. According to the source code of pdf2txt.py, it can be used to export a PDF as plain text, HTML, XML, or “tags.”
Exporting Text via pdf2txt.py

The pdf2txt.py command line tool that comes with PDFMiner will extract text from a PDF file and print it out to stdout by default. It will not recognize text-based images, as PDFMiner does not support optical character recognition (OCR). Let’s try the simplest method of using it, which is just passing it the path to a PDF file. We will use the w9.pdf. Open up a terminal and navigate to the location that you have saved that PDF or modify the command below to point to that file:

pdf2txt.py w9.pdf

If you run this, it will print out all the text to stdout. You can also make pdf2txt.py write the text to file as text, HTML, XML, or “tagged PDF.” The XML format will give to the most information about the PDF as it contains the location of each letter in the document as well as font information. HTML is not recommended, as the markup pdf2txt generates tends to be ugly. Here’s how you can get different formats output:

pdf2txt.py -o w9.html w9.pdf 

pdf2txt.py -o w9.xml w9.pdf

The first command will create an HTML document while the second will create an XML document. 

The end result looks a bit off, but it’s not too bad. The XML it outputs is extremely verbose, so I can’t reproduce it all here. However, here is a snippet to give you an idea of what it looks like:

<pages>

<page id="1" bbox="0.000,0.000,611.976,791.968" rotate="0">

<textbox id="0" bbox="36.000,732.312,100.106,761.160">

<textline bbox="36.000,732.312,100.106,761.160">

<text font="JYMPLA+HelveticaNeueLTStd-Roman" bbox="36.000,736.334,40.018,744.496" size="8.162">F</text>

<text font="JYMPLA+HelveticaNeueLTStd-Roman" bbox="40.018,736.334,44.036,744.496" size="8.162">o</text>

<text font="JYMPLA+HelveticaNeueLTStd-Roman" bbox="44.036,736.334,46.367,744.496" size="8.162">r</text>

<text font="JYMPLA+HelveticaNeueLTStd-Roman" bbox="46.367,736.334,52.338,744.496" size="8.162">m</text>

<text font="JYMPLA+HelveticaNeueLTStd-Roman" bbox="52.338,736.334,54.284,744.496" size="8.162"> </text>

<text font="JYMPLA+HelveticaNeueLTStd-Roman" bbox="54.284,736.334,56.230,744.496" size="8.162"> </text>

<text font="JYMPLA+HelveticaNeueLTStd-Roman" bbox="56.230,736.334,58.176,744.496" size="8.162"> </text

><text font="JYMPLA+HelveticaNeueLTStd-Roman" bbox="58.176,736.334,60.122,744.496" size="8.162"> </text>

<text font="ZWOHBU+HelveticaNeueLTStd-BlkCn" bbox="60.122,732.312,78.794,761.160" size="28.848">W</text>

<text font="ZWOHBU+HelveticaNeueLTStd-BlkCn" bbox="78.794,732.312,87.626,761.160" size="28.848">-</text>

<text font="ZWOHBU+HelveticaNeueLTStd-BlkCn" bbox="87.626,732.312,100.106,761.160" size="28.848">9</text>

<text></text>

</textline>

Extracting Text With Slate

Tim McNamara didn’t like how obtuse and difficult PDFMiner is to use, so he wrote a wrapper around it called slate that makes it much easier to extract text from PDFs. Unfortunately, it does not appear to be Python 3 compatible. If you want to give it a try, you may need to have easy_install available to install the distribute package, like this:

easy_install distribute

I wasn’t able to get pip to install that package correctly. Once it’s installed though, you will be able to use pip to install slate:

python -m pip install slate

Note that the latest version is 0.5.2 and pip may or may not grab that version. If it does not, then you can install slate directly from GitHub:

python -m pip install git+https://github.com/timClicks/slate

Now we’re ready to write some code to extract the text from a PDF:

# slate_text_extraction.py

import slate

def extract_text_from_pdf(pdf_path):

    with open(pdf_path) as fh:

        document = slate.PDF(fh, password='', just_text=1)

    for page in document:

        print(page)

if __name__ == '__main__':

    extract_text_from_pdf('w9.pdf')

As you can see, to make slate parse a PDF, you just need to import slate and then create an instance of its PDF class. The PDF class is actually a subclass of Python’s list built-in, so it just returns a list/iterable of pages of text. You will also note that we can pass in a password argument if the PDF has a password set. Anyway, once the document is parsed, we just print out the text on each page.

I really like how much easier it is to use slate. Unfortunately there is almost no documentation associated with this package either. After looking through the source code, it appears that all this package supports is text extraction.
Exporting Your Data

Now that we have some text to work with, we will spend some time learning how to export that data in a variety of different formats. Specifically, we will learn how to export our text in the following ways:

    XML
    JSON
    CSV

Let’s get started!
Exporting to XML

The eXtensible Markup Language (XML) format is one of the most well known output and input formats. It is used widely on the internet for many different things. As we have already seen in this post, PDFMiner also supports XML as one of its outputs.

Let’s create our own XML creation tool, though. Here’s a simple example:

# xml_exporter.py

import os

import xml.etree.ElementTree as xml

from miner_text_generator import extract_text_by_page

from xml.dom import minidom

def export_as_xml(pdf_path, xml_path):

    filename = os.path.splitext(os.path.basename(pdf_path))[0]

    root = xml.Element('{filename}'.format(filename=filename))

    pages = xml.Element('Pages')

    root.append(pages)

    counter = 1

    for page in extract_text_by_page(pdf_path):

        text = xml.SubElement(pages, 'Page_{}'.format(counter))

        text.text = page[0:100]

        counter += 1

    tree = xml.ElementTree(root)

    xml_string = xml.tostring(root, 'utf-8')

    parsed_string = minidom.parseString(xml_string)

    pretty_string = parsed_string.toprettyxml(indent='  ')

    with open(xml_path, 'w') as fh:

        fh.write(pretty_string)

    #tree.write(xml_path)

if __name__ == '__main__':

    pdf_path = 'w9.pdf'

    xml_path = 'w9.xml'

    export_as_xml(pdf_path, xml_path)

This script will use Python’s built-in XML libraries, minidom and ElementTree. We also import our PDFMiner generator script that we use to grab a page of text at a time. In this example, we create our top level element which is the file name of the PDF. Then we add a Pages element underneath it. The next step is our for loop where we extract each page from the PDF and save off the information we want. Here is where you could add a special parser where you might split up the page into sentences or words and parse out more interesting information. For example, you might want only sentences with a particular name or date/timestamp. You can use Python’s Regular Expressions to find those sorts of things or just check for the existence of sub-strings in the sentence.

For this example, we just extract the first 100 characters from each page and save them off into an XML SubElement. Technically, the next bit of code could be simplified to just write out the XML. However, ElementTree doesn’t do anything to the XML to make it easy to read. It kind of ends up looking like minified JavaScript in that its just one giant block of text. So instead of writing that block of text to disk, we use minidom to “prettify” the XML with whitespace before writing it out. The result ends up looking like this:

<?xml version="1.0" ?>

<w9>

  <Pages>

    <Page_1>Form    W-9(Rev. November 2017)Department of the Treasury  Internal Revenue Service Request for Taxp</Page_1>

    <Page_2>Form W-9 (Rev. 11-2017)Page 2 By signing the filled-out form, you: 1. Certify that the TIN you are g</Page_2>

    <Page_3>Form W-9 (Rev. 11-2017)Page 3 Criminal penalty for falsifying information. Willfully falsifying cert</Page_3>

    <Page_4>Form W-9 (Rev. 11-2017)Page 4 The following chart shows types of payments that may be exempt from ba</Page_4>

    <Page_5>Form W-9 (Rev. 11-2017)Page 5 1. Interest, dividend, and barter exchange accounts opened before 1984</Page_5>

    <Page_6>Form W-9 (Rev. 11-2017)Page 6 The IRS does not initiate contacts with taxpayers via emails. Also, th</Page_6>

  </Pages>

</w9>

That’s pretty clean XML and it’s also easy to read. For bonus points, you could take what you learned in the PyPDF2 section and use it to extract the metadata from the PDF and add it to your XML as well.
Exporting to JSON

JavaScript Object Notation, or JSON, is a lightweight data-interchange format that is easy to read and write. Python includes a json module in its standard library that allows you to read and write JSON programmatically. Let’s take what we learned from the previous section and use that to create an exporter script that outputs JSON instead of XML:

# json_exporter.py

import json

import os

from miner_text_generator import extract_text_by_page

def export_as_json(pdf_path, json_path):

    filename = os.path.splitext(os.path.basename(pdf_path))[0]

    data = {'Filename': filename}

    data['Pages'] = []

    counter = 1

    for page in extract_text_by_page(pdf_path):

        text = page[0:100]

        page = {'Page_{}'.format(counter): text}

        data['Pages'].append(page)

        counter += 1

    with open(json_path, 'w') as fh:

        json.dump(data, fh)

if __name__ == '__main__':

    pdf_path = 'w9.pdf'

    json_path = 'w9.json'

    export_as_json(pdf_path, json_path)

Here, we import the various libraries that we need, including our PDFMiner module. Then we create a function that accepts the PDF input path and the JSON output path. JSON is basically a dictionary in Python, so we create a couple of simple top-level keys: Filename and Pages. The Pages key maps to an empty list. Next, we loop over each page of the PDF and extract the first 100 characters of each page. Then we create a dictionary with the page number as the key and the 100 characters as the value and append it to the top-level Page’s list. Finally, we write the file using the json module’s dump command.

The contents of the file ended up looking like this:

{'Filename': 'w9',

 'Pages': [{'Page_1': 'Form    W-9(Rev. November 2017)Department of the Treasury  Internal Revenue Service Request for Taxp'},

           {'Page_2': 'Form W-9 (Rev. 11-2017)Page 2 By signing the filled-out form, you: 1. Certify that the TIN you are g'},

           {'Page_3': 'Form W-9 (Rev. 11-2017)Page 3 Criminal penalty for falsifying information. Willfully falsifying cert'},

           {'Page_4': 'Form W-9 (Rev. 11-2017)Page 4 The following chart shows types of payments that may be exempt from ba'},

           {'Page_5': 'Form W-9 (Rev. 11-2017)Page 5 1. Interest, dividend, and barter exchange accounts opened before 1984'},

           {'Page_6': 'Form W-9 (Rev. 11-2017)Page 6 The IRS does not initiate contacts with taxpayers via emails. Also, th'}]}

Once again, we have some nice output that is easy to read. You could enhance this example with the PDF’s metadata as well, if you would like to. Note that the output will change depending on what you want to parse out of each page or document.

Now let’s take a quick look at how we could export to CSV.
Exporting to CSV

CSV stands for **comma separated values**. It is a pretty standard format that has been around a very long time. The nice thing about CSV is that Microsoft Excel and LibreOffice will open them up in a nice spreadsheet automatically. You can also open up CSV files in a text editor if you’d like to see the raw value.

Python has a built-in csv module that you can use to read and write CSV files. We will use it here to create a CSV from the text that we extract from the PDF. Let’s take a look at some code:

# csv_exporter.py

import csv

import os

from miner_text_generator import extract_text_by_page

def export_as_csv(pdf_path, csv_path):

    filename = os.path.splitext(os.path.basename(pdf_path))[0]

    counter = 1

    with open(csv_path, 'w') as csv_file:

        writer = csv.writer(csv_file)

        for page in extract_text_by_page(pdf_path):

            text = page[0:100]

            words = text.split()

            writer.writerow(words)

if __name__ == '__main__':

    pdf_path = 'w9.pdf'

    csv_path = 'w9.csv'

    export_as_csv(pdf_path, csv_path)

For this example, we import Python’s csv library. Otherwise, the imports are the same as the previous example. In our function, we create a CSV file handler using the CSV file path. Then we initialize a CSV writer object with that file handler as its sole argument. Next, we loop over the pages of the PDF as before. The only difference here is that we split the first 100 characters into individual words. This allows us to have some actual data to add to the CSV. If we did not do this, then each row would only have one element in it, which isn’t really a CSV file at that point. Finally, we write out our list of words to the CSV file.

This is the result I got:

Form,W-9(Rev.,November,2017)Department,of,the,Treasury,Internal,Revenue,Service,Request,for,Taxp

Form,W-9,(Rev.,11-2017)Page,2,By,signing,the,filled-out,"form,",you:,1.,Certify,that,the,TIN,you,are,g

Form,W-9,(Rev.,11-2017)Page,3,Criminal,penalty,for,falsifying,information.,Willfully,falsifying,cert

Form,W-9,(Rev.,11-2017)Page,4,The,following,chart,shows,types,of,payments,that,may,be,exempt,from,ba

Form,W-9,(Rev.,11-2017)Page,5,1.,"Interest,","dividend,",and,barter,exchange,accounts,opened,before,1984

Form,W-9,(Rev.,11-2017)Page,6,The,IRS,does,not,initiate,contacts,with,taxpayers,via,emails.,"Also,",th

I think this one is a bit harder to read than the JSON or XML examples, but it’s not too bad. Now let’s move on and look at how we might extract images from a PDF.
Extracting Images From PDFs

Unfortunately, there are no Python packages that actually do image extraction from PDFs. The closest thing I found was a project called minecart that claims to be able to do it, but only works on Python 2.7. I was not able to get it to work with the sample PDFs I had. There is an article on Ned Batchelder’s blog that talks a bit about how he was able to extract JPGs from PDFs. His code is as follows:

# Extract jpg's from pdf's. Quick and dirty.

import sys

pdf = file(sys.argv[1], "rb").read()

startmark = "\xff\xd8"

startfix = 0

endmark = "\xff\xd9"

endfix = 2

i = 0

njpg = 0

while True:

    istream = pdf.find("stream", i)

    if istream < 0:

        break

    istart = pdf.find(startmark, istream, istream+20)

    if istart < 0:

        i = istream+20

        continue

    iend = pdf.find("endstream", istart)

    if iend < 0:

        raise Exception("Didn't find end of stream!")

    iend = pdf.find(endmark, iend-20)

    if iend < 0:

        raise Exception("Didn't find end of JPG!")

    istart += startfix

    iend += endfix

    print("JPG %d from %d to %d" % (njpg, istart, iend))

    jpg = pdf[istart:iend]

    jpgfile = file("jpg%d.jpg" % njpg, "wb")

    jpgfile.write(jpg)

    jpgfile.close()

    njpg += 1

    i = iend

This also did not work for the PDFs I was using. There are some people in the comments that do claim it works for some of their PDFs and there are some examples of updated code in the comments too. Stack Overflow has variations of this code on it, some of which use PyPDF2 in some way or another. None of these worked for me either.

My recommendation is to use a tool like Poppler to extract the images. Poppler has a tool called pdfimages that you can use with Python’s subprocess module. Here’s how you could use it without Python:

pdfimages -all reportlab-sample.pdf images/prefix-jpg

Make sure that the images folder (or whatever output folder you want to create) is already created as pdfimages doesn’t create it for you.

Let’s write up a Python script that also executes this command and will make sure the output folder exists for you too:

# image_exporter.py

import os

import subprocess

def image_exporter(pdf_path, output_dir):

    if not os.path.exists(output_dir):

        os.makedirs(output_dir)

    cmd = ['pdfimages', '-all', pdf_path, 

           '{}/prefix'.format(output_dir)]

    subprocess.call(cmd)

    print('Images extracted:')

    print(os.listdir(output_dir))

if __name__ == '__main__':

    pdf_path = 'reportlab-sample.pdf'

    image_exporter(pdf_path, output_dir='images')

In this example, we import the subprocess and os modules. If the output directory does not exist, we attempt to create it. Them we use subprocess’s call method to execute pdfimages. We use call because it will wait for pdfimages to finish running. You could use Popen instead, but that will basically run the process in the background. Finally, we print out a listing of the output directory to confirm that images were extracted to it.

There are some other articles on the internet that reference a library called Wand that you might also want to try. It is an ImageMagick wrapper. Also of note is that there is a Python binding to Poppler called pypoppler, although I wasn’t able to find any examples of that package that did image extraction.
Wrapping Up

We covered a lot of different information in this post. We learned about several different packages that we can use to extract text from PDFs such as PDFMiner or Slate. We also learned how to use Python’s built-in libraries to export the text to XML, JSON, and CSV. Finally, we looked at the difficult problem of exporting images from PDFs. While Python does not currently have any good libraries for this task, you can workaround that by using other tools, such as Poppler’s pdfimage utility.
