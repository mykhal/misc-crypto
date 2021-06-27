#!/usr/bin/env perl
# author: Michal Bozon (mykhal at protonmail)
no utf8;
no strict;
# use warnings;
use List::Util "min";
use MIME::Base64;

@types = qw( dsa rsa ecdsa ed25519 );

sub common_initial_substr {
  @arr = @_; $len0 = min map { length $_ } @arr;
  foreach $dlen (0..$len0) {
    my (%d, $k);
    foreach $s (@arr) {
      $k = substr $s, 0, $len0-$dlen;
      $d{ $k } = "(whatever)";  # uniq. / Py set() emulation with hash keys
    }
    return $k if (scalar keys %d) <= 1;
  }
}

foreach $t (@types) {
  for (1..10) {   # more samples for given ssh key type, ..1 for single full key
    $fn = "/tmp/.ssh-key-just-for-testing.".time.++$i;
    `ssh-keygen -t $t -N "" -f $fn` or die "ssh-keygen not available?\n";
    open F, "<", "$fn.pub";
    $line = do {local $/; <F>};
    close F; unlink glob "$fn*";
    $line =~ /(\S+)\s+(\S+)/; $ts = $1; $k = $2;
    push @{ $km{$t} }, $k;
  }

  print "$t ($ts):\n";
  $s1_0 = common_initial_substr @{ $km{$t} };
  $s1 = substr $s1_0, 0, int((length $s1_0)/4)*4; # b64 trimmed
  $s1_bin = decode_base64($s1);
  $s1_bin_s =  $s1_bin =~ s/[^ -~]/./grs;
  $s1_bin_sr =  $s1_bin_s =~ s/(...)/$1|/grs;
  $s1_bin_sx =  $s1_bin =~ s/([^ -~])/sprintf('\\x%02X',ord($1))/egrs;
  # $s1_bin_sd =  $s1_bin =~ s/([ -~]+)/"\1" /grs =~ s/([^ -~])/sprintf('%d ',ord($1))/egrs;
  print "  $s1_0\n" unless $s1_0 eq $s1;
  print "  $s1\n";
  print "  $s1_bin_sr\n";
  print "  $s1_bin_s\n";
  print "  $s1_bin_sx\n";
  # print "  $s1_bin_sd\n";
  print "\n"
}
