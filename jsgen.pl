#!/usr/bin/perl

print "from $ARGV[0] to $ARGV[1]\n";
open (IN, $ARGV[0]) or die "could not open $ARGV[0]";
open (OUT, ">$ARGV[1]") or die "could not open $ARGV[1]";
my $c = 0;
print OUT "var mysites=new Array(\"uwaterloo.ca\"";
while (<IN>) {
  chomp ($_);
  #fix that trixie monster
  if ($_ !~ /\?reactions/) {
    $_ =~ s/^www\.//;
    if ($_ !~ /\//) {
      $_ = "$_\/";
    }
    print OUT ",\"$_\"";
    $c++;
  }
}
print OUT ");\n";
close (IN);
close (OUT);
