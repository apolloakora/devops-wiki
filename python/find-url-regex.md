
# Find Url Regular Expression

This is a clever little slice of python code that pulls out all strings matching the Url pattern and puts them in a list. It uses the **re** **regular expression** package.

```python
# Python code to find the URL from an input string 
# Using the regular expression 
import re 

def Find(string): 
	# findall() has been used 
	# with valid conditions for urls in string 
	url = re.findall('http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+] 
	|[!*\(\), ]|(?:%[0-9a-fA-F][0-9a-fA-F]))+', string) 
	return url 
	
# Driver Code 
string = 'My Profile: https://auth.geeksforgeeks.org 
/ user / Chinmoy % 20Lenka / articles in
the portal of http://www.geeksforgeeks.org/' 
print("Urls: ", Find(string)) 
```
