# Web Page Must Have Features

A high quality web page has a **must-have** set of *features* no matter whether it is a use case, a frequently asked questions list, or a **module's interface documentation**.

[[_TOC_]]

## Auto Generated Bread Crumbs

Bread crumb links help the user track back from a depth drill down. An example is

home &raquo; polygon &raquo; quadrilateral &raquo; rhombus

## Auto Generated Table of Contents

The table of contents is near the top and aids navigation to sections within the page.

A nice to have feature are "Back to Top" links to track back after speeding down.

## Auto Generated Intra Site (Internal) Links

Links should be auto-generated when a page about Wordpress mentions **Docker Compose** and/or **MySQL** and corresponding pages on these technologies exist (within the same site).

With MediaWiki this feature comes as standard. Plugins are available that implement this feature for WordPress (although most are labour intensive).

Internal linking for Markdown pages can be added with a Ruby gem this fitting SSGs (static site generators) like Gollum wih the feature.

## A PDF Version of the Page

PDF enables the user to read the page later, to add it to their library and to share the page via e-mail and social platforms with others.

The PDF must be auto-generated at least once a day if it is detected that the page has changed or has just been created.

## Links to Related Books in PDF Format

Tools like ElasticSearch can understand the essence of the page and relates it to a library of pdf documentation.

If **strong** or **very strong** matches are found - the (up to 5) related books should be automatically listed on the page.