#!/bin/bash
exec /usr/bin/perl -x -- "$0" "$@"
exit 127
: <<'F3_R3_V3_GUARD_PERL_BODY'
#!perl
use strict;
use warnings;
use bytes;
use Fcntl qw(:DEFAULT :flock :mode);
use POSIX qw(:sys_wait_h setsid getpgrp);
use Time::HiRes qw(clock_gettime CLOCK_MONOTONIC);
use Digest::SHA qw(sha256_hex);
use IO::Handle;
use Errno qw(EINTR ENOENT);

my $ROOT = q{/Users/MoiTam/Documents/New project/coordinated/hilo2-f3-r3-pilot-v3-run};
my $RESULT = "$ROOT/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_R3_REVERSE_BFS_PILOT_v3";
my $MEMORY = "$RESULT/memory";
my $TMP = "$RESULT/tmp";
my $LAKE = q{/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/bin/lake};
my $LEAN = q{/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/bin/lean};
my $GTIMEOUT = q{/opt/homebrew/Cellar/coreutils/9.7/bin/gtimeout};
my $TIME = q{/usr/bin/time};
my $PERL = q{/usr/bin/perl};
my $VM_STAT = q{/usr/bin/vm_stat};
my $PS = q{/bin/ps};
my $KILL = q{/bin/kill};
my $MAX_RSS_KIB = 8388608;
my $MIN_AVAILABLE_KIB = 4194304;

@ARGV == 1 or die "guard requires one phase token\n";
my $phase = $ARGV[0];
my %allowed = map { $_ => 1 } qw(B0 R0 G01 G02 G03 G04 G05 G06 V0 A0);
$allowed{$phase} or die "invalid memory phase\n";
POSIX::getcwd() eq $ROOT or die "wrong cwd\n";

my $remaining = $ENV{F3_R3_SECONDS_REMAINING};
defined($remaining) && $remaining =~ /\A[1-9][0-9]*\z/ or die "invalid remaining seconds\n";
delete $ENV{F3_R3_SECONDS_REMAINING};

sub fsync_filehandle {
  my ($fh) = @_;
  $fh->flush() or die "flush failed: $!\n";
  defined($fh->sync()) or die "sync failed: $!\n";
}

sub fsync_dir {
  my ($dir) = @_;
  sysopen(my $dh, $dir, O_RDONLY | O_DIRECTORY | O_NOFOLLOW)
    or die "open directory: $!\n";
  defined($dh->sync()) or die "directory sync: $!\n";
  close($dh) or die "close directory: $!\n";
}

sub slurp {
  my ($path) = @_;
  my @before = lstat($path);
  @before && S_ISREG($before[2]) && !S_ISLNK($before[2]) or die "noncanonical file\n";
  sysopen(my $fh, $path, O_RDONLY | O_NOFOLLOW) or die "open file: $!\n";
  my @opened = stat($fh);
  @opened && S_ISREG($opened[2]) && $before[0] == $opened[0] &&
    $before[1] == $opened[1] && $before[2] == $opened[2] &&
    $before[7] == $opened[7] && $before[9] == $opened[9]
    or die "opened file identity mismatch\n";
  binmode($fh);
  local $/;
  my $bytes = <$fh>;
  defined($bytes) or $bytes = q{};
  close($fh) or die "close file: $!\n";
  my @after = lstat($path);
  @after && S_ISREG($after[2]) && !S_ISLNK($after[2]) &&
    $before[0] == $after[0] && $before[1] == $after[1] &&
    $before[2] == $after[2] && $before[7] == $after[7] &&
    $before[9] == $after[9] or die "file changed while reading\n";
  return $bytes;
}

sub durable_candidate_open {
  my ($path) = @_;
  sysopen(my $fh, $path, O_WRONLY | O_CREAT | O_EXCL | O_NOFOLLOW, 0600)
    or die "exclusive candidate: $!\n";
  fsync_dir($TMP);
  chmod(0600, $path) == 1 or die "candidate chmod: $!\n";
  binmode($fh);
  return $fh;
}

