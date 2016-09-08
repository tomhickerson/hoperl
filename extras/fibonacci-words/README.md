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