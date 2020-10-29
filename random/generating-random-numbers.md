
# How to Generate Random Sequences

We can generate random character sequences in MacOSx using the below commands. Use the terminal rather than emacs on MacOSx.

```
export LC_CTYPE=C   # tell tr to expect binary data instead of UTF-8 characters "tr: Illegal byte sequence"
cat /dev/urandom | head -c 2000 | tr -dc 'A-Za-z0-9!@$%^&*()\-_+={}[]:;|,.<>?/~'
cat /dev/urandom | head -c 2000 | tr -dc 'A-Za-z0-9!@$%^&*()\-_+={}[]:;|,.<>?/~' | grep -F '~'
```


