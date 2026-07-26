#!/bin/bash
exec /usr/bin/perl -x -- "$0" "$@"
exit 127
: <<'F3_R3_V3_MATERIALIZER_PERL_BODY'
#!perl
use strict;
use warnings;
use Fcntl qw(:DEFAULT :mode);
use Digest::SHA qw(sha256_hex);
use POSIX ();
use IO::Handle;
use Errno qw(ENOENT);

my $ROOT = q{/Users/MoiTam/Documents/New project/coordinated/hilo2-f3-r3-pilot-v3-run};
my $RESULT = "$ROOT/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_R3_REVERSE_BFS_PILOT_v3";
my $FRAGMENTS = "$RESULT/fragments";
my $TMP = "$RESULT/tmp";
my $TARGET = "$ROOT/CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotPayloadsV3.lean";
my $CANDIDATE = "$TMP/S0.PAYLOAD_SOURCE.candidate";

sub sync_handle {
  my ($fh, $role) = @_;
  defined($fh->sync()) or die "sync $role: $!\n";
}

sub require_absent {
  my ($path, $role) = @_;
  local $! = 0;
  my @st = lstat($path);
  @st and die "$role already exists\n";
  (0 + $!) == ENOENT or die "$role lstat failed: $!\n";
}

@ARGV == 0 or die "materializer accepts no arguments\n";
my $cwd = POSIX::getcwd();
$cwd eq $ROOT or die "wrong cwd\n";

my @names = map { sprintf q{row_%02d.canonical_fragment.lean}, $_ } 1 .. 6;
opendir(my $dh, $FRAGMENTS) or die "opendir fragments: $!\n";
my @seen = grep { $_ ne q{.} && $_ ne q{..} } readdir($dh);
closedir($dh) or die "closedir fragments: $!\n";
@seen == 6 or die "fragment count is not 6\n";
my %expected = map { $_ => 1 } @names;
my %observed;
for my $name (@seen) {
  exists $expected{$name} or die "unexpected fragment entry\n";
  !$observed{$name}++ or die "duplicate fragment entry\n";
  my $path = "$FRAGMENTS/$name";
  my @st = lstat($path);
  @st && S_ISREG($st[2]) && !S_ISLNK($st[2]) or die "noncanonical fragment\n";
}

sub slurp_regular {
  my ($path) = @_;
  my @before = lstat($path);
  @before && S_ISREG($before[2]) && !S_ISLNK($before[2]) or die "noncanonical input\n";
  sysopen(my $fh, $path, O_RDONLY | O_NOFOLLOW) or die "open input: $!\n";
  my @opened = stat($fh);
  @opened && S_ISREG($opened[2]) && $before[0] == $opened[0] &&
    $before[1] == $opened[1] && $before[2] == $opened[2] &&
    $before[7] == $opened[7] && $before[9] == $opened[9]
    or die "opened input identity mismatch\n";
  binmode($fh);
  local $/;
  my $bytes = <$fh>;
  defined $bytes or $bytes = q{};
  close($fh) or die "close input: $!\n";
  my @after = lstat($path);
  @after && S_ISREG($after[2]) && !S_ISLNK($after[2]) &&
    $before[0] == $after[0] && $before[1] == $after[1] &&
    $before[2] == $after[2] && $before[7] == $after[7] &&
    $before[9] == $after[9]
    or die "fragment changed while reading\n";
  return ($bytes, sha256_hex($bytes));
}

my @fragments;
my @hashes;
for my $name (@names) {
  my ($bytes, $hash) = slurp_regular("$FRAGMENTS/$name");
  push @fragments, $bytes;
  push @hashes, $hash;
}

my $preamble = <<'LEAN';
import CollatzClassical.KL2003.F3ReturnExcursionBlock0ReverseBFSPilotRowsV3
import CollatzClassical.KL2003.F3ReturnExcursionBlock0ReverseBFSData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

/-!
# Frozen six-row reverse-BFS pilot payload

This module is a byte-preserving S0 materialization of six independently
generated, untrusted certificate literals.  Acceptance occurs only in the
separate PilotV3 checker module.
-/