sub publish_candidate {
  my ($candidate, $target, $expected) = @_;
  my $bytes = slurp($candidate);
  defined($expected) && $bytes ne $expected and die "candidate content mismatch\n";
  my $candidate_hash = sha256_hex($bytes);
  local $! = 0;
  my @target_before = lstat($target);
  @target_before and die "publication target exists\n";
  (0 + $!) == ENOENT or die "publication target lstat failed: $!\n";
  link($candidate, $target) or die "no-replace publication: $!\n";
  my $slash = rindex($target, q{/});
  fsync_dir(substr($target, 0, $slash));
  my $target_bytes = slurp($target);
  $target_bytes eq $bytes && sha256_hex($target_bytes) eq $candidate_hash
    or die "publication readback mismatch\n";
  my @candidate_st = lstat($candidate);
  my @target_st = lstat($target);
  @candidate_st && @target_st && S_ISREG($candidate_st[2]) &&
    S_ISREG($target_st[2]) && $candidate_st[0] == $target_st[0] &&
    $candidate_st[1] == $target_st[1]
    or die "publication hardlink identity mismatch\n";
  unlink($candidate) or die "candidate cleanup: $!\n";
  fsync_dir($TMP);
  return $candidate_hash;
}

sub utc_now {
  my @g = gmtime(time());
  return sprintf(q{%04d-%02d-%02dT%02d:%02d:%02dZ},
    $g[5] + 1900, $g[4] + 1, $g[3], $g[2], $g[1], $g[0]);
}

sub capture_command {
  my (@argv) = @_;
  open(my $fh, q{-|}, @argv) or die "command open: $!\n";
  binmode($fh);
  local $/;
  my $bytes = <$fh>;
  defined($bytes) or $bytes = q{};
  close($fh) or die "command failed\n";
  return $bytes;
}

my $vm_bytes = capture_command($VM_STAT);
my @vm_lines = split /\n/, $vm_bytes;
@vm_lines or die "vm_stat header\n";
my @page_sizes = ($vm_lines[0] =~ /page size of ([1-9][0-9]*) bytes/g);
@page_sizes == 1 or die "vm_stat page-size uniqueness\n";
my $page_size = 0 + $page_sizes[0];
my %pages;
for my $line (@vm_lines) {
  if ($line =~ /\APages (free|inactive|speculative):\s*([0-9]+)\.\z/) {
    exists $pages{$1} and die "duplicate vm_stat category\n";
    $pages{$1} = 0 + $2;
  }
}
exists($pages{free}) && exists($pages{inactive}) && exists($pages{speculative})
  or die "missing vm_stat category\n";
my $available_kib = int(($pages{free} + $pages{inactive} + $pages{speculative}) * $page_size / 1024);
$available_kib >= $MIN_AVAILABLE_KIB or die "INVALID_MEMORY_POLICY launch floor\n";

my $vm_candidate = "$TMP/$phase.MEMORY_VM_STAT.candidate";
my $members_candidate = "$TMP/$phase.MEMORY_RSS_MEMBERS.candidate";
my $summary_candidate = "$TMP/$phase.MEMORY_RSS_SUMMARY.candidate";
my $receipt_candidate = "$TMP/$phase.MEMORY_GUARD_RECEIPT.candidate";
my $vm_target = "$MEMORY/$phase.vm_stat_pre.txt";
my $members_target = "$MEMORY/$phase.rss_members.tsv";
my $summary_target = "$MEMORY/$phase.rss_summary.tsv";
my $receipt_target = "$MEMORY/$phase.guard_receipt.sha256";

my $vm_out = durable_candidate_open($vm_candidate);
print {$vm_out} $vm_bytes or die "write vm_stat evidence\n";
fsync_filehandle($vm_out);
close($vm_out) or die "close vm_stat evidence\n";
publish_candidate($vm_candidate, $vm_target, $vm_bytes);

my $members_out = durable_candidate_open($members_candidate);
my $summary_out = durable_candidate_open($summary_candidate);

