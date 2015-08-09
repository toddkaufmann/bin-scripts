#!/opt/local/bin/perl
#   /usr/bin/perl
# see http://stackoverflow.com/questions/3976506/how-can-i-monitor-a-log-file-and-insert-timestamps-using-perl
# requires File::Tail
#
use File::Tail;
use DateTime;
my $ref=tie *FH,"File::Tail",(name=>$ARGV[0]);
while (<FH>) {
    my $dt = DateTime->now();
    print "[", $dt->dmy(), " ",$dt->hms(),"] $_";
}
