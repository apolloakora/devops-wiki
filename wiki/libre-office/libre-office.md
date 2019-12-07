

# LibreOffice | Install on Ubuntu 16.04 and 18.04

Installing LibreOffice from the Ubuntu repositories is advised due to a complex dependency network and the ability to receive automatic updates.

## LibreOffice Full Install

Performing a full installation is the recommended way to install LibreOffice in Ubuntu. One would do this by installing the LibreOffice metapackage via a terminal.

``` bash
sudo apt-get install libreoffice
```

## LibreOffice Partial Install

This will install LibreOffice and give you the ability to read and write PDF files.

sudo apt-get install --assume-yes libreoffice-writer libreoffice-pdfimport


libreoffice-writer: Word processor
libreoffice-calc: Spreadsheet
libreoffice-impress: Presentation
libreoffice-draw: Drawing
libreoffice-base: Database
libreoffice-math: Equation editor
libreoffice-filter-mobiledev: Mobile Devices filters

libreoffice-filter-binfilter: legacy filters (e.g. StarOffice 5.2) 




Installing other related packages (dictionaries, extensions, clipart, templates, etc.)

    Additional language modules, help files and extensions are also available if you search for libreoffice in your package manager. Example how to search:

    apt-cache search libreoffice-help-en
    Here are a few examples:
libreoffice-help-*: help files
libreoffice-l10n-*: localization files

libreoffice-pdfimport: LibreOffice extension for importing PDF documents

libreoffice-presentation-minimizer: LibreOffice extension for size-efficient presentations

libreoffice-presenter-console: LibreOffice Impress extension for a separate presenter's console

libreoffice-report-builder-bin: LibreOffice extension for building database reports -- libraries
mozilla-libreoffice: office productivity suite -- Mozilla plugin