
# Counting at the Linux Command Line

Often we will want to use our command line interface (cli) to count a whole gamut of things.

## Counting Characters in a String

```
echo -n "Please Count Me" | wc -c
```

The answer should be 15. If you **omit** the **`-n`** switch the answer is 16 because the echoed new-line character is counted.