my $environment_capture_program = q^
use strict;
use warnings;
use bytes;
use Fcntl qw(:DEFAULT :mode);
use Digest::SHA qw(sha256_hex);
use IO::Handle;
use Errno qw(ENOENT);
@ARGV >= 3 or die "environment capture argv\n";
my $phase = shift @ARGV;
my $target = shift @ARGV;
$phase =~ /\A(?:B0|R0|G01|G02|G03|G04|G05|G06|V0|A0)\z/ or die "phase\n";
my $slash = rindex($target,q{/});
my $result = substr($target,0,$slash);
my $tmp = "$result/tmp";
my $candidate = "$tmp/$phase.LAKE_ENVIRONMENT.candidate";
sub fsd { my($d)=@_; sysopen(my $h,$d,O_RDONLY|O_DIRECTORY|O_NOFOLLOW) or die "dir"; defined($h->sync()) or die "sync dir"; close($h) or die "close dir"; }
sub readf {
 my($p)=@_; my @b=lstat($p); @b && S_ISREG($b[2]) && !S_ISLNK($b[2]) or die "noncanonical read";
 sysopen(my $h,$p,O_RDONLY|O_NOFOLLOW) or die "read"; my @o=stat($h);
 @o && S_ISREG($o[2]) && $b[0]==$o[0] && $b[1]==$o[1] && $b[2]==$o[2] && $b[7]==$o[7] && $b[9]==$o[9] or die "read identity";
 binmode($h); local $/; my $v=<$h>; defined($v) or $v=q{}; close($h) or die "close"; my @a=lstat($p);
 @a && S_ISREG($a[2]) && !S_ISLNK($a[2]) && $b[0]==$a[0] && $b[1]==$a[1] && $b[2]==$a[2] && $b[7]==$a[7] && $b[9]==$a[9] or die "read changed"; return $v;
}
my @keys = sort { $a cmp $b } keys %ENV;
my @rows;
my $vector=q{};
for my $key (@keys) {
  index($key,"\0") < 0 && index($ENV{$key},"\0") < 0 or die "NUL environment";
  my $kh=unpack(q{H*},$key); my $vh=unpack(q{H*},$ENV{$key});
  push @rows,[$kh,$vh]; $vector .= length($key).q{:}.$key.length($ENV{$key}).q{:}.$ENV{$key};
}
my $text="F3_EVIDENCE_V2\tF3_ENVIRONMENT_V1\n";
my $i=1;
for my $m ([PHASE=>$phase],[ENTRY_COUNT=>scalar(@rows)],[VECTOR_SHA256=>sha256_hex($vector)]) { $text .= sprintf("META\t%04d\t%s\t%s\n",$i++,@$m); }
for my $r (@rows) { $text .= sprintf("ENV\t%04d\t%s\t%s\n",$i++,@$r); }
local $! = 0;
my @existing=lstat($target);
if (@existing) { readf($target) eq $text or die "environment drift"; }
else {
  (0+$!)==ENOENT or die "target lstat";
  sysopen(my $h,$candidate,O_WRONLY|O_CREAT|O_EXCL|O_NOFOLLOW,0600) or die "candidate"; fsd($tmp); chmod(0600,$candidate)==1 or die "chmod"; binmode($h); print {$h} $text or die "write"; $h->flush() or die "flush"; defined($h->sync()) or die "sync"; close($h) or die "close";
  my $cb=readf($candidate); $cb eq $text or die "candidate readback"; my $ch=sha256_hex($cb);
  local $! = 0; my @late=lstat($target); !@late && (0+$!)==ENOENT or die "late target";
  link($candidate,$target) or die "link"; fsd($result); my $tb=readf($target); $tb eq $text && sha256_hex($tb) eq $ch or die "readback";
  my @cs=lstat($candidate); my @ts=lstat($target); @cs && @ts && S_ISREG($cs[2]) && S_ISREG($ts[2]) && $cs[0]==$ts[0] && $cs[1]==$ts[1] or die "hardlink identity";
  unlink($candidate) or die "unlink"; fsd($tmp);
}
exec { $ARGV[0] } @ARGV or die "exec environment child";
^;

my $environment_capture_hex = unpack(q{H*}, $environment_capture_program);
my $sequence_program = q!
use strict;
use warnings;
use bytes;
@ARGV == 1 or die "sequence phase\n";
my $phase=$ARGV[0];
my $root=q{/Users/MoiTam/Documents/New project/coordinated/hilo2-f3-r3-pilot-v3-run};
my $result="$root/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_R3_REVERSE_BFS_PILOT_v3";
my $lake=q{/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/bin/lake};
my $lean=q{/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/bin/lean};
my $perl=q{/usr/bin/perl};
my $envcap=pack(q{H*},q{! . $environment_capture_hex . q!});
my %g=(
 G01=>q{FIXED_ROW_01_RET_D2}, G02=>q{FIXED_ROW_02_RET_D1},
 G03=>q{FIXED_ROW_03_DIRECT_D2}, G04=>q{FIXED_ROW_04_DIRECT_D1},
 G05=>q{FIXED_ROW_05_LIFT_D2}, G06=>q{FIXED_ROW_06_LIFT_D1});