namespace CollatzClassical
namespace KL2003
namespace F3Block0ReverseBFSPilotPayloadsV3

open F3Block0ReverseBFSData
open F3Block0ReverseBFSPilotRowsV3

LEAN

my $postamble = <<'LEAN';

end F3Block0ReverseBFSPilotPayloadsV3
end KL2003
end CollatzClassical
LEAN

my $payload = $preamble . join(q{}, @fragments) . $postamble;
my $payload_hash = sha256_hex($payload);

require_absent($TARGET, q{payload target});
sysopen(my $out, $CANDIDATE, O_WRONLY | O_CREAT | O_EXCL | O_NOFOLLOW, 0600)
  or die "exclusive payload candidate: $!\n";
sysopen(my $tmp_dir, $TMP, O_RDONLY | O_DIRECTORY | O_NOFOLLOW)
  or die "open tmp dir: $!\n";
sync_handle($tmp_dir, q{tmp directory after candidate creation});
close($tmp_dir) or die "close tmp dir: $!\n";
chmod(0600, $CANDIDATE) == 1 or die "chmod candidate: $!\n";
binmode($out);
print {$out} $payload or die "write candidate: $!\n";
$out->flush() or die "flush candidate: $!\n";
sync_handle($out, q{payload candidate});
close($out) or die "close candidate: $!\n";

my ($candidate_bytes, $candidate_hash) = slurp_regular($CANDIDATE);
$candidate_bytes eq $payload && $candidate_hash eq $payload_hash
  or die "candidate readback mismatch\n";
require_absent($TARGET, q{payload target});
link($CANDIDATE, $TARGET) or die "no-replace payload link: $!\n";

my $target_dir = "$ROOT/CollatzClassical/KL2003";
sysopen(my $td, $target_dir, O_RDONLY | O_DIRECTORY | O_NOFOLLOW)
  or die "open target dir: $!\n";
sync_handle($td, q{payload target directory});
close($td) or die "close target dir: $!\n";

my ($target_bytes, $target_hash) = slurp_regular($TARGET);
$target_bytes eq $payload && $target_hash eq $candidate_hash
  or die "target readback mismatch\n";
my @candidate_st = lstat($CANDIDATE);
my @target_st = lstat($TARGET);
@candidate_st && @target_st && S_ISREG($candidate_st[2]) &&
  S_ISREG($target_st[2]) && !S_ISLNK($candidate_st[2]) &&
  !S_ISLNK($target_st[2]) && $candidate_st[0] == $target_st[0] &&
  $candidate_st[1] == $target_st[1]
  or die "payload hardlink identity mismatch\n";

for my $i (0 .. $#names) {
  my ($bytes, $hash) = slurp_regular("$FRAGMENTS/$names[$i]");
  $bytes eq $fragments[$i] && $hash eq $hashes[$i]
    or die "fragment changed after materialization\n";
}

my ($final_candidate_bytes, $final_candidate_hash) = slurp_regular($CANDIDATE);
my ($final_target_bytes, $final_target_hash) = slurp_regular($TARGET);
$final_candidate_bytes eq $payload && $final_target_bytes eq $payload &&
  $final_candidate_hash eq $payload_hash && $final_target_hash eq $payload_hash
  or die "final payload readback mismatch\n";
@candidate_st = lstat($CANDIDATE);
@target_st = lstat($TARGET);
@candidate_st && @target_st && S_ISREG($candidate_st[2]) &&
  S_ISREG($target_st[2]) && $candidate_st[0] == $target_st[0] &&
  $candidate_st[1] == $target_st[1]
  or die "final payload hardlink identity mismatch\n";

unlink($CANDIDATE) or die "unlink published candidate: $!\n";
sysopen($tmp_dir, $TMP, O_RDONLY | O_DIRECTORY | O_NOFOLLOW)
  or die "reopen tmp dir: $!\n";
sync_handle($tmp_dir, q{tmp directory after candidate cleanup});
close($tmp_dir) or die "close tmp dir: $!\n";
exit 0;
__END__
F3_R3_V3_MATERIALIZER_PERL_BODY
