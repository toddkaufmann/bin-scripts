#!/usr/bin/perl

use strict;
use utf8;
use Getopt::Long;


my $before;         # if set, only print before string
my $context = 40;   # number chars
my $delim   = '  '; # output delim
my $match;          # print match ?

GetOptions ( "context=i" => \$context,   # number chars
	     'delim=s'   => \$delim, # delim - instead of 
	     # "fname"
	     # lineno
	     "before:s" =>  \$before,    # regex for printing 'before'
	     "match"    =>  \$match,
	     # after
);
my $regex = shift(@ARGV);

#print "context = $context,  before = $before\n";
#print "regex   = $regex\n";
#exit 0;


my $default_print = 1;
# unless...
if ( $before ne '' ) {
  $default_print = 0;
}


while (<>) {
  chomp;
  while ( $_ =~ m/$regex/g ) {
    # my ($b, $m, $a) = ($`,$_,$');
    # $_ is still the 'line'
    my ($b, $m, $a) = ($`,$&,$');
my $cap = $1;
    my $bs = substr(" " x $context . $b, -$context          );
    my $as = substr($a . " " x $context,         0, $context);
    #printf( "%4d: %s  [%d]\n", $., $bs . "  $m  " . $as,  pos() );
    # format for emacs M-x grep
    if ( $default_print ) {
      printf( "$ARGV:%d: %s  [%d] $cap\n", $., join( $delim, $bs , $m, $as),  pos() );
    } else {
      special_print( $b, $m, $a );
    }
  }

}
exit 0;

sub special_print {
  my ( $b, $m, $a ) = @_;
  my @print_parts = ();
  # file
  # lineno
  if ( $before ne '' ) {
    # 
    $b =~ /($before)$/;
    push(@print_parts, $1);
  }
  if ( $match ne '' ) {
    push(@print_parts, $m);
  }
  print join($delim, @print_parts) . "\n";
  
}


__END__

# alternatives / pitfalls:

while (<>) {
  chomp;
# 
# we could find all the surrounding pieces like this:
#  @pieces = split(/$regex/);
# but then we lose the exact match (if it's a regex)
#

# FOR loop iterating:
#   for $match ( m/$regex/g ) { ... }
# note everything is matched at this point--the m/$regex/g statement returns a list,
# so this is same as
#   @matches = m/$regex/g;
#   for $match ( @matches ) { ... }
# so there is no match state

#  for $match ( m/(.*)($regex)(.*)/g ) {  

  for $match ( m/$regex/g ) {
#    my ($b, $m, $a) = ($`,$1,$');
#    my ($b, $m, $a) = ($`,$&,$');
    my ($b, $m, $a) = ($`,$_,$');
    $bs = substr(" " x $context . $b, -$context          );
    $as = substr($a . " " x $context,         0, $context);
    printf( "%4d: %s  [%d]\n", $., $bs . "  $m  " . $as,  pos() );
  }

}
