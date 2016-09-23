# Problem D, ACM 2012 World Finals

### Fibonacci Words

The Fibonacci word sequence of bit strings is defined as

 * F(n) == 0, if n = 0
 * F(n) == 1, if n = 1
 * F(n - 1) + F(n - 2) if n >= 2

Here, the plus sign is a concatenation of strings.  The first few elements are:


 * 0 => 0
 * 1 => 1
 * 2 => 10
 * 3 => 101
 * 4 => 10110
 * 5 => 10110101 

Given a bit pattern _p_ and a number _n_, how often does _p_ occur in _F(n)_?

### Input
The first line of each test case includes the integer _n_ where 0 <= _n_ <= 100.  The second line contains the bit pattern _p_ which is nonempty and has a length of most 100,000 characters.

### Output
For each test case, we display its case number, followed by _F(n)_ and the number of occurrences of the pattern _p_.  Occurrences may overlap.

### Solving this the HOP way
We first take one of our code samples from Chapter 5, _fib1.pl_.  This is a good starting point but it is recursive, which eventually craps out in the end.  We originally bolted on a quick way to parse patterns using s///g, but this is also deficient, since the occurrences may overlap.  For example, 6 and 101 should return 4 matches, but using s///g can only pick out 3.

We were able to find a way around overlapping patterns (yay Perl!) but are now faced with the problem of too much recursion.  As it's discussed in another post, we find that our solution will still extend the in-space memory of most computers when you try to create a number higher than, say, 40.  What to do, then?

### Thank you, Internet

From another post on the internet, I was able to find a solution in Java using a KMP implementation.
