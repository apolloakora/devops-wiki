



# Convert Markdown Documents to PDF

**Markdown** is a super-friendly and productive markup language which eradicates the complexity of writing html for simple documents. Markdown is also perfect for version control due to its textual nature and has thus been adopted by IT professionals the world over.

**PDF** is another doc format that has taken the world by storm. With PDF - you can guarantee the user experience when reading documents on any device (tablet, PC and laptop) within any operating system (Windows, Linux and Mac).

Converting markdown to PDF is a use case that bridges both worlds. You can version control your documentation and then get your build system to convert it to the user readable and distributable PDF format.

This blog tells us how.

## How to Install Pandoc

```bash
sudo apt-get install --assume-yes pandoc
sudo apt-get install --assume-yes texlive-latex-base
sudo apt-get install --assume-yes texlive-fonts-recommended
sudo apt-get install --assume-yes texlive-fonts-extra
sudo apt-get install --assume-yes texlive-latex-extra
pandoc markdown-file.md -s -o markdown-new.pdf
```

## use PanDoc and NodeJs to Convert Markdown to PDF

These commands tend towards using node.js for markdown to pdf conversion. The end result should look and feel much better than the pandoc option.

```bash
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install -y nodejs
npm install markdown-pdf
```