my @roots;
my @build;
if ($phase eq q{B0}) {
 @build=($lake,q{build},qw(
CollatzClassical.KL2003.F3ReturnExcursionBlock0MassDemandProfileSharded
CollatzClassical.KL2003.F3ReturnExcursionBlock0MassDemandProfileShardedAxiomAudit
CollatzClassical.KL2003.F3ReturnExcursionBlock0ReverseBFSMassIntegration
CollatzClassical.KL2003.F3ReturnExcursionBlock0ReverseBFSAxiomAudit
CollatzClassical.KL2003.F3ReturnExcursionBlock0SemanticChildBaseHit
CollatzClassical.KL2003.F3ReturnExcursionBlock0SemanticChildBaseHitAxiomAudit
CollatzClassical.KL2003.F3ReturnExcursionBlock0ReverseBFSCompleteness
CollatzClassical.KL2003.F3ReturnExcursionBlock0ReverseBFSCompletenessAxiomAudit));
 @roots=qw(F3ReturnExcursionBlock0MassDemandProfileSharded F3ReturnExcursionBlock0MassDemandProfileShardedAxiomAudit F3ReturnExcursionBlock0ReverseBFSMassIntegration F3ReturnExcursionBlock0ReverseBFSAxiomAudit F3ReturnExcursionBlock0SemanticChildBaseHit F3ReturnExcursionBlock0SemanticChildBaseHitAxiomAudit F3ReturnExcursionBlock0ReverseBFSCompleteness F3ReturnExcursionBlock0ReverseBFSCompletenessAxiomAudit);
} elsif ($phase eq q{R0}) {
 @build=($lake,q{build},qw(CollatzClassical.KL2003.F3ReturnExcursionBlock0ReverseBFSPilotRowsV3 CollatzClassical.KL2003.F3ReturnExcursionBlock0ReverseBFSPilotGenerateV3));
 @roots=qw(F3ReturnExcursionBlock0ReverseBFSPilotRowsV3 F3ReturnExcursionBlock0ReverseBFSPilotGenerateV3);
} elsif ($phase eq q{V0}) {
 @build=($lake,q{build},q{CollatzClassical.KL2003.F3ReturnExcursionBlock0ReverseBFSPilotV3});
 @roots=qw(F3ReturnExcursionBlock0ReverseBFSPilotPayloadsV3 F3ReturnExcursionBlock0ReverseBFSPilotV3);
} elsif ($phase eq q{A0}) {
 @build=($lake,q{build},q{CollatzClassical.KL2003.F3ReturnExcursionBlock0ReverseBFSPilotV3AxiomAudit});
 @roots=qw(F3ReturnExcursionBlock0ReverseBFSPilotV3AxiomAudit);
} elsif (exists $g{$phase}) {
 my $envpath="$result/$phase.lake_environment.tsv";
 my @cmd=($lake,q{env},$perl,q{-e},$envcap,$phase,$envpath,$lean,q{--run},"$root/CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotGenerateV3.lean",$g{$phase});
 exec { $cmd[0] } @cmd or die "generator exec\n";
} else { die "closed sequence token\n"; }
system { $build[0] } @build;
$? == 0 or exit(($? >> 8) || 1);
my $root_index=0;
for my $name (@roots) {
 $root_index++;
 my $envpath="$result/$phase.lake_environment.tsv";
 my $source="$root/CollatzClassical/KL2003/$name.lean";
 print "@@F3_DEPS_ROOT\t".sprintf(q{%04d},$root_index)."\t".unpack(q{H*},$source)."@@\n" or die "dependency delimiter\n";
 my @cmd=($lake,q{env},$perl,q{-e},$envcap,$phase,$envpath,$lean,q{--deps},$source);
 system { $cmd[0] } @cmd;
 $? == 0 or exit(($? >> 8) || 1);
}
exit 0;
!;

