
# Converting Strings, Binary, Hex and Numbers in Ruby

Conversion from String to binary 
Easiest way, using unpack and tell Ruby that it is binary
"Hello".unpack("B*")
=> ["0100100001100101011011000110110001101111"]


	-100.to_s(2)                         # => "-1100100"

2.6. Converting Between Numeric Bases
Problem
You want to convert numbers from one base to another.

Solution
You can convert specific binary, octal, or hexadecimal numbers to decimal by representing them with the 0b, 0o, or 0x prefixes:

	0b100                                # => 4
	0o100                                # => 64
	0x100                                # => 256
You can also convert between decimal numbers and string representations of those numbers in any base from 2 to 36. Simply pass the base into String#to_i or Integer#to_s.

Here are some conversions between string representations of numbers in various bases, and the corresponding decimal numbers:

	"1045".to_i(10)                      # => 1045
	"-1001001".to_i(2)                   # => -73
	"abc".to_i(16)                       # => 2748
	"abc".to_i(20)                       # => 4232
	"number".to_i(36)                    # => 1442151747
	"zz1z".to_i(36)                      # => 1678391
	"abcdef".to_i(16)                    # => 11259375
	"AbCdEf".to_i(16)                    # => 11259375
Here are some reverse conversions of decimal numbers to the strings that represent those numbers in various bases:

	42.to_s(10)                          # => "42"
	-100.to_s(2)                         # => "-1100100"
	255.to_s(16)                         # => "ff"
	1442151747.to_s(36)                  # => "number"
Some invalid conversions:

	"6".to_i(2)                          # => 0
	"0".to_i(1)                          # ArgumentError: illegal radix 1
	40.to_s(37)                          # ArgumentError: illegal radix 37
Discussion
String#to_i can parse and Integer#to_s can create a string representation in every common integer base: from binary (the familiar base 2, which uses only the digits 0 and 1) to hexatridecimal (base 36). Hexatridecimal uses the digits 0–9 and the letters a–z; it's sometimes used to generate alphanumeric


Convert String to Binary in Ruby
As for the sake of today 11/11/11,
Everything is in binary mode.
Why not do a conversion between String and binary :)

Conversion from String to binary 
Easiest way, using unpack and tell Ruby that it is binary
"Hello".unpack("B*")
=> ["0100100001100101011011000110110001101111"]

You can specify length of each binary by replace * with total length of the word (default binary has 8 bit per character)
"Hello".unpack("B40")
=> ["0100100001100101011011000110110001101111"]

The output is in array format, removing an array can be done by adding [0] to select the first element from array.
"Hello".unpack("B*")[0]
=> "0100100001100101011011000110110001101111"

Other method is to break down the string into characters first and get ASCII number of each character, then convert them to binary.
Here is a way for breaking a String into ASCII character code.
‎"Hello".unpack("C*")
=> [72, 101, 108, 108, 111]

Then using print formatting with %b to convert each ASCII code (int) to binary
"Hello".unpack("C*").each{|c| print "%08b" % c}

Another way to do using split('')
"Hello".split('').each{|c| print "%08b" % c[0] }
=> 0100100001100101011011000110110001101111

Or you could use scan(/./)
"Hello".scan(/./).each{|c| print "%08b" % c[0] }
=> 0100100001100101011011000110110001101111

Actually there is another method for converting number into binary, it is using ".to_str(2)" but this method doesn't put leading-zeros in the result, as you can see:
"Hello".scan(/./).each{|c| print "%08s " % c[0].to_s(2) }
=> 1001000 1100101 1101100 1101100 1101111

Conversion from binary back to String
Same as above, we can use the same method to convert binary back to String 
a="0100100001100101011011000110110001101111"
[a].pack("B*")
=> "Hello"

Or split it by 8 digit each, then convert each 8 digit to int , then to character 
a="0100100001100101011011000110110001101111"
(0..a.length).step(8).each {|i| print a[i,8].to_i(2).chr}
=> Hello



P.S.
After reading .pack and .unpack function API, I found that Ruby has a built-in Base64 encoder/decoder.
To use it just use pack() or unpack() with "m" directive
Base64 Encoding 
["Hello"].pack("m*").chomp
=> "SGVsbG8="
Base64 Decoding 
"SGVsbG8=".unpack("m*")[0]
=> "Hello"
