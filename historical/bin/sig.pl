#!/usr/local/bin/perl -w
# $Id: sig.pl,v 1.1 2001/06/25 18:42:31 gjones Exp gjones $


use strict;

use vars qw($q_print $a_print);

my $quote_file = "$ENV{HOME}/.quotes";
my $sig_file = "$ENV{HOME}/.signature";

open QUOTE, "$quote_file" or
  die "Could not open quote file $quote_file: $!\n";

my @quotes = ();
my %author = ();
my $quote = undef;

my $line;
foreach $line (<QUOTE>) {
  chomp $line;
  next if $line =~ /^#/;
  if ($line =~ /^\t(.*)/){
    $author{$quote} = $1;
  } elsif ($line =~ /^\s*$/){
    $author{$quote} = "";
  } else {
    $quote = $line;
    push @quotes, $line;
  }
}

close QUOTE;

my $index = rand($#quotes);

$q_print = $quotes[$index];
$a_print = $author{$quotes[$index]};
$a_print = "" unless defined($a_print);;

write;

#        1         2         3         4         5         6         7
#23456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789
format STDOUT =
George M. Jones    |  ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                      $q_print
@<<<<<<<<<<<<<<<<  |  ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
'                  ',       $q_print
                   |  ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                      $q_print
                   |      @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                      $a_print
@<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
'gmj@port111.com'
.