my @exact_child_argv=($GTIMEOUT,q{--foreground},q{--signal=TERM},q{--kill-after=5},$remaining,$TIME,q{-p},$PERL,q{-e},$sequence_program,$phase);
my $command_frame=scalar(@exact_child_argv).q{:};
for my $arg (@exact_child_argv) { $command_frame .= length($arg).q{:}.$arg; }

sub kill_group_and_wait {
  my ($pid,$group)=@_;
  my $kill_rc=system {$KILL} $KILL,q{-KILL},"-$group";
  my $kill_ok=$kill_rc==0 ? 1 : 0;
  my ($wait_ok,$status)=(0,undef);
  while (1) {
    my $waited=waitpid($pid,0);
    if ($waited==$pid) { $status=$?; $wait_ok=1; last; }
    if ($waited<0 && (0+$!)==EINTR) { next; }
    last;
  }
  return ($wait_ok,$status,$kill_ok);
}

pipe(my $ready_r, my $ready_w) or die "ready pipe: $!\n";
pipe(my $go_r, my $go_w) or die "go pipe: $!\n";
$ready_w->autoflush(1);
$go_w->autoflush(1);
my $controller_parent=getppid();
$controller_parent>1 or die "missing controller parent\n";
my $abort_requested=q{};
$SIG{TERM}=sub { $abort_requested=q{TERM}; };
$SIG{HUP}=sub { $abort_requested=q{HUP}; };
$SIG{INT}=sub { $abort_requested=q{INT}; };
$SIG{PIPE}=sub { $abort_requested=q{PIPE}; };
my $start_utc=utc_now();
my $process_start_token=clock_gettime(CLOCK_MONOTONIC);
my $child=fork();
defined($child) or die "fork: $!\n";
if ($child==0) {
  for my $signal (qw(TERM HUP INT PIPE CHLD)) { $SIG{$signal}=q{DEFAULT}; }
  close($ready_r); close($go_w);
  my $sid=setsid();
  defined($sid) && $sid==$$ && getpgrp()==$$ or die "setsid mismatch\n";
  print {$ready_w} "READY\t$$\t".getpgrp()."\n" or die "ready write\n";
  close($ready_w) or die "ready close\n";
  my $token=q{};
  sysread($go_r,$token,1)==1 && $token eq q{G} or die "go handshake\n";
  close($go_r) or die "go close\n";
  exec { $exact_child_argv[0] } @exact_child_argv or die "sequence exec\n";
}
my $pgid=$child;
my $parent_pipe_ok=1;
close($ready_w) or $parent_pipe_ok=0;
close($go_r) or $parent_pipe_ok=0;
my $ready=q{};
my $handshake_ok=$parent_pipe_ok;
while ($handshake_ok && index($ready,"\n")<0 && length($ready)<128) {
  if (length($abort_requested) || getppid()!=$controller_parent) { $handshake_ok=0; last; }
  my $part=q{};
  my $n=sysread($ready_r,$part,128-length($ready));
  if (!defined($n)) { next if (0+$!)==EINTR; $handshake_ok=0; last; }
  if ($n==0) { $handshake_ok=0; last; }
  $ready.=$part;
}
close($ready_r) or $handshake_ok=0;
$handshake_ok=0 unless $ready eq "READY\t$child\t$child\n";
if (!$handshake_ok || length($abort_requested) || getppid()!=$controller_parent) {
  close($go_w);
  my ($wait_ok,$ignored_status,$kill_ok)=kill_group_and_wait($child,$pgid);
  $wait_ok or die "handshake cleanup failed\n";
  my $message=$kill_ok ? "invalid ready handshake\n" : "invalid ready handshake and group kill status\n";
  die $message;
}

my $sample_origin;
my $sample_index=0;
my $peak=0;
my $violation=q{NO};
my $violation_reason=q{};

