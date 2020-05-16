
# Inspect Software

```bash
sudo apt-get --assume-yes install cloc
cloc .
```
## cloc | Quick Analysis

Clock with directory in default mode gives a nice breakdown of file types, blank lines and comments split by languages it knows about.

<pre>
      74 text files.
      64 unique files.                              
      50 files ignored.

github.com/AlDanial/cloc v 1.74  T=0.12 s (208.3 files/s, 21697.1 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
YAML                            10            156             25           1615
JSON                            13              0              0            767
Bourne Shell                     2             12              0             29
-------------------------------------------------------------------------------
SUM:                            25            168             25           2411
-------------------------------------------------------------------------------
</pre>

