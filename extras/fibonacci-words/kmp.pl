#!/usr/bin/perl

my (@F, @f);

sub precomputeF {
	my $M = shift;
	$F[0] = "0";
	$F[1] = "1";
	my $i = 1;
	while ($i > 3 || length($F[$i-3]) < $M) {
		$F[$i + 1] = $F[$i] + $F[$i - 1];
		$i++;
	}
}

sub precomputef {
	my $M = shift;
	$f[0] = 1;
	$f[1] = 1;
	my $i = 1;
	while ($i < $M) {
		$f[$i + 1] = $f[$i] + $f[$i - 1];
		$i++;
	}
}

sub occurrences {
	my $n = shift;
	# the number
	my $p = shift;
	# the pattern
	if ($p eq "0") {
		if ($n < 2) {
			return $n == 0 ? 1 : 0;
		}
		return $f[$n - 2];
	}
	if ($p eq "1") {
		if ($n < 2) {
			return $n == 0 ? 0 : 1;
		}
		return $f[$n - 1];
	}
	my $m = 3;
	while ($f[$m - 3] < length($p)) {
		# should be p.length
		$m++;
	}
	if ($m > $n) {
		$m = $n;
	}
	my @res = knuth_morris_pratt($F[$m], $p);
	#print the result
	print "The resulting array is:\n";
	#print "@res";
	print "[".join("] [",@res)."] \n";
}

#computation of the prefix subroutine
sub knuth_morris_pratt_next
{
   my($P) = @_; #pattern
   use integer;
   my ( $m, $i, $j ) = ( length $P, 0, -1 );
   my @next;
   for ($next[0] = -1; $i < $m; ) {
      # Note that this while() is skipped during the first for() pass.
      while ( $j > -1 && substr( $P, $i, 1 ) ne substr( $P, $j, 1 ) ) {
         $j = $next[$j];
      }
      $i++;
      $j++;
      $next[$i] = substr( $P, $j, 1 ) eq substr( $P, $i, 1 ) ? $next[$j] : $j;
   }
   return ( $m, @next ); # Length of pattern and prefix function.
}

#matcher subroutine
sub knuth_morris_pratt
{
   my ( $T, $P ) = @_; # Text and pattern.
   use integer;
   my ($m,@next) = knuth_morris_pratt_next( $P );
   my ( $n, $i, $j ) = ( length($T), 0, 0 );
   #my @next;
   my @val;
   my $k=0;
   while ( $i < $n ) 
   {
      while ( $j > -1 && substr( $P, $j, 1 ) ne substr( $T, $i, 1 ) ) 
      {
         $j = $next[$j];
      }
      $i++;
      $j++;
      if($j>=$m)
      {
          $val[$k]= $i - $j; # Match.
          print "Match at index:".$val[$k]." \n";
      }
      else
      {
          $val[$k]=-1; # Mismatch.
      }
      $k++;
   }
   return @val; 
}

sub trim {
    my $s = shift;
    $s =~ s/^\s+|\s+$//g;
    return $s;
}

my $file = $ARGV[0];
# open the file
open my $fh, "<", $file or return;

precomputeF(100000);
precomputef(100);

my ($num, $pat);
my $line = 0;
my @data;
while (my $row = <$fh>) {
    # read numbers off the file into an array
    push @data, trim($row);
    # print "pushed " . trim($row) . "\n";
}

# print Dumper(@data);

while (@data) {
    $line++;
    $num = shift @data;
    $pat = shift @data;
    # print "shifted " . $num .  " and " . $pat . "\n";
    occurrences($num, $pat);
    # print "Case " . $line . ": " . $count . "\n";
}