sub sample_group {
  my ($elapsed,$deadline)=@_;
  return (0,undef,q{ABORT_BEFORE_SAMPLE}) if length($abort_requested);
  open(my $psh,q{-|},$PS,q{-axo},q{pid=,ppid=,pgid=,rss=})
    or return (0,undef,q{PS_OPEN});
  my %proc;
  my $parse_ok=1;
  while (my $line=<$psh>) {
    if ($line !~ /^\s*([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s*$/) { $parse_ok=0; next; }
    if (exists($proc{$1})) { $parse_ok=0; next; }
    $proc{$1}=[$2,$3,$4] if $parse_ok;
  }
  my $ps_close_ok=close($psh);
  return (0,undef,q{PS_PARSE}) unless $parse_ok && $ps_close_ok;
  return (0,undef,q{MISSING_SAMPLE})
    if defined($deadline) && clock_gettime(CLOCK_MONOTONIC)>=$deadline;
  return (0,undef,q{ROOT_MISSING}) unless exists($proc{$child});
  my %closure=($child=>1);
  my $changed=1;
  while ($changed) {
    $changed=0;
    for my $pid (keys %proc) {
      my $ppid=$proc{$pid}[0];
      if ($closure{$ppid} && !$closure{$pid}) { $closure{$pid}=1; $changed=1; }
    }
  }
  my @members=sort {$a<=>$b} grep {$proc{$_}[1]==$pgid} keys %proc;
  return (0,undef,q{GROUP_MISSING}) unless @members;
  for my $pid (keys %closure) {
    next unless exists($proc{$pid});
    return (0,undef,q{DESCENDANT_ESCAPED}) unless $proc{$pid}[1]==$pgid;
  }
  for my $pid (@members) { return (0,undef,q{FOREIGN_GROUP_MEMBER}) unless $closure{$pid}; }
  my $total=0;
  my $member_block=q{};
  for my $pid (@members) {
    my($ppid,$member_pgid,$rss)=@{$proc{$pid}};
    $total+=$rss;
    $member_block.=join("\t",$sample_index,$elapsed,$pid,$ppid,$member_pgid,$rss)."\n";
  }
  my $summary_line=join("\t",$sample_index,$elapsed,scalar(@members),$total)."\n";
  print {$members_out} $member_block or return (0,undef,q{MEMBERS_WRITE});
  print {$summary_out} $summary_line or return (0,undef,q{SUMMARY_WRITE});
  $peak=$total if $total>$peak;
  $sample_index++;
  return (1,$total,q{PASS});
}

my ($sample_ok,$first_total,$sample_reason)=sample_group(0,undef);
if (!$sample_ok) { $violation=q{YES}; $violation_reason=$sample_reason; }
elsif ($first_total>$MAX_RSS_KIB) { $violation=q{YES}; $violation_reason=q{RSS_LIMIT}; }
elsif (length($abort_requested) || getppid()!=$controller_parent) { $violation=q{YES}; $violation_reason=q{CONTROLLER_LOSS}; }
if ($violation eq q{NO}) {
  $sample_origin=clock_gettime(CLOCK_MONOTONIC);
  print {$go_w} q{G} or do { $violation=q{YES}; $violation_reason=q{GO_WRITE}; };
}
close($go_w) or do { $violation=q{YES}; $violation_reason=q{GO_CLOSE}; };

my $status;
my $elapsed=0;
if ($violation eq q{YES}) {
  my ($wait_ok,$killed_status,$kill_ok)=kill_group_and_wait($child,$pgid);
  $wait_ok or die "initial violation cleanup failed\n";
  $status=$killed_status;
  $violation_reason=q{GROUP_KILL_STATUS} unless $kill_ok;
}
while (!defined($status)) {
  if (length($abort_requested)) { $violation=q{YES}; $violation_reason=q{SUPERVISOR_SIGNAL}; }
  if (getppid()!=$controller_parent) { $violation=q{YES}; $violation_reason=q{CONTROLLER_LOSS}; }
  if ($violation eq q{YES}) {
    my ($wait_ok,$killed_status,$kill_ok)=kill_group_and_wait($child,$pgid);
    $wait_ok or die "runtime violation cleanup failed\n";
    $status=$killed_status;
    $violation_reason=q{GROUP_KILL_STATUS} unless $kill_ok;
    last;
  }
  my $target=$sample_origin+$elapsed+1;
  while (clock_gettime(CLOCK_MONOTONIC)<$target) {
    last if length($abort_requested) || getppid()!=$controller_parent;
    my $now=clock_gettime(CLOCK_MONOTONIC);
    my $pause=$target-$now;
    $pause=0.1 if $pause>0.1;
    select(undef,undef,undef,$pause) if $pause>0;
  }
  if (length($abort_requested) || getppid()!=$controller_parent) {
    $violation=q{YES}; $violation_reason=length($abort_requested) ? q{SUPERVISOR_SIGNAL} : q{CONTROLLER_LOSS};
    next;
  }
  if (clock_gettime(CLOCK_MONOTONIC)>=$target+1) {
    $violation=q{YES}; $violation_reason=q{MISSING_SAMPLE};
    next;
  }
  $elapsed++;
  my ($ok,$total,$reason)=sample_group($elapsed,$target+1);
  if (length($abort_requested) || getppid()!=$controller_parent) {
    $violation=q{YES}; $violation_reason=length($abort_requested) ? q{SUPERVISOR_SIGNAL} : q{CONTROLLER_LOSS};
  }
  elsif (!$ok) { $violation=q{YES}; $violation_reason=$reason; }
  elsif ($total>$MAX_RSS_KIB) { $violation=q{YES}; $violation_reason=q{RSS_LIMIT}; }
  if ($violation eq q{YES}) { next; }
  my $waited=waitpid($child,WNOHANG);
  if ($waited==$child) {
    $status=$?;
    if (length($abort_requested) || getppid()!=$controller_parent) {
      $violation=q{YES};
      $violation_reason=length($abort_requested) ? q{SUPERVISOR_SIGNAL} : q{CONTROLLER_LOSS};
    }
    last;
  }
  if ($waited<0) {
    next if (0+$!)==EINTR;
    $violation=q{YES}; $violation_reason=q{WAITPID_ERROR};
  }
}
defined($status) or die "missing phase status\n";
if (length($abort_requested) || getppid()!=$controller_parent) {
  $violation=q{YES};
  $violation_reason=length($abort_requested) ? q{SUPERVISOR_SIGNAL} : q{CONTROLLER_LOSS};
}
for my $signal (qw(TERM HUP INT PIPE)) { $SIG{$signal}=q{DEFAULT}; }
my $exit_status=($status&127) ? 128+($status&127) : ($status>>8);
my $end_utc=utc_now();

fsync_filehandle($members_out); close($members_out) or die "members close\n";
fsync_filehandle($summary_out); close($summary_out) or die "summary close\n";
publish_candidate($members_candidate,$members_target);
publish_candidate($summary_candidate,$summary_target);

my @meta=(
 [PHASE=>$phase],[ATTEMPT=>1],[ROOT_PID=>$child],[PROCESS_START_TOKEN=>sprintf(q{%.9f},$process_start_token)],
 [PGID=>$pgid],[AVAILABLE_KIB=>$available_kib],[MIN_AVAILABLE_KIB=>$MIN_AVAILABLE_KIB],
 [MAX_SAMPLED_RSS_KIB=>$MAX_RSS_KIB],[SAMPLE_PERIOD_SECONDS=>1],[PEAK_SAMPLED_RSS_KIB=>$peak],
 [EXIT_STATUS=>$exit_status],[MEMORY_VIOLATION=>$violation],[EXACT_CHILD_ARGV_SHA256=>sha256_hex($command_frame)],
 [START_UTC=>$start_utc],[END_UTC=>$end_utc]);
my $receipt="F3_EVIDENCE_V2\tF3_GUARD_RECEIPT_V1\n";
my $idx=1;
for my $m (@meta) { $receipt .= sprintf("META\t%04d\t%s\t%s\n",$idx++,@$m); }
for my $path ($vm_target,$members_target,$summary_target) { my $b=slurp($path); $receipt .= sprintf("FILE\t%04d\t%s\t%d\t%s\n",$idx++,sha256_hex($b),length($b),substr($path,length($ROOT)+1)); }
my $receipt_out=durable_candidate_open($receipt_candidate);
print {$receipt_out} $receipt or die "receipt write\n";
fsync_filehandle($receipt_out); close($receipt_out) or die "receipt close\n";
publish_candidate($receipt_candidate,$receipt_target,$receipt);

exit($violation eq q{YES} ? 125 : $exit_status);
__END__
F3_R3_V3_GUARD_PERL_BODY
