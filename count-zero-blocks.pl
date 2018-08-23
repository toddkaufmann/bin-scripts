#!/usr/bin/perl
# $Revision: 1012 $
#
# arg1 is filename
#
# count number of all-zero blocks in file.
# checking after using
# dd if=badfile of=recovered_data conv=noerror,sync
#
# (though doesn't tell you how many there were before...
#

use strict;

my $show_numbers = 0;
if ( $ARGV[0] =~ /-n/ ) {
    $show_numbers = 1;
    shift @ARGV;
}

my $fname = $ARGV[0];

# binmode ?
open my $IMAGE, "< $fname"  || die "can't: $!";

my $length = 512;  # buffer size (match block size?)
my $buffer = "";
my $zeros = 0;    # count of how many
my $number = 0;
# block# too ?
while ( read $IMAGE, $buffer, $length ) {
  if ( $buffer =~ /^\000*$/ ) {  
      $zeros++;
      print "$number\n" if $show_numbers;
  }
  $number++;
}

print "$fname\tcontains:\t$zeros\tzero blocks.\n";
