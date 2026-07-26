#!/usr/bin/env -S -i HOME=/Users/MoiTam ELAN_HOME=/Users/MoiTam/.elan PATH=/Users/MoiTam/.elan/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin LC_ALL=C LANG=C /bin/bash --noprofile --norc
set -euo pipefail

if [[ $# -ne 1 ]]; then
  /usr/bin/printf '%s\n' 'usage: f3_r3_reverse_bfs_pilot_v3_executor.sh B0|R0|P0|G01|G02|G03|G04|G05|G06|S0|P1|V0|A0|F0|C0' >&2
  exit 2
fi

readonly phase="$1"
case "$phase" in
  B0|V0|A0) readonly ceiling=3600 ;;
  R0|P0|S0|P1|F0|C0) readonly ceiling=600 ;;
  G01|G02|G03|G04|G05|G06) readonly ceiling=300 ;;
  *) /usr/bin/printf '%s\n' 'invalid phase token' >&2; exit 2 ;;
esac

readonly run_root='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3-r3-pilot-v3-run'
readonly tmp_root="$run_root/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_R3_REVERSE_BFS_PILOT_v3/tmp"
[[ "$PWD" == "$run_root" ]] || { /usr/bin/printf '%s\n' 'invalid execution cwd' >&2; exit 2; }
export TMPDIR="$tmp_root"

CONTROLLER_PROGRAM_V1=''
IFS= read -r -d '' CONTROLLER_PROGRAM_V1 <<'F3_CONTROLLER_PROGRAM_V1' || [[ -n "$CONTROLLER_PROGRAM_V1" ]]
use strict;
use warnings;
use bytes;
use Fcntl qw(:DEFAULT :flock :mode F_GETFD F_SETFD FD_CLOEXEC);
use Digest::SHA qw(sha256_hex);
use POSIX ();
use Time::HiRes qw(clock_gettime CLOCK_MONOTONIC);
use IO::Handle;
use Errno qw(ENOENT EINTR);

my $ROOT=q{/Users/MoiTam/Documents/New project/coordinated/hilo2-f3-r3-pilot-v3-run};
my $OUT="$ROOT/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2";
my $RESULT="$OUT/results/F3_R3_REVERSE_BFS_PILOT_v3";
my $TMP="$RESULT/tmp";
my $CONTROL="$RESULT/control";
my $LEASES="$RESULT/leases";
my $MEMORY="$RESULT/memory";
my $FRAGMENTS="$RESULT/fragments";
my $SCRIPT_DIR="$OUT/scripts";
my $EXECUTOR="$SCRIPT_DIR/f3_r3_reverse_bfs_pilot_v3_executor.sh";
my $GUARD="$SCRIPT_DIR/f3_r3_reverse_bfs_pilot_v3_memory_guard.sh";
my $MATERIALIZER="$SCRIPT_DIR/f3_r3_reverse_bfs_pilot_v3_materialize.sh";
my $GTIMEOUT=q{/opt/homebrew/Cellar/coreutils/9.7/bin/gtimeout};
my $PERL=q{/usr/bin/perl};
my $BASH=q{/bin/bash};
my $LAKE=q{/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/bin/lake};
my $LEAN=q{/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/bin/lean};
my $TIME=q{/usr/bin/time};
my $VM_STAT=q{/usr/bin/vm_stat};
my $SLEEP=q{/bin/sleep};
my $GIT=q{/usr/bin/git};
my $SHASUM=q{/usr/bin/shasum};
my $STAT=q{/usr/bin/stat};
my $DATE=q{/bin/date};
my $PS=q{/bin/ps};
my $KILL=q{/bin/kill};
my $FIND=q{/usr/bin/find};
my $LN=q{/bin/ln};
my $RM=q{/bin/rm};
my $MKDIR=q{/bin/mkdir};
my $AWK=q{/usr/bin/awk};
my $ENV=q{/usr/bin/env};
my $PRINTF=q{/usr/bin/printf};
my $PAYLOAD="$ROOT/CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotPayloadsV3.lean";
my $NORMAL_TEMPLATE="$OUT/templates/F3_R3_REVERSE_BFS_PILOT_V3_RUN_REPORT.template.md";
my $INVALID_TEMPLATE="$OUT/templates/INVALID_R3_REVERSE_BFS_PILOT_V3_RUN_REPORT.template.md";
my $AUTH="$OUT/F3_R3_V3_EXACT_SEVEN_INPUT_AUTHORING_ROOT_AUTHORIZATION_v1.md";
my $CONTRACT_V6="$OUT/F3_R3_REVERSE_BFS_PILOT_CONTRACT_v6.md";
my $REGISTRY_V10="$OUT/F3_R3_EXECUTION_REGISTRY_v10.md";

@ARGV==1 or die "controller phase arity\n";
my $phase=$ARGV[0];
my @normal=qw(B0 R0 P0 G01 G02 G03 G04 G05 G06 S0 P1 V0 A0 F0);
my %normal_index; @normal_index{@normal}=(0..$#normal);
my %ceiling=(B0=>3600,R0=>600,P0=>600,G01=>300,G02=>300,G03=>300,G04=>300,G05=>300,G06=>300,S0=>600,P1=>600,V0=>3600,A0=>3600,F0=>600,C0=>600);
exists($ceiling{$phase}) or die "closed phase grammar\n";
POSIX::getcwd() eq $ROOT or die "controller cwd\n";
my $deadline=clock_gettime(CLOCK_MONOTONIC)+$ceiling{$phase};
my $start_utc=scalar(gmtime()).q{Z};
my($frozen_git_head,$frozen_git_branch,$live_git_head,$live_git_branch,$c0_run_input_error);
my @generated_source_baseline_files;
my(%command_object_paths,%command_object_roles);
my $command_table_loaded=0;
my @frozen_preexisting_build_files;
my @frozen_build_prestate;

my %pred=(
 B0=>[], R0=>[qw(B0)], P0=>[qw(B0 R0)],
 G01=>[qw(P0)], G02=>[qw(P0 G01)], G03=>[qw(P0 G01 G02)],
 G04=>[qw(P0 G01 G02 G03)], G05=>[qw(P0 G01 G02 G03 G04)],
 G06=>[qw(P0 G01 G02 G03 G04 G05)],
 S0=>[qw(P0 G01 G02 G03 G04 G05 G06)],
 P1=>[qw(P0 G01 G02 G03 G04 G05 G06 S0)],
 V0=>[qw(B0 R0 P0 G01 G02 G03 G04 G05 G06 S0 P1)],
 A0=>[qw(B0 R0 P0 G01 G02 G03 G04 G05 G06 S0 P1 V0)],
 F0=>[qw(B0 R0 P0 G01 G02 G03 G04 G05 G06 S0 P1 V0 A0)]);

my %terminal=(
 B0=>q{B0_terminal_receipt.sha256}, R0=>q{R0_terminal_receipt.sha256},
 P0=>q{P0_terminal_receipt.sha256}, G01=>q{G01_terminal_receipt.sha256},
 G02=>q{G02_terminal_receipt.sha256}, G03=>q{G03_terminal_receipt.sha256},
 G04=>q{G04_terminal_receipt.sha256}, G05=>q{G05_terminal_receipt.sha256},
 G06=>q{G06_terminal_receipt.sha256}, S0=>q{S0_terminal_receipt.sha256},
 P1=>q{P1_terminal_receipt.sha256}, V0=>q{V0_verification_receipt.sha256},
 A0=>q{A0_audit_receipt.sha256}, F0=>q{F0_terminal_receipt.sha256});

my %phase_paths=(
 B0=>[qw(B0.inputs.sha256 B0.raw.stdout B0.raw.stderr B0.exit_status B0.resource_receipt.tsv B0.lake_environment.tsv B0.dependencies.raw B0.loaded_objects.tsv B0.lake_delta.tsv memory/B0.vm_stat_pre.txt memory/B0.rss_members.tsv memory/B0.rss_summary.tsv memory/B0.guard_receipt.sha256 B0.outputs.sha256 B0_terminal_receipt.sha256)],
 R0=>[qw(R0.inputs.sha256 R0.raw.stdout R0.raw.stderr R0.exit_status R0.resource_receipt.tsv R0.lake_environment.tsv R0.dependencies.raw R0.loaded_objects.tsv R0.lake_delta.tsv memory/R0.vm_stat_pre.txt memory/R0.rss_members.tsv memory/R0.rss_summary.tsv memory/R0.guard_receipt.sha256 R0.outputs.sha256 R0_terminal_receipt.sha256)],
 P0=>[qw(P0.inputs.sha256 P0.raw.stdout P0.raw.stderr P0.exit_status pre_generation_manifest.sha256 pre_generation_environment.txt pre_generation_commands.txt pre_generation_loaded_objects.txt pre_generation_status.txt P0.outputs.sha256 P0_terminal_receipt.sha256)],
 G01=>[qw(G01.inputs.sha256 row_01.raw.stdout row_01.raw.stderr row_01.exit_status row_01.resource_receipt G01.lake_environment.tsv fragments/row_01.canonical_fragment.lean memory/G01.vm_stat_pre.txt memory/G01.rss_members.tsv memory/G01.rss_summary.tsv memory/G01.guard_receipt.sha256 G01.outputs.sha256 G01_terminal_receipt.sha256)],
 G02=>[qw(G02.inputs.sha256 row_02.raw.stdout row_02.raw.stderr row_02.exit_status row_02.resource_receipt G02.lake_environment.tsv fragments/row_02.canonical_fragment.lean memory/G02.vm_stat_pre.txt memory/G02.rss_members.tsv memory/G02.rss_summary.tsv memory/G02.guard_receipt.sha256 G02.outputs.sha256 G02_terminal_receipt.sha256)],
 G03=>[qw(G03.inputs.sha256 row_03.raw.stdout row_03.raw.stderr row_03.exit_status row_03.resource_receipt G03.lake_environment.tsv fragments/row_03.canonical_fragment.lean memory/G03.vm_stat_pre.txt memory/G03.rss_members.tsv memory/G03.rss_summary.tsv memory/G03.guard_receipt.sha256 G03.outputs.sha256 G03_terminal_receipt.sha256)],
 G04=>[qw(G04.inputs.sha256 row_04.raw.stdout row_04.raw.stderr row_04.exit_status row_04.resource_receipt G04.lake_environment.tsv fragments/row_04.canonical_fragment.lean memory/G04.vm_stat_pre.txt memory/G04.rss_members.tsv memory/G04.rss_summary.tsv memory/G04.guard_receipt.sha256 G04.outputs.sha256 G04_terminal_receipt.sha256)],
 G05=>[qw(G05.inputs.sha256 row_05.raw.stdout row_05.raw.stderr row_05.exit_status row_05.resource_receipt G05.lake_environment.tsv fragments/row_05.canonical_fragment.lean memory/G05.vm_stat_pre.txt memory/G05.rss_members.tsv memory/G05.rss_summary.tsv memory/G05.guard_receipt.sha256 G05.outputs.sha256 G05_terminal_receipt.sha256)],
 G06=>[qw(G06.inputs.sha256 row_06.raw.stdout row_06.raw.stderr row_06.exit_status row_06.resource_receipt G06.lake_environment.tsv fragments/row_06.canonical_fragment.lean memory/G06.vm_stat_pre.txt memory/G06.rss_members.tsv memory/G06.rss_summary.tsv memory/G06.guard_receipt.sha256 G06.outputs.sha256 G06_terminal_receipt.sha256)],
 S0=>[qw(S0.inputs.sha256 S0.raw.stdout S0.raw.stderr S0.exit_status S0.outputs.sha256 S0_terminal_receipt.sha256)],
 P1=>[qw(P1.inputs.sha256 P1.raw.stdout P1.raw.stderr P1.exit_status post_generation_manifest.sha256 P1.outputs.sha256 P1_terminal_receipt.sha256)],
 V0=>[qw(V0.inputs.sha256 V0.raw.stdout V0.raw.stderr V0.exit_status V0.resource_receipt.tsv V0.lake_environment.tsv V0.dependencies.raw V0.loaded_objects.tsv V0.lake_delta.tsv V0.checker_coverage.tsv memory/V0.vm_stat_pre.txt memory/V0.rss_members.tsv memory/V0.rss_summary.tsv memory/V0.guard_receipt.sha256 V0.outputs.sha256 V0_verification_receipt.sha256)],
 A0=>[qw(A0.inputs.sha256 A0.raw.stdout A0.raw.stderr A0.exit_status A0.resource_receipt.tsv A0.lake_environment.tsv A0.dependencies.raw A0.loaded_objects.tsv A0.lake_delta.tsv A0.public_declarations.tsv A0.axiom_profiles.tsv memory/A0.vm_stat_pre.txt memory/A0.rss_members.tsv memory/A0.rss_summary.tsv memory/A0.guard_receipt.sha256 A0.outputs.sha256 A0_audit_receipt.sha256)],
 F0=>[qw(F0.inputs.sha256 F0.raw.stdout F0.raw.stderr F0.exit_status final_artifacts.sha256 F0.outputs.sha256 F0_terminal_receipt.sha256 F3_R3_REVERSE_BFS_PILOT_V3_RUN_REPORT.md F0_report_custody_receipt.sha256)]);

my @b0_modules=qw(
CollatzClassical.KL2003.F3ReturnExcursionAdvancedDisjointness
CollatzClassical.KL2003.F3ReturnExcursionBlock0ActiveCarrier
CollatzClassical.KL2003.F3ReturnExcursionBlock0ActiveChannelIntervals
CollatzClassical.KL2003.F3ReturnExcursionBlock0ActiveSourceFiberCards
CollatzClassical.KL2003.F3ReturnExcursionBlock0ActiveWeight
CollatzClassical.KL2003.F3ReturnExcursionBlock0Carrier
CollatzClassical.KL2003.F3ReturnExcursionBlock0CarrierFiberCards
CollatzClassical.KL2003.F3ReturnExcursionBlock0CarrierFibers
CollatzClassical.KL2003.F3ReturnExcursionBlock0CarrierStateCards
CollatzClassical.KL2003.F3ReturnExcursionBlock0FormulaFiberCards
CollatzClassical.KL2003.F3ReturnExcursionBlock0MassAtoms
CollatzClassical.KL2003.F3ReturnExcursionBlock0MassDemandDirectShard
CollatzClassical.KL2003.F3ReturnExcursionBlock0MassDemandLiftShard
CollatzClassical.KL2003.F3ReturnExcursionBlock0MassDemandProfileCore
CollatzClassical.KL2003.F3ReturnExcursionBlock0MassDemandProfileSharded
CollatzClassical.KL2003.F3ReturnExcursionBlock0MassDemandProfileShardedAxiomAudit
CollatzClassical.KL2003.F3ReturnExcursionBlock0MassDemandRetardedShard
CollatzClassical.KL2003.F3ReturnExcursionBlock0OccurrenceCards
CollatzClassical.KL2003.F3ReturnExcursionBlock0OccurrenceNumericTotal
CollatzClassical.KL2003.F3ReturnExcursionBlock0OccurrenceSigmaCards
CollatzClassical.KL2003.F3ReturnExcursionBlock0OccurrenceTotal
CollatzClassical.KL2003.F3ReturnExcursionBlock0OccurrenceTripleWeights
CollatzClassical.KL2003.F3ReturnExcursionBlock0OrderedFirstHit
CollatzClassical.KL2003.F3ReturnExcursionBlock0OrderedFirstHitBool
CollatzClassical.KL2003.F3ReturnExcursionBlock0ReverseBFSAxiomAudit
CollatzClassical.KL2003.F3ReturnExcursionBlock0ReverseBFSCompleteness
CollatzClassical.KL2003.F3ReturnExcursionBlock0ReverseBFSCompletenessAxiomAudit
CollatzClassical.KL2003.F3ReturnExcursionBlock0ReverseBFSData
CollatzClassical.KL2003.F3ReturnExcursionBlock0ReverseBFSMassIntegration
CollatzClassical.KL2003.F3ReturnExcursionBlock0ReverseBFSVerifier
CollatzClassical.KL2003.F3ReturnExcursionBlock0ReversePredecessor
CollatzClassical.KL2003.F3ReturnExcursionBlock0SemanticChildBaseHit
CollatzClassical.KL2003.F3ReturnExcursionBlock0SemanticChildBaseHitAxiomAudit
CollatzClassical.KL2003.F3ReturnExcursionChannelBounds
CollatzClassical.KL2003.F3ReturnExcursionCoreArithmeticCodecFullBlockDecoder
CollatzClassical.KL2003.F3ReturnExcursionCoreArithmeticCodecFullCoreIdentity
CollatzClassical.KL2003.F3ReturnExcursionCoreArithmeticCodecPilotRepair
CollatzClassical.KL2003.F3ReturnExcursionExactCoreMatrix
CollatzClassical.KL2003.F3ReturnExcursionExactCoreMatrixChannelBounds
CollatzClassical.KL2003.F3ReturnExcursionFirstHitFibers
CollatzClassical.KL2003.F3ReturnExcursionForwardFormulaRightCertificate
CollatzClassical.KL2003.F3ReturnExcursionM0ACertificate
CollatzClassical.KL2003.F3ReturnExcursionRealOperatorBridge
CollatzClassical.KL2003.F3ReturnExcursionSemanticBridge
CollatzClassical.KL2003.KL2003ConcretePhiRealization
CollatzClassical.KL2003.KL2003K2AlphaBounds
CollatzClassical.KL2003.KL2003K2CertificateData
CollatzClassical.KL2003.KL2003K2CertificateVerifier
CollatzClassical.KL2003.KL2003K2TranscendentalEndpoints
CollatzClassical.KL2003.KL2003M0APiStarSemantics
CollatzClassical.KL2003.KL2003M0BD123CoreInstantiations
CollatzClassical.KL2003.KL2003M0BEntryPredecessorDisjointness
CollatzClassical.KL2003.KL2003M0BReachabilityAPI
CollatzClassical.KL2003.KL2003M0BTwoBranchCore
CollatzClassical.KL2003.KL2003M0CRetardedInduction
CollatzClassical.KL2003.KL2003M1Surrogate
CollatzClassical.KL2003.KL2003RootCountUnitBase);

my @seven_inputs=(
 q{CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotRowsV3.lean},
 q{CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotGenerateV3.lean},
 q{CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotV3.lean},
 q{CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotV3AxiomAudit.lean},
 rel($EXECUTOR),rel($GUARD),rel($MATERIALIZER));
my @tools=($BASH,$LAKE,$LEAN,$ENV,$GTIMEOUT,$TIME,$PERL,$VM_STAT,$PS,$KILL,
 $SLEEP,$FIND,$LN,$RM,$MKDIR,$SHASUM,$STAT,$DATE,$GIT,$AWK,$PRINTF);
my @contracts=map {rel("$OUT/F3_R3_REVERSE_BFS_PILOT_CONTRACT_v$_.md")} 1..6;
my @run_inputs=map {rel("$RESULT/$_")} qw(F3_R3_V3_FROZEN_RUN_INPUT_MANIFEST.sha256 F3_R3_V3_BASE_ENVIRONMENT.tsv F3_R3_V3_COMMAND_TABLE.tsv);
my @new_modules=qw(
 CollatzClassical.KL2003.F3ReturnExcursionBlock0ReverseBFSPilotRowsV3
 CollatzClassical.KL2003.F3ReturnExcursionBlock0ReverseBFSPilotGenerateV3
 CollatzClassical.KL2003.F3ReturnExcursionBlock0ReverseBFSPilotPayloadsV3
 CollatzClassical.KL2003.F3ReturnExcursionBlock0ReverseBFSPilotV3
 CollatzClassical.KL2003.F3ReturnExcursionBlock0ReverseBFSPilotV3AxiomAudit);

sub abs_path { my($p)=@_; return index($p,q{/})==0?$p:"$ROOT/$p"; }
sub rel { my($p)=@_; return index($p,"$ROOT/")==0?substr($p,length($ROOT)+1):$p; }
sub no_entry { my($p)=@_; my @s=lstat($p); return !@s && $! == ENOENT; }
sub sync_handle { my($h)=@_; defined($h->sync()) or die "sync handle\n"; }
sub sync_file { my($h)=@_; $h->flush() or die "flush file\n"; sync_handle($h); }
sub sync_dir { my($d)=@_; sysopen(my $h,$d,O_RDONLY|O_DIRECTORY|O_NOFOLLOW) or die "open directory $d\n"; sync_handle($h); close($h) or die "close directory $d\n"; }
sub require_dir {
 my($d)=@_; my @parts=split m{/},$d; my $cur=q{};
 for my $part (@parts){next if $part eq q{};$cur.=q{/}.$part;my @s=lstat($cur);@s&&S_ISDIR($s[2])&&!S_ISLNK($s[2]) or die "noncanonical ancestry $cur\n";}
}
sub inspect_path {
 my($p)=@_; my @a=lstat($p);
 return {state=>q{ABSENT}} if !@a && $! == ENOENT;
 return {state=>q{NONCANONICAL},kind=>q{STAT_ERROR},mode=>q{-},detail=>sha256_hex("lstat:$p:$!")} unless @a;
 my $mode=sprintf(q{%04o},$a[2]&07777);
 my $kind=S_ISLNK($a[2])?q{SYMLINK}:S_ISDIR($a[2])?q{DIRECTORY}:S_ISFIFO($a[2])?q{FIFO}:S_ISSOCK($a[2])?q{SOCKET}:S_ISCHR($a[2])||S_ISBLK($a[2])?q{DEVICE}:q{OTHER};
 return {state=>q{NONCANONICAL},kind=>$kind,mode=>$mode,detail=>sha256_hex(join(q{:},$p,@a))} unless S_ISREG($a[2])&&!S_ISLNK($a[2]);
 unless(sysopen(my $h,$p,O_RDONLY|O_NOFOLLOW)){return {state=>q{NONCANONICAL},kind=>q{UNREADABLE},mode=>$mode,detail=>sha256_hex("open:$p:$!")};}
 binmode($h);my @f0=stat($h);unless(@f0&&S_ISREG($f0[2])&&$a[0]==$f0[0]&&$a[1]==$f0[1]&&($a[2]&0177777)==($f0[2]&0177777)&&$a[7]==$f0[7]&&$a[9]==$f0[9]){close($h);return {state=>q{NONCANONICAL},kind=>q{CHANGED},mode=>$mode,detail=>sha256_hex("open-stat:$p")};}
 my $b=q{};while(length($b)<$f0[7]){my $chunk=q{};my $n=sysread($h,$chunk,$f0[7]-length($b));unless(defined($n)&&$n>0){close($h);return {state=>q{NONCANONICAL},kind=>q{UNREADABLE},mode=>$mode,detail=>sha256_hex("short-read:$p")};}$b.=$chunk;}
 my $extra=q{};my $extra_n=sysread($h,$extra,1);unless(defined($extra_n)&&$extra_n==0){close($h);return {state=>q{NONCANONICAL},kind=>q{CHANGED},mode=>$mode,detail=>sha256_hex("long-read:$p")};}
 my @f1=stat($h);my $closed=close($h);my @z=lstat($p);
 unless($closed&&@f1&&@z&&S_ISREG($f1[2])&&!S_ISLNK($z[2])&&$a[0]==$f1[0]&&$a[1]==$f1[1]&&$a[0]==$z[0]&&$a[1]==$z[1]&&($a[2]&0177777)==($f1[2]&0177777)&&($a[2]&0177777)==($z[2]&0177777)&&$a[7]==length($b)&&$a[7]==$f1[7]&&$a[7]==$z[7]&&$a[9]==$f1[9]&&$a[9]==$z[9]){return {state=>q{NONCANONICAL},kind=>q{CHANGED},mode=>$mode,detail=>sha256_hex("changed:$p")};}
 return {state=>q{FILE},sha=>sha256_hex($b),bytes=>length($b),data=>$b,mode=>$mode,mtime=>$a[9],inode=>join(q{:},$a[0],$a[1])};
}
sub slurp {my $s=inspect_path($_[0]);$s->{state} eq q{FILE} or die "required regular file $_[0]\n";return $s->{data};}
sub sha_file {return sha256_hex(slurp($_[0]));}
sub state_row {
 my($i,$p,$want)=@_;my $a=abs_path($p);my $s=inspect_path($a);
 if($want eq q{FILE}){$s->{state} eq q{FILE} or die "required FILE $p\n";}
 elsif($want eq q{ABSENT}){$s->{state} eq q{ABSENT} or die "required ABSENT $p\n";}
 elsif($want ne q{CENSUS}){die "unknown state expectation\n";}
 return sprintf("FILE\t%04d\t%s\t%d\t%s\n",$i,$s->{sha},$s->{bytes},rel($a)) if $s->{state} eq q{FILE};
 return sprintf("ABSENT\t%04d\t%s\n",$i,rel($a)) if $s->{state} eq q{ABSENT};
 return sprintf("NONCANONICAL\t%04d\t%s\t%s\t%s\t%s\n",$i,$s->{kind},$s->{mode},$s->{detail},rel($a));
}
sub rows_for_specs {my($specs,$start)=@_;my $t=q{};my $i=$start;for my $s(@$specs){$t.=state_row($i++,$s->[0],$s->[1]);}return($t,$i);}
sub typed_evidence {
 my($type,$meta,$specs,$tail)=@_;my $t="F3_EVIDENCE_V2\t$type\n";my $i=1;
 for my $m(@$meta){defined($m->[1])&&$m->[1]=~/\A[\x20-\x7e]+\z/&&index($m->[1],"\t")<0 or die "invalid META\n";$t.=sprintf("META\t%04d\t%s\t%s\n",$i++,$m->[0],$m->[1]);}
 my($r,$next)=rows_for_specs($specs,$i);$t.=$r;$i=$next;
 for my $row(@{$tail||[]}){$row=~s/__INDEX__/sprintf(q{%04d},$i++)/e;$t.=$row;}
 return $t;
}
sub stable_unique {my %s;return grep {!$s{$_}++} @_ ;}
sub candidate_path {my($p,$role)=@_;return "$TMP/$p.$role.candidate";}
sub publish_existing_candidate {
 my($c,$target,$expected)=@_;my $cs=inspect_path($c);$cs->{state} eq q{FILE}&&$cs->{data} eq $expected or die "candidate readback\n";no_entry($target) or die "publication target exists\n";
 link($c,$target) or die "publication link\n";my $cut=rindex($target,q{/});sync_dir(substr($target,0,$cut));my $ts=inspect_path($target);$ts->{state} eq q{FILE}&&$ts->{data} eq $expected&&$ts->{sha} eq $cs->{sha}&&$ts->{inode} eq $cs->{inode} or die "publication target readback\n";
 unlink($c) or die "candidate unlink\n";my $cc=rindex($c,q{/});sync_dir(substr($c,0,$cc));
}
sub publish_text {
 my($p,$role,$target,$text)=@_;my $c=candidate_path($p,$role);no_entry($c)&&no_entry($target) or die "publication precondition $role\n";
 sysopen(my $h,$c,O_WRONLY|O_CREAT|O_EXCL|O_NOFOLLOW,0600) or die "candidate create $role\n";sync_dir($TMP);chmod(0600,$c)==1 or die "candidate chmod\n";binmode($h);print {$h} $text or die "candidate write\n";sync_file($h);close($h) or die "candidate close\n";
 publish_existing_candidate($c,$target,$text);return sha256_hex($text);
}
sub frame_argv {my(@a)=@_;return pack(q{N},scalar(@a)).join(q{},map{pack(q{N},length($_)).$_}@a);}
my $guard_sequence_program_cache;
my %guard_observed_left_cache;
my %s0_command_sha_cache;
sub guard_sequence_program {
 return $guard_sequence_program_cache if defined($guard_sequence_program_cache);my $source=slurp($GUARD);my $env_open='my $environment_capture_program = q^';my $env_close="^;\n\nmy \$environment_capture_hex";my $seq_open='my $sequence_program = q!';my $splice='! . $environment_capture_hex . q!';my $seq_close="!;\n\nmy \@exact_child_argv=";for my $marker($env_open,$env_close,$seq_open,$splice,$seq_close){my $first=index($source,$marker);$first>=0&&$first==rindex($source,$marker) or die "guard embedded marker cardinality\n";}my $env_start=index($source,$env_open)+length($env_open);my $env_end=index($source,$env_close,$env_start);my $environment_program=substr($source,$env_start,$env_end-$env_start);my $seq_start=index($source,$seq_open)+length($seq_open);my $splice_at=index($source,$splice,$seq_start);my $suffix_start=$splice_at+length($splice);my $seq_end=index($source,$seq_close,$suffix_start);$env_end>$env_start&&$splice_at>$seq_start&&$seq_end>$suffix_start or die "guard embedded program bounds\n";$guard_sequence_program_cache=substr($source,$seq_start,$splice_at-$seq_start).unpack(q{H*},$environment_program).substr($source,$suffix_start,$seq_end-$suffix_start);return $guard_sequence_program_cache;
}
sub guard_child_argv_sha {my($p,$left)=@_;my @argv=($GTIMEOUT,q{--foreground},q{--signal=TERM},q{--kill-after=5},$left,$TIME,q{-p},$PERL,q{-e},guard_sequence_program(),$p);my $frame=scalar(@argv).q{:};for my $arg(@argv){$frame.=length($arg).q{:}.$arg;}return sha256_hex($frame);}
sub validate_guard_child_argv_sha {
 my($p,$observed,$left)=@_;if(defined($left)){guard_child_argv_sha($p,$left) eq $observed or die "guard exact child argv mismatch\n";$guard_observed_left_cache{"$p:$observed"}=$left;return $left;}return $guard_observed_left_cache{"$p:$observed"} if exists($guard_observed_left_cache{"$p:$observed"});my($matches,$matched_left)=(0,undef);for my $candidate(1..$ceiling{$p}){if(guard_child_argv_sha($p,$candidate) eq $observed){$matches++;$matched_left=$candidate;}}$matches==1 or die "guard historical argv is not one unique permitted remaining value\n";$guard_observed_left_cache{"$p:$observed"}=$matched_left;return $matched_left;
}
sub validate_s0_command_sha {my($observed)=@_;return 1 if $s0_command_sha_cache{$observed};my $matches=0;for my $left(1..$ceiling{S0}){my $expected=sha256_hex(frame_argv($GTIMEOUT,q{--foreground},q{--signal=TERM},q{--kill-after=5},$left,$BASH,$MATERIALIZER));$matches++ if $expected eq $observed;}$matches==1 or die "S0 exact dynamic command argv mismatch\n";$s0_command_sha_cache{$observed}=1;return 1;}
sub read_live_git_value {my($k)=@_;my $left=remaining();my @git=$k eq q{head}?($GIT,q{-C},$ROOT,q{rev-parse},q{HEAD}):$k eq q{branch}?($GIT,q{-C},$ROOT,q{branch},q{--show-current}):die "unknown live Git field\n";my @a=($GTIMEOUT,q{--foreground},q{--signal=TERM},q{--kill-after=5},$left,@git);open(my $h,q{-|},@a) or die "git spawn\n";my $v=<$h>;defined($v) or die "git output\n";close($h) or die "git status\n";chomp($v);$v=~/\A[0-9A-Za-z._\/-]+\z/ or die "git value\n";return $v;}
sub cache_live_git_identity {$live_git_head=read_live_git_value(q{head});$live_git_branch=read_live_git_value(q{branch});}
sub verify_live_tracked_source_baseline {
 my($head)=@_;canonical_git_oid($head)&&$command_table_loaded or die "tracked baseline verification precondition\n";my $left=remaining();my @argv=($GTIMEOUT,q{--foreground},q{--signal=TERM},q{--kill-after=5},$left,$GIT,q{-C},$ROOT,q{ls-tree},q{-r},q{-z},q{--name-only},$head,q{--},q{CollatzClassical/KL2003});open(my $h,q{-|},@argv) or die "tracked baseline Git spawn\n";binmode($h);local $/;my $raw=<$h>;defined($raw) or $raw=q{};close($h) or die "tracked baseline Git status\n";length($raw)>0&&substr($raw,-1) eq "\0" or die "tracked baseline Git framing\n";my @live=split /\0/,$raw,-1;pop @live;my %seen;for my $path(@live){$path=~/\A[\x20-\x7e]+\z/&&index($path,"\t")<0&&index($path,q{CollatzClassical/KL2003/})==0&&$path ne rel($PAYLOAD) or die "tracked baseline Git path\n";my @part=split m{/},$path,-1;!(grep{$_ eq q{}||$_ eq q{.}||$_ eq q{..}}@part) or die "tracked baseline Git canonicality\n";$seen{$path}++ and die "tracked baseline Git duplicate\n";}@live=sort{$a cmp $b}@live;@live==@generated_source_baseline_files or die "tracked baseline Git cardinality\n";for my $i(0..$#live){$live[$i] eq $generated_source_baseline_files[$i] or die "tracked baseline Git/table mismatch\n";}return 1;
}
sub command_recipe {
 my($p)=@_;if($p=~/\A(?:B0|R0|G01|G02|G03|G04|G05|G06|V0|A0)\z/){return(q{GUARD_PHASE_ARGV},frame_argv($BASH,$GUARD,$p));}if($p eq q{S0}){return(q{DYNAMIC_REMAINING_ARGV},frame_argv($GTIMEOUT,q{--foreground},q{--signal=TERM},q{--kill-after=5},q{DYNAMIC_POSITIVE_REMAINING_SECONDS},$BASH,$MATERIALIZER));}if($p=~/\A(?:P0|P1|F0)\z/){return(q{INTERNAL_FIXED_RECEIPT_WRITER},frame_argv(q{INTERNAL_FIXED_RECEIPT_WRITER_V1},$p));}$p eq q{C0} or die "command recipe phase\n";return(q{INTERNAL_C0_CUSTODY_WRITER},frame_argv(q{INTERNAL_C0_CUSTODY_WRITER_V1},q{C0}));
}
sub expected_object_role {
 my($consumer,$path)=@_;for my $producer(qw(B0 R0 V0 A0)){my %root=map{$_=>1}producer_olean_paths($producer);next unless $root{$path};$normal_index{$producer}<$normal_index{$consumer} or die "current/future producer object in input ledger\n";$producer ne q{A0} or die "A0-produced object has no Lean consumer\n";return "PRODUCED_$producer";}return q{STATIC_PREEXISTING};
}
sub parse_command_table {
 my $b=slurp(abs_path($run_inputs[2]));index($b,"\0")<0&&index($b,"\r")<0&&substr($b,-1) eq "\n" or die "command table encoding\n";my @line=split /\n/,$b,-1;pop @line;my $at=0;$line[$at++] eq q{F3_R3_V3_COMMAND_TABLE_V1} or die "command table header\n";my @commands=(@normal,q{C0});$line[$at++] eq "COMMAND_COUNT\t".scalar(@commands) or die "command table command count\n";for my $i(0..$#commands){$at<@line or die "command row missing\n";my @f=split /\t/,$line[$at++],-1;@f==5&&$f[0] eq q{COMMAND}&&$f[1] eq sprintf(q{%04d},$i+1)&&$f[2] eq $commands[$i]&&canonical_hash($f[4]) or die "command row grammar/order\n";my($kind,$recipe)=command_recipe($commands[$i]);$f[3] eq $kind&&$f[4] eq sha256_hex($recipe) or die "command recipe fingerprint\n";}
 $line[$at++] eq "OBJECT_PHASE_COUNT\t".scalar(@normal) or die "object phase count\n";my(%paths,%roles);my $object_total=0;my $object_global=q{};for my $pi(0..$#normal){$at<@line or die "object phase missing\n";my $header=$line[$at++];my @h=split /\t/,$header,-1;@h==6&&$h[0] eq q{OBJECT_PHASE}&&$h[1] eq sprintf(q{%04d},$pi+1)&&$h[2] eq $normal[$pi]&&canonical_uint($h[3])&&canonical_hash($h[4])&&$h[5]=~/\A(?:EMPTY|NONEMPTY)\z/ or die "object phase grammar/order\n";my $count=0+$h[3];($count==0&&$h[5] eq q{EMPTY})||($count>0&&$h[5] eq q{NONEMPTY}) or die "object phase emptiness token\n";if($normal[$pi]=~/\A(?:P0|S0|P1|F0)\z/){$count==0 or die "internal phase object ledger nonempty\n";}else{$count>0 or die "Lean phase object ledger empty\n";}my(@p,@r);my %seen;my $vector=q{};for my $oi(1..$count){$at<@line or die "object row missing\n";my $raw=$line[$at++];my @f=split /\t/,$raw,-1;@f==5&&$f[0] eq q{INPUT_OBJECT}&&$f[1] eq $normal[$pi]&&$f[2] eq sprintf(q{%06d},$oi)&&$f[3]=~/\A(?:STATIC_PREEXISTING|PRODUCED_B0|PRODUCED_R0|PRODUCED_V0)\z/&&$f[4]=~/\A(?:[0-9a-f]{2})+\z/ or die "object row grammar/order\n";my $path=pack(q{H*},$f[4]);index($path,"\0")<0 or die "object path NUL\n";$path=lexical_path($path);$path=~/\.olean\z/ or die "object path suffix\n";my @membership=(index($path,"$ROOT/.lake/build/")==0,index($path,"$ROOT/.lake/packages/")==0,index($path,q{/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/lib/lean/})==0);(grep{$_}@membership)==1 or die "object path root membership\n";$seen{$path}++ and die "duplicate phase object path\n";$f[3] eq expected_object_role($normal[$pi],$path) or die "object role/producer mismatch\n";push @p,$path;push @r,$f[3];$vector.=$raw."\n";}$h[4] eq sha256_hex($vector) or die "object phase vector hash\n";$paths{$normal[$pi]}=\@p;$roles{$normal[$pi]}=\@r;$object_total+=$count;$object_global.=$header."\n".$vector;}
 $at<@line or die "object total missing\n";my @total=split /\t/,$line[$at++],-1;@total==3&&$total[0] eq q{OBJECT_TOTAL}&&canonical_uint($total[1])&&$total[1]==$object_total&&canonical_hash($total[2])&&$total[2] eq sha256_hex($object_global) or die "object total/hash\n";
 $at<@line or die "tracked baseline count missing\n";my @bc=split /\t/,$line[$at++],-1;@bc==2&&$bc[0] eq q{TRACKED_SOURCE_BASELINE_COUNT}&&canonical_uint($bc[1])&&$bc[1]>0 or die "tracked baseline count\n";my @baseline;my %baseline_seen;my $baseline_vector=q{};my $last;for my $i(1..$bc[1]){$at<@line or die "tracked baseline row missing\n";my $raw=$line[$at++];my @f=split /\t/,$raw,-1;@f==3&&$f[0] eq q{TRACKED_SOURCE}&&$f[1] eq sprintf(q{%06d},$i)&&$f[2]=~/\A(?:[0-9a-f]{2})+\z/ or die "tracked baseline row grammar\n";my $path=pack(q{H*},$f[2]);$path=~/\A[\x20-\x7e]+\z/&&index($path,"\t")<0&&index($path,q{CollatzClassical/KL2003/})==0&&$path ne rel($PAYLOAD) or die "tracked baseline root/bytes/payload\n";my @part=split m{/},$path,-1;!(grep{$_ eq q{}||$_ eq q{.}||$_ eq q{..}}@part) or die "tracked baseline canonicality\n";$baseline_seen{$path}++ and die "tracked baseline duplicate\n";defined($last)&&$last ge $path and die "tracked baseline order\n";$last=$path;push @baseline,$path;$baseline_vector.=$raw."\n";}
 $at<@line or die "tracked baseline hash missing\n";my @bh=split /\t/,$line[$at++],-1;@bh==2&&$bh[0] eq q{TRACKED_SOURCE_BASELINE_SHA256}&&canonical_hash($bh[1])&&$bh[1] eq sha256_hex($baseline_vector) or die "tracked baseline hash\n";$at<@line&&$line[$at++] eq "END\tF3_R3_V3_COMMAND_TABLE_V1" or die "command table end\n";$at==@line or die "command table trailing rows\n";
 %command_object_paths=%paths;%command_object_roles=%roles;@generated_source_baseline_files=@baseline;$command_table_loaded=1;return sha256_hex($b);
}
sub git_value {my($k)=@_;defined($frozen_git_head)&&defined($frozen_git_branch) or die "frozen Git identity unavailable\n";return $k eq q{head}?$frozen_git_head:$k eq q{branch}?$frozen_git_branch:die "unknown frozen Git field\n";}
sub remaining {my $n=int($deadline-clock_gettime(CLOCK_MONOTONIC));$n>0 or die "phase wall exhausted\n";return $n;}
sub receipt_path {return "$RESULT/$terminal{$_[0]}";}
sub predecessor_paths {my($p)=@_;return map{rel(receipt_path($_))}@{$pred{$p}};}
sub control_paths {
 return (rel("$CONTROL/admission.guard"),rel("$CONTROL/writer.guard"),rel("$CONTROL/normal-lease.candidate"),rel("$CONTROL/c0-lease.candidate"),rel("$CONTROL/contention.candidate"),rel("$CONTROL/active_normal_lease.tsv"),rel("$CONTROL/active_c0_lease.tsv"),rel("$CONTROL/first_contention.tsv"),map{rel("$LEASES/$_.lease.tsv")}(@normal,q{C0}));
}
sub authority_paths {return(rel($AUTH),rel("$OUT/F3_R3_V3_INPUT_REGISTRY_AND_PREEXECUTION_REVIEW_ROOT_AUTHORING_AUTHORIZATION_v1.md"),rel("$OUT/F3_R3_V3_INPUT_REGISTRY_AND_PREEXECUTION_REVIEW_v1.md"),rel("$OUT/F3_R3_V3_EXACT_SEVEN_INPUT_INDEPENDENT_STATIC_AUDIT_1_PASS_v1.md"),rel("$OUT/F3_R3_V3_EXACT_SEVEN_INPUT_INDEPENDENT_STATIC_AUDIT_2_PASS_v1.md"),rel("$OUT/F3_R3_V3_EXACT_SEVEN_INPUT_ROOT_FREEZE_DECISION_v1.md"),rel("$OUT/F3_R3_V3_B0_EXECUTION_ROOT_AUTHORIZATION_AND_RUNBOOK_v1.md"));}
sub control_specs {
 my($capture,$p)=@_;return map{[$_,q{CENSUS}]}control_paths() if $capture eq q{FAILURE_LOCKED_CENSUS};
 if($capture eq q{BOOTSTRAP_PRE_ATTEMPT}){my @cp=control_paths();my @want=(q{FILE},q{FILE},map{q{ABSENT}}1..21);@cp==23&&@want==23 or die "bootstrap control cardinality\n";my @s;for my $i(0..22){push @s,[$cp[$i],$want[$i]];}return @s;}
 my $idx=$normal_index{$p};my @want=(q{FILE},q{FILE},q{ABSENT},q{ABSENT},q{ABSENT},q{FILE},q{ABSENT},q{ABSENT});
 for my $i(0..$#normal){push @want,$i<$idx||($i==$idx&&$capture eq q{LOCKED_PRETERMINAL_POST_ARCHIVE})?q{FILE}:q{ABSENT};}push @want,q{ABSENT};
 my @cp=control_paths();@cp==23&&@want==23 or die "control cardinality\n";my @s;for my $i(0..22){push @s,[$cp[$i],$want[$i]];}return @s;
}
sub vector_hash {my($specs)=@_;my($r)=rows_for_specs($specs,1);return sha256_hex($r);}
sub lake_modules {my($p)=@_;return @b0_modules if $p eq q{B0};return @new_modules[0,1] if $p eq q{R0};return @new_modules[2,3] if $p eq q{V0};return($new_modules[4]) if $p eq q{A0};return();}
sub lake_paths {my($p)=@_;my @r;for my $m(lake_modules($p)){(my $s=$m)=~s{\.}{/}g;push @r,map{".lake/build/$_"}("lib/lean/$s.olean","lib/lean/$s.ilean","lib/lean/$s.trace","lib/lean/$s.olean.hash","lib/lean/$s.ilean.hash","ir/$s.c","ir/$s.c.hash");}return @r;}
sub producer_olean_paths {my($p)=@_;return map{abs_path($_)}grep{/\.olean\z/}lake_paths($p);}
sub module_source {my($m)=@_;(my $s=$m)=~s{\.}{/}g;return "$s.lean";}
sub phase_sources {
 my($p)=@_;my @s=(@contracts,rel($REGISTRY_V10),rel($NORMAL_TEMPLATE),rel($INVALID_TEMPLATE),q{lean-toolchain},q{lake-manifest.json},q{lakefile.lean},map{module_source($_)}@b0_modules);
 push @s,map{rel("$FRAGMENTS/".sprintf(q{row_%02d.canonical_fragment.lean},$_))}1..6 if $p=~/\A(?:S0|P1|V0|A0|F0)\z/;
 push @s,rel($PAYLOAD) if $p=~/\A(?:P1|V0|A0|F0)\z/;return stable_unique(@s);
}
sub parse_loaded_paths {
 my($p)=@_;my $path="$RESULT/$p.loaded_objects.tsv";my(undef,undef,$rows)=validate_phase_evidence($path,1,q{F3_LOADED_OBJECT_TRACE_V1},$p);my @o=map{rel($_->{path})}@$rows;@o or die "empty loaded trace $p\n";return @o;
}
sub phase_object_absolute_paths {$command_table_loaded or die "command table object ledger unavailable\n";my($p)=@_;exists($command_object_paths{$p}) or die "object ledger phase\n";return @{$command_object_paths{$p}};}
sub phase_objects {my($p)=@_;return map{rel($_)}phase_object_absolute_paths($p);}
sub phase_object_roles {$command_table_loaded or die "command table object roles unavailable\n";my($p)=@_;exists($command_object_roles{$p}) or die "object role phase\n";return @{$command_object_roles{$p}};}
sub p0_resolved_objects {my @o;for my $p(qw(B0 R0)){push @o,parse_loaded_paths($p);}return stable_unique(@o);}
sub input_manifest {
 my($p)=@_;my @cs=control_specs(q{POST_ACTIVE_PRE_PAYLOAD},$p);my @src=(@seven_inputs,phase_sources($p),@run_inputs);my @obj=phase_objects($p);my @paths=(map{[$_,q{FILE}]}(authority_paths(),predecessor_paths($p),@src,@tools,@obj));push @paths,@cs;
 my @m=([PHASE=>$p],[ATTEMPT=>1],[GIT_HEAD=>git_value(q{head})],[GIT_BRANCH=>git_value(q{branch})],[CWD=>$ROOT],[AUTHORITY_COUNT=>7],[PREDECESSOR_COUNT=>scalar(@{$pred{$p}})],[SOURCE_COUNT=>scalar(@src)],[TOOL_COUNT=>scalar(@tools)],[OBJECT_COUNT=>scalar(@obj)],[CONTROL_COUNT=>23],[CONTROL_VECTOR_SHA256=>vector_hash(\@cs)],[CONTROL_CAPTURE=>q{POST_ACTIVE_PRE_PAYLOAD}]);return typed_evidence(q{F3_INPUT_MANIFEST_V1},\@m,\@paths,[]);
}

my %schema_meta=(
 F3_ENVIRONMENT_V1=>[qw(PHASE ENTRY_COUNT VECTOR_SHA256)],
 F3_LAKE_DELTA_V1=>[qw(PHASE ALLOWED_PATH_COUNT CHANGED_PATH_COUNT PACKAGE_DELTA_COUNT SYSROOT_DELTA_COUNT)],
 F3_RUN_INPUT_MANIFEST_V1=>[qw(GIT_HEAD GIT_BRANCH CWD AUTHORITY_COUNT CONTRACT_COUNT SEVEN_INPUT_COUNT SOURCE_COUNT TOOL_COUNT COMMAND_TABLE_SHA256 BASE_ENVIRONMENT_SHA256 BUILD_PRESTATE_COUNT CONTROL_COUNT CONTROL_VECTOR_SHA256 CONTROL_CAPTURE)],
 F3_PRE_GENERATION_MANIFEST_V1=>[qw(PHASE PREDECESSOR_PHASES PREDECESSOR_RECEIPT_SHA256S AUTHORITY_COUNT SEVEN_INPUT_COUNT SOURCE_COUNT OBJECT_COUNT TRANSITIVE_FILE_COUNT TRANSITIVE_VECTOR_SHA256 CONTROL_COUNT CONTROL_VECTOR_SHA256 CONTROL_CAPTURE)],
 F3_POST_GENERATION_MANIFEST_V1=>[qw(PHASE PREDECESSOR_PHASES PREDECESSOR_RECEIPT_SHA256S FRAGMENT_COUNT PAYLOAD_SHA256 BUILD_PRESTATE_COUNT TRANSITIVE_FILE_COUNT TRANSITIVE_VECTOR_SHA256 CONTROL_COUNT CONTROL_VECTOR_SHA256 CONTROL_CAPTURE)],
 F3_FINAL_ARTIFACTS_MANIFEST_V1=>[qw(PHASE PREDECESSOR_PHASES PREDECESSOR_RECEIPT_SHA256S PREDECESSOR_PHASE_COUNT TERMINAL_RECEIPT_COUNT TRANSITIVE_FILE_COUNT TRANSITIVE_VECTOR_SHA256 VERDICT_INPUT_COUNT CONTROL_COUNT CONTROL_VECTOR_SHA256 CONTROL_CAPTURE)],
 F3_INPUT_MANIFEST_V1=>[qw(PHASE ATTEMPT GIT_HEAD GIT_BRANCH CWD AUTHORITY_COUNT PREDECESSOR_COUNT SOURCE_COUNT TOOL_COUNT OBJECT_COUNT CONTROL_COUNT CONTROL_VECTOR_SHA256 CONTROL_CAPTURE)],
 F3_OUTPUT_MANIFEST_V1=>[qw(PHASE ATTEMPT RESULT RESULT_PATH_COUNT LAKE_ALLOWED_COUNT LAKE_CHANGED_COUNT PACKAGE_DELTA_COUNT SYSROOT_DELTA_COUNT ROOT_COUNT DEPENDENCY_LINE_COUNT UNIQUE_OBJECT_COUNT CONTROL_COUNT CONTROL_VECTOR_SHA256 CONTROL_CAPTURE)],
 F3_GUARD_RECEIPT_V1=>[qw(PHASE ATTEMPT ROOT_PID PROCESS_START_TOKEN PGID AVAILABLE_KIB MIN_AVAILABLE_KIB MAX_SAMPLED_RSS_KIB SAMPLE_PERIOD_SECONDS PEAK_SAMPLED_RSS_KIB EXIT_STATUS MEMORY_VIOLATION EXACT_CHILD_ARGV_SHA256 START_UTC END_UTC)],
 F3_LOADED_OBJECT_TRACE_V1=>[qw(PHASE ROOT_COUNT DEPENDENCY_LINE_COUNT UNIQUE_OBJECT_COUNT PROJECT_OBJECT_COUNT PACKAGE_OBJECT_COUNT SYSROOT_OBJECT_COUNT)],
 F3_PHASE_TERMINAL_RECEIPT_V1=>[qw(PHASE ATTEMPT RESULT GIT_HEAD GIT_BRANCH PREDECESSOR_PHASES PREDECESSOR_RECEIPT_SHA256S COMMAND_SHA256 CWD LC_ALL LANG WALL_LIMIT_SECONDS EXIT_STATUS START_UTC END_UTC PRE_REVALIDATION POST_REVALIDATION INPUT_MANIFEST_SHA256 OUTPUT_MANIFEST_SHA256)],
 F3_F0_TERMINAL_RECEIPT_V1=>[qw(PHASE ATTEMPT RESULT GIT_HEAD GIT_BRANCH PREDECESSOR_PHASES PREDECESSOR_RECEIPT_SHA256S COMMAND_SHA256 CWD LC_ALL LANG WALL_LIMIT_SECONDS EXIT_STATUS START_UTC END_UTC PRE_REVALIDATION POST_REVALIDATION INPUT_MANIFEST_SHA256 OUTPUT_MANIFEST_SHA256 FINAL_ARTIFACTS_SHA256 TERMINAL_BRANCH CHECKER_CLASSIFICATION MACHINE_VERDICT SCOPED_CLASSIFICATION_1 SCOPED_CLASSIFICATION_2 SCOPED_CLASSIFICATION_3 SATURATED_ROWS DEFICIENT_ROWS)],
 F3_F0_REPORT_CUSTODY_V1=>[qw(RESULT GIT_HEAD GIT_BRANCH FINAL_ARTIFACTS_SHA256 F0_TERMINAL_RECEIPT_SHA256 REPORT_SHA256)],
 F3_INVALID_CUSTODY_MANIFEST_V1=>[qw(RESULT FIRST_INVALID_PHASE FIRST_INVALID_PREDICATE WRITER_LOCK_ACQUIRED NORMAL_PHASES_NEVER_STARTED C0_ATTEMPT)]);
sub meta_map {my($b)=@_;my %m;for my $l(split /\n/,$b){if($l=~/\AMETA\t[0-9]{4}\t([^\t]+)\t([^\t]+)\z/){exists($m{$1}) and die "duplicate META\n";$m{$1}=$2;}}return \%m;}
sub canonical_uint {return defined($_[0])&&$_[0]=~/\A(?:0|[1-9][0-9]*)\z/;}
sub canonical_hash {return defined($_[0])&&$_[0]=~/\A[0-9a-f]{64}\z/;}
sub canonical_git_oid {return defined($_[0])&&$_[0]=~/\A[0-9a-f]{40}\z/;}
sub validate_noncanonical_fields {my($kind,$mode,$detail)=@_;$kind=~/\A(?:SYMLINK|DIRECTORY|FIFO|SOCKET|DEVICE|UNREADABLE|STAT_ERROR|CHANGED|OTHER)\z/&&$mode=~/\A(?:[0-7]{4}|-)\z/&&canonical_hash($detail) or die "NONCANONICAL token\n";}
sub parse_evidence_file {
 my($path,$expected_type)=@_;defined($expected_type)&&exists($schema_meta{$expected_type}) or die "expected evidence type\n";my $b=slurp($path);index($b,"\r")<0&&index($b,"\0")<0&&substr($b,-1) eq "\n" or die "evidence encoding $path\n";my @lines=split /\n/,$b,-1;pop @lines;@lines>=1&&$lines[0] eq "F3_EVIDENCE_V2\t$expected_type" or die "evidence TYPE $path\n";my @keys=@{$schema_meta{$expected_type}};my %m;my @rows;my %fixed_seen;my %unexpected_seen;my $expected_index=1;my $in_tail=0;my $last_unexpected;
 for my $li(1..$#lines){my @f=split /\t/,$lines[$li],-1;@f>=3&&$f[1] eq sprintf(q{%04d},$expected_index++) or die "evidence row order $path\n";
  if($li<=@keys){@f==4&&$f[0] eq q{META}&&$f[2] eq $keys[$li-1] or die "META registry $path\n";defined($f[3])&&length($f[3])>0&&$f[3]=~/\A[\x20-\x7e]+\z/&&index($f[3],"\t")<0 or die "META value $path\n";exists($m{$f[2]}) and die "duplicate META $path\n";$m{$f[2]}=$f[3];next;}
  $f[0] ne q{META} or die "late META $path\n";my $row={kind=>$f[0],fields=>\@f};
  if($f[0] eq q{FILE}){@f==5&&canonical_hash($f[2])&&canonical_uint($f[3])&&length($f[4])>0 or die "FILE grammar $path\n";$in_tail and die "fixed row after unexpected tail\n";exists($fixed_seen{$f[4]}) and die "duplicate fixed path $path\n";$fixed_seen{$f[4]}=1;$row->{path}=$f[4];}
  elsif($f[0] eq q{ABSENT}){@f==3&&length($f[2])>0 or die "ABSENT grammar $path\n";$in_tail and die "fixed row after unexpected tail\n";exists($fixed_seen{$f[2]}) and die "duplicate fixed path $path\n";$fixed_seen{$f[2]}=1;$row->{path}=$f[2];}
  elsif($f[0] eq q{NONCANONICAL}){@f==6&&length($f[5])>0 or die "NONCANONICAL grammar $path\n";validate_noncanonical_fields(@f[2,3,4]);$in_tail and die "fixed row after unexpected tail\n";exists($fixed_seen{$f[5]}) and die "duplicate fixed path $path\n";$fixed_seen{$f[5]}=1;$row->{path}=$f[5];}
  elsif($f[0] eq q{ENV}){@f==4&&$f[2]=~/\A(?:[0-9a-f]{2})+\z/&&$f[3]=~/\A(?:[0-9a-f]{2})*\z/ or die "ENV grammar $path\n";$in_tail and die "ENV after tail\n";my $key=pack(q{H*},$f[2]);exists($fixed_seen{"ENV\0$key"}) and die "duplicate ENV key\n";$fixed_seen{"ENV\0$key"}=1;$row->{env_key}=$key;$row->{env_value}=pack(q{H*},$f[3]);}
  elsif($f[0] eq q{OBJECT}){@f==5&&canonical_hash($f[2])&&canonical_uint($f[3])&&$f[4]=~/\A[\x20-\x7e]+\z/&&index($f[4],"\t")<0 or die "OBJECT grammar $path\n";$in_tail and die "OBJECT after tail\n";exists($fixed_seen{$f[4]}) and die "duplicate object path\n";$fixed_seen{$f[4]}=1;$row->{path}=$f[4];}
  elsif($f[0] eq q{DELTA}){@f==9&&$f[2]=~/\A(?:FILE|ABSENT|NONCANONICAL)\z/&&$f[5]=~/\A(?:FILE|ABSENT|NONCANONICAL)\z/&&length($f[8])>0 or die "DELTA grammar $path\n";for my $o(2,5){if($f[$o] eq q{FILE}){canonical_hash($f[$o+1])&&canonical_uint($f[$o+2]) or die "DELTA FILE fields\n";}else{$f[$o+1] eq q{-}&&$f[$o+2] eq q{-} or die "DELTA nonfile fields\n";}}$in_tail and die "DELTA after tail\n";exists($fixed_seen{$f[8]}) and die "duplicate delta path\n";$fixed_seen{$f[8]}=1;$row->{path}=$f[8];}
  elsif($f[0] eq q{UNEXPECTED_FILE}){@f==5&&canonical_hash($f[2])&&canonical_uint($f[3])&&$f[4]=~/\A(?:[0-9a-f]{2})+\z/ or die "UNEXPECTED_FILE grammar\n";$in_tail=1;my $raw=pack(q{H*},$f[4]);index($raw,"\0")<0 or die "unexpected NUL path\n";exists($unexpected_seen{$raw}) and die "duplicate unexpected path\n";defined($last_unexpected)&&$last_unexpected ge $raw and die "unexpected path order\n";$last_unexpected=$raw;$unexpected_seen{$raw}=1;$row->{unexpected_path}=$raw;}
  elsif($f[0] eq q{UNEXPECTED_NONCANONICAL}){@f==6&&$f[5]=~/\A(?:[0-9a-f]{2})+\z/ or die "UNEXPECTED_NONCANONICAL grammar\n";validate_noncanonical_fields(@f[2,3,4]);$in_tail=1;my $raw=pack(q{H*},$f[5]);index($raw,"\0")<0 or die "unexpected NUL path\n";exists($unexpected_seen{$raw}) and die "duplicate unexpected path\n";defined($last_unexpected)&&$last_unexpected ge $raw and die "unexpected path order\n";$last_unexpected=$raw;$unexpected_seen{$raw}=1;$row->{unexpected_path}=$raw;}
  else{die "unknown evidence row $path\n";}
  push @rows,$row;
 }
 @lines>=1+@keys or die "missing META rows $path\n";return {bytes=>$b,type=>$expected_type,meta=>\%m,rows=>\@rows};
}
sub validate_evidence {
 my($path,$historical,$expected_type)=@_;my $e=parse_evidence_file($path,$expected_type);validate_meta_values($path,$e);validate_schema_rows($path,$e,$historical);return(sha256_hex($e->{bytes}),$e->{meta},$e->{rows});
}
sub validate_phase_evidence {
 my($path,$historical,$expected_type,$p)=@_;exists($normal_index{$p}) or die "phase-bound validator phase\n";my @v=validate_evidence($path,$historical,$expected_type);defined($v[1]{PHASE})&&$v[1]{PHASE} eq $p or die "physical path/META PHASE mismatch\n";return @v;
}
sub validate_terminal_pass {
 my($p)=@_;my $type=$p eq q{F0}?q{F3_F0_TERMINAL_RECEIPT_V1}:q{F3_PHASE_TERMINAL_RECEIPT_V1};my($sha,$m)=validate_phase_evidence(receipt_path($p),1,$type,$p);$m->{RESULT} eq q{PASS}&&$m->{PRE_REVALIDATION} eq q{PASS}&&$m->{POST_REVALIDATION} eq q{PASS} or die "non-PASS predecessor $p\n";
 my $in="$RESULT/$p.inputs.sha256";my $out="$RESULT/$p.outputs.sha256";validate_phase_evidence($in,1,q{F3_INPUT_MANIFEST_V1},$p);validate_phase_evidence($out,1,q{F3_OUTPUT_MANIFEST_V1},$p);validate_phase_evidence("$RESULT/pre_generation_manifest.sha256",1,q{F3_PRE_GENERATION_MANIFEST_V1},q{P0}) if $p eq q{P0};validate_phase_evidence("$RESULT/post_generation_manifest.sha256",1,q{F3_POST_GENERATION_MANIFEST_V1},q{P1}) if $p eq q{P1};sha_file($in) eq $m->{INPUT_MANIFEST_SHA256}&&sha_file($out) eq $m->{OUTPUT_MANIFEST_SHA256} or die "manifest chain $p\n";return $sha;
}
sub validate_predecessors {my($p)=@_;for my $q(@{$pred{$p}}){validate_terminal_pass($q);}return q{PASS};}
sub check_normal_eligibility {
 my($p)=@_;exists($normal_index{$p}) or die "normal phase required\n";my $idx=$normal_index{$p};
 for my $i(0..$#normal){my $q=$normal[$i];my $r=inspect_path(receipt_path($q));my $a=inspect_path("$LEASES/$q.lease.tsv");if($i<$idx){$r->{state} eq q{FILE}&&$a->{state} eq q{FILE} or die "phase order predecessor $q\n";validate_terminal_pass($q);}else{$r->{state} eq q{ABSENT}&&$a->{state} eq q{ABSENT} or die "phase already consumed $q\n";}}
 for my $p0("$CONTROL/normal-lease.candidate","$CONTROL/c0-lease.candidate","$CONTROL/contention.candidate","$CONTROL/active_normal_lease.tsv","$CONTROL/active_c0_lease.tsv","$CONTROL/first_contention.tsv","$LEASES/C0.lease.tsv"){no_entry($p0) or die "control precondition\n";}
 for my $i($idx..$#normal){for my $r(@{$phase_paths{$normal[$i]}}){no_entry("$RESULT/$r") or die "future result exists\n";}}
 for my $owner(qw(B0 R0 V0 A0)){next if $normal_index{$owner}<$idx;for my $path(lake_paths($owner)){no_entry(abs_path($path)) or die "future/warm LAKE7 artifact\n";}}
 for my $candidate(all_publication_candidate_paths()){no_entry(abs_path($candidate)) or die "pre-attempt publication candidate\n";}
 no_entry($PAYLOAD) or $idx>$normal_index{S0} or die "premature payload\n";
 return q{PASS};
}
sub open_guard {
 my($p,$cloexec)=@_;my $s=inspect_path($p);$s->{state} eq q{FILE} or die "guard file\n";sysopen(my $h,$p,O_RDWR|O_NOFOLLOW) or die "guard open\n";my @f0=stat($h);my @z0=lstat($p);@f0&&@z0&&S_ISREG($f0[2])&&!S_ISLNK($z0[2])&&join(q{:},$f0[0],$f0[1]) eq $s->{inode}&&join(q{:},$z0[0],$z0[1]) eq $s->{inode}&&sprintf(q{%04o},$f0[2]&07777) eq $s->{mode}&&sprintf(q{%04o},$z0[2]&07777) eq $s->{mode}&&$f0[7]==$s->{bytes}&&$z0[7]==$s->{bytes}&&$f0[9]==$s->{mtime}&&$z0[9]==$s->{mtime} or die "guard identity\n";my $flags=fcntl($h,F_GETFD,0);defined($flags) or die "guard flags\n";my $new=$cloexec?($flags|FD_CLOEXEC):($flags&~FD_CLOEXEC);defined(fcntl($h,F_SETFD,$new)) or die "guard cloexec\n";my @f1=stat($h);my @z1=lstat($p);@f1&&@z1&&$f1[0]==$f0[0]&&$f1[1]==$f0[1]&&$z1[0]==$f0[0]&&$z1[1]==$f0[1]&&($f1[2]&0177777)==($f0[2]&0177777)&&($z1[2]&0177777)==($f0[2]&0177777)&&$f1[7]==$f0[7]&&$z1[7]==$f0[7]&&$f1[9]==$f0[9]&&$z1[9]==$f0[9] or die "guard changed after open\n";return $h;
}
sub publish_contention {
 my($requested)=@_;my $candidate="$CONTROL/contention.candidate";return if !no_entry("$CONTROL/first_contention.tsv")||!no_entry($candidate);my $active=inspect_path("$CONTROL/active_normal_lease.tsv");my $state=$active->{state};my $hash=$state eq q{FILE}?$active->{sha}:q{NONE};my $text="F3_CONTENTION_V1\nREQUESTED_PHASE\t$requested\nACTIVE_STATE\t$state\nACTIVE_SHA256\t$hash\nUTC\t".scalar(gmtime())."Z\n";
 sysopen(my $h,$candidate,O_WRONLY|O_CREAT|O_EXCL|O_NOFOLLOW,0600) or return;sync_dir($CONTROL);chmod(0600,$candidate)==1 or die "contention chmod\n";binmode($h);print {$h}$text or die "contention write\n";sync_file($h);close($h) or die "contention close\n";my $cs=inspect_path($candidate);$cs->{state} eq q{FILE}&&$cs->{data} eq $text or die "contention readback\n";
 if(no_entry("$CONTROL/first_contention.tsv")){link($candidate,"$CONTROL/first_contention.tsv") or die "contention link\n";sync_dir($CONTROL);my $t=inspect_path("$CONTROL/first_contention.tsv");$t->{state} eq q{FILE}&&$t->{sha} eq $cs->{sha} or die "contention target\n";unlink($candidate) or die "contention candidate unlink\n";sync_dir($CONTROL);}
}
sub lease_text {
 my($p,$kind)=@_;return join("\n",q{F3_LEASE_V1},"KIND\t$kind","PHASE\t$p","PID\t$$","PROCESS_START_TOKEN\t".sprintf(q{%.9f},clock_gettime(CLOCK_MONOTONIC)),"EXECUTOR_PATH\t".rel($EXECUTOR),"EXECUTOR_SHA256\t".sha_file($EXECUTOR),"ARGV_SHA256\t".sha256_hex(frame_argv($EXECUTOR,$p)),"UTC\t".scalar(gmtime()).q{Z},"GIT_HEAD\t".git_value(q{head}),"GIT_BRANCH\t".git_value(q{branch}),q{});
}
sub begin_normal_lease {
 my($p)=@_;my $c="$CONTROL/normal-lease.candidate";my $target="$CONTROL/active_normal_lease.tsv";no_entry($c)&&no_entry($target) or die "normal attempt already present\n";
 sysopen(my $h,$c,O_WRONLY|O_CREAT|O_EXCL|O_NOFOLLOW,0600) or die "normal attempt boundary\n";sync_dir($CONTROL);chmod(0600,$c)==1 or die "lease mode\n";my $text=lease_text($p,q{NORMAL});binmode($h);print {$h}$text or die "lease write\n";sync_file($h);close($h) or die "lease close\n";publish_existing_candidate($c,$target,$text);return $text;
}
sub archive_normal {
 my($p)=@_;my $active="$CONTROL/active_normal_lease.tsv";my $archive="$LEASES/$p.lease.tsv";my $a=inspect_path($active);$a->{state} eq q{FILE} or die "active lease missing\n";
 if(no_entry($archive)){link($active,$archive) or die "archive link\n";sync_dir($LEASES);}my $z=inspect_path($archive);$z->{state} eq q{FILE}&&$z->{sha} eq $a->{sha}&&$z->{inode} eq $a->{inode} or die "archive mismatch\n";
}
sub run_command {
 my($p,$stdout,$stderr,$argv,$extra)=@_;my $oc=candidate_path($p,q{RAW_STDOUT});my $ec=candidate_path($p,q{RAW_STDERR});no_entry($oc)&&no_entry($ec)&&no_entry($stdout)&&no_entry($stderr) or die "raw output precondition\n";
 sysopen(my $oh,$oc,O_WRONLY|O_CREAT|O_EXCL|O_NOFOLLOW,0600) or die "stdout candidate\n";sync_dir($TMP);chmod(0600,$oc)==1 or die "stdout mode\n";binmode($oh);
 sysopen(my $eh,$ec,O_WRONLY|O_CREAT|O_EXCL|O_NOFOLLOW,0600) or die "stderr candidate\n";sync_dir($TMP);chmod(0600,$ec)==1 or die "stderr mode\n";binmode($eh);
 my $pid=fork();defined($pid) or die "payload fork\n";
 if($pid==0){open(STDOUT,q{>&},$oh) or die "stdout dup\n";open(STDERR,q{>&},$eh) or die "stderr dup\n";close($oh);close($eh);%ENV=(HOME=>q{/Users/MoiTam},ELAN_HOME=>q{/Users/MoiTam/.elan},PATH=>q{/Users/MoiTam/.elan/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin},LC_ALL=>q{C},LANG=>q{C},TMPDIR=>$TMP,%$extra);exec {$argv->[0]}@$argv or die "payload exec\n";}
 my $waited;while(1){$waited=waitpid($pid,0);last if $waited==$pid;next if $waited<0&&$! == EINTR;die "payload wait\n";}my $raw_status=$?;sync_file($oh);sync_file($eh);close($oh) or die "stdout close\n";close($eh) or die "stderr close\n";my $ob=slurp($oc);my $eb=slurp($ec);publish_existing_candidate($oc,$stdout,$ob);publish_existing_candidate($ec,$stderr,$eb);return(($raw_status&127)?128+($raw_status&127):($raw_status>>8));
}
sub empty_raw {
 my($p,$stdout,$stderr)=@_;publish_text($p,q{RAW_STDOUT},$stdout,q{});publish_text($p,q{RAW_STDERR},$stderr,q{});return 0;
}
sub tree_snapshot {
 my($base)=@_;my %v;return \%v if no_entry($base);my @todo=($base);
 while(@todo){my $d=shift @todo;my @ds=lstat($d);@ds&&S_ISDIR($ds[2])&&!S_ISLNK($ds[2]) or die "snapshot directory\n";opendir(my $h,$d) or die "snapshot opendir\n";my @n=sort{$a cmp $b}grep{$_ ne q{.}&&$_ ne q{..}}readdir($h);closedir($h) or die "snapshot closedir\n";for my $n(@n){my $p="$d/$n";my $s=inspect_path($p);if($s->{state} eq q{NONCANONICAL}&&$s->{kind} eq q{DIRECTORY}){$v{$p}=q{DIRECTORY:}.$s->{mode};push @todo,$p;}else{$v{$p}=join(q{:},$s->{state},$s->{sha}//q{-},$s->{bytes}//q{-},$s->{kind}//q{-},$s->{detail}//q{-});}}}
 return \%v;
}
sub changed_paths {my($pre,$post)=@_;my %k=map{$_=>1}(keys%$pre,keys%$post);return sort{$a cmp $b}grep{($pre->{$_}//q{ABSENT}) ne ($post->{$_}//q{ABSENT})}keys%k;}
sub lake_state {my($p)=@_;my $s=inspect_path(abs_path($p));return[$s->{state},$s->{state} eq q{FILE}?$s->{sha}:q{-},$s->{state} eq q{FILE}?$s->{bytes}:q{-}];}
sub lake_delta_text {
 my($p,$before_allowed,$project_pre,$package_pre,$sys_pre,$project_post,$package_post,$sys_post)=@_;my @allow=lake_paths($p);my $after_allowed={map{$_=>lake_state($_)}@allow};my @project_changed=changed_paths($project_pre,$project_post);my %allowed_abs=map{"$ROOT/$_"=>1}@allow;
 for my $x(@project_changed){$allowed_abs{$x} or die "unrelated project Lake delta $x\n";}my @package_changed=changed_paths($package_pre,$package_post);my @sys_changed=changed_paths($sys_pre,$sys_post);@package_changed==0&&@sys_changed==0 or die "package or sysroot delta\n";
 my @changed=grep{join(q{:},@{$before_allowed->{$_}}) ne join(q{:},@{$after_allowed->{$_}})}@allow;for my $x(@allow){$after_allowed->{$x}[0] eq q{FILE} or die "missing allowed Lake artifact $x\n";}
 my $t="F3_EVIDENCE_V2\tF3_LAKE_DELTA_V1\n";my $i=1;for my $m([PHASE=>$p],[ALLOWED_PATH_COUNT=>scalar(@allow)],[CHANGED_PATH_COUNT=>scalar(@changed)],[PACKAGE_DELTA_COUNT=>0],[SYSROOT_DELTA_COUNT=>0]){$t.=sprintf("META\t%04d\t%s\t%s\n",$i++,@$m);}for my $x(@changed){$t.=sprintf("DELTA\t%04d\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n",$i++,@{$before_allowed->{$x}},@{$after_allowed->{$x}},$x);}return($t,scalar(@allow),scalar(@changed));
}
sub ensure_no_tree_delta {my($a,$b,$label)=@_;my @c=changed_paths($a,$b);@c==0 or die "$label delta\n";}
sub dependency_roots {
 my($p)=@_;my @names;if($p eq q{B0}){@names=qw(F3ReturnExcursionBlock0MassDemandProfileSharded F3ReturnExcursionBlock0MassDemandProfileShardedAxiomAudit F3ReturnExcursionBlock0ReverseBFSMassIntegration F3ReturnExcursionBlock0ReverseBFSAxiomAudit F3ReturnExcursionBlock0SemanticChildBaseHit F3ReturnExcursionBlock0SemanticChildBaseHitAxiomAudit F3ReturnExcursionBlock0ReverseBFSCompleteness F3ReturnExcursionBlock0ReverseBFSCompletenessAxiomAudit);}elsif($p eq q{R0}){@names=qw(F3ReturnExcursionBlock0ReverseBFSPilotRowsV3 F3ReturnExcursionBlock0ReverseBFSPilotGenerateV3);}elsif($p eq q{V0}){@names=qw(F3ReturnExcursionBlock0ReverseBFSPilotPayloadsV3 F3ReturnExcursionBlock0ReverseBFSPilotV3);}elsif($p eq q{A0}){@names=qw(F3ReturnExcursionBlock0ReverseBFSPilotV3AxiomAudit);}else{die "no dependency roots\n";}return map{"$ROOT/CollatzClassical/KL2003/$_.lean"}@names;
}
sub lexical_path {
 my($p)=@_;$p="$ROOT/$p" if index($p,q{/})!=0;$p=~/\A\/[\x20-\x7e]+\z/&&index($p,"\t")<0 or die "dependency path bytes\n";my @o=split m{/},substr($p,1),-1;@o&&!(grep{$_ eq q{}||$_ eq q{.}||$_ eq q{..}}@o) or die "dependency path segments\n";my $canonical=q{/}.join(q{/},@o);$canonical eq $p or die "dependency lexical canonicality\n";my $cur=q{};for my $i(0..$#o-1){$cur.=q{/}.$o[$i];my @s=lstat($cur);@s&&S_ISDIR($s[2])&&!S_ISLNK($s[2]) or die "dependency ancestry $cur\n";}return $canonical;
}
sub make_dependencies {
 my($p,$raw)=@_;index($raw,"\r")<0 or die "dependency CR\n";my @roots=dependency_roots($p);my @lines=split /\n/,$raw,-1;pop @lines if @lines&&$lines[-1] eq q{};my $first=-1;for my $i(0..$#lines){if(index($lines[$i],"@@F3_DEPS_ROOT\t")==0){$first=$i;last;}}$first>=0 or die "dependency delimiter absent\n";my @dep=@lines[$first..$#lines];my @objects;my %seen;my $ri=0;my $line_count=0;
 for my $line(@dep){if(index($line,"@@F3_DEPS_ROOT\t")==0){$ri++;my $hex=unpack(q{H*},$roots[$ri-1]//q{});$line eq "@@F3_DEPS_ROOT\t".sprintf(q{%04d},$ri)."\t$hex@@" or die "dependency delimiter mismatch\n";next;}$ri>0&&length($line)>0&&$line=~/\.olean\z/ or die "non-path dependency output\n";$line_count++;my $o=lexical_path($line);my @members=(index($o,"$ROOT/.lake/build/")==0,index($o,"$ROOT/.lake/packages/")==0,index($o,q{/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/lib/lean/})==0);my $count=grep{$_}@members;$count==1 or die "dependency root ambiguity\n";my $s=inspect_path($o);$s->{state} eq q{FILE} or die "dependency object state\n";push @objects,$o unless $seen{$o}++;}
 $ri==@roots or die "dependency root count\n";for my $src(@roots){my $r=$src;$r=~s{^\Q$ROOT\E/}{.lake/build/lib/lean/};$r=~s{\.lean\z}{.olean};my $a="$ROOT/$r";$seen{$a} or die "declared root absent from trace\n";}
 my($project,$package,$sys)=(0,0,0);for my $o(@objects){if(index($o,"$ROOT/.lake/packages/")==0){$package++;}elsif(index($o,"$ROOT/.lake/build/")==0){$project++;}else{$sys++;}}
 my $trace="F3_EVIDENCE_V2\tF3_LOADED_OBJECT_TRACE_V1\n";my $i=1;for my $m([PHASE=>$p],[ROOT_COUNT=>$ri],[DEPENDENCY_LINE_COUNT=>$line_count],[UNIQUE_OBJECT_COUNT=>scalar(@objects)],[PROJECT_OBJECT_COUNT=>$project],[PACKAGE_OBJECT_COUNT=>$package],[SYSROOT_OBJECT_COUNT=>$sys]){$trace.=sprintf("META\t%04d\t%s\t%s\n",$i++,@$m);}for my $o(@objects){my $s=inspect_path($o);$trace.=sprintf("OBJECT\t%04d\t%s\t%d\t%s\n",$i++,$s->{sha},$s->{bytes},$o);}my $deps=join("\n",@dep)."\n";return($deps,$trace,$ri,$line_count,scalar(@objects));
}
sub dependency_root_segment_paths {
 my($p,$wanted,$raw)=@_;index($raw,"\r")<0&&index($raw,"\0")<0 or die "dependency segment encoding\n";my @roots=dependency_roots($p);$wanted>=1&&$wanted<=@roots or die "dependency segment root index\n";my @lines=split /\n/,$raw,-1;pop @lines if @lines&&$lines[-1] eq q{};@lines&&index($lines[0],"@@F3_DEPS_ROOT\t")==0 or die "dependency segment first delimiter\n";my $ri=0;my %seen;my @selected;for my $line(@lines){if(index($line,"@@F3_DEPS_ROOT\t")==0){$ri++;my $hex=unpack(q{H*},$roots[$ri-1]//q{});$line eq "@@F3_DEPS_ROOT\t".sprintf(q{%04d},$ri)."\t$hex@@" or die "dependency segment delimiter\n";next;}$ri>0&&length($line)>0&&$line=~/\.olean\z/ or die "dependency segment non-path\n";my $o=lexical_path($line);my @members=(index($o,"$ROOT/.lake/build/")==0,index($o,"$ROOT/.lake/packages/")==0,index($o,q{/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/lib/lean/})==0);(grep{$_}@members)==1 or die "dependency segment root ambiguity\n";inspect_path($o)->{state} eq q{FILE} or die "dependency segment object state\n";push @selected,$o if $ri==$wanted&&!$seen{$o}++;}$ri==@roots or die "dependency segment root count\n";@selected or die "empty dependency segment\n";return @selected;
}
sub outcome_rows {
 my @r;my @d=(2,1,2,1,2,1);my @id=qw(FIXED_ROW_01_RET_D2 FIXED_ROW_02_RET_D1 FIXED_ROW_03_DIRECT_D2 FIXED_ROW_04_DIRECT_D1 FIXED_ROW_05_LIFT_D2 FIXED_ROW_06_LIFT_D1);
 for my $n(1..6){my $p=sprintf("$FRAGMENTS/row_%02d.canonical_fragment.lean",$n);my $b=slurp($p);my $def=sprintf(q{fixedRow%02dCertificate},$n);$b=~/\Adef \Q$def\E : F3Block0ReverseBFSData\.ReverseBFSCertificate :=\n/s or die "fragment declaration\n";my @k=($b=~/kind := \.(saturated|deficient)/g);@k==1 or die "fragment kind cardinality\n";my $m=()=$b=~/parentIndex :=/g;my @claim=($b=~/claimedDemand := ([0-9]+)/g);@claim==1&&$claim[0]==$d[$n-1] or die "fragment demand\n";push @r,{index=>$n,id=>$id[$n-1],demand=>$d[$n-1],kind=>$k[0] eq q{saturated}?q{SATURATED}:q{DEFICIENT},m=>$m,sha=>sha256_hex($b)};}return @r;
}
sub coverage_text {my @r=outcome_rows();my $t="F3_CHECKER_COVERAGE_V1\n";for my $r(@r){$t.=join("\t",$r->{id},sprintf(q{fixedRow%02d_check},$r->{index}),sprintf(q{fixedRow%02d_outcome},$r->{index}),$r->{kind},$r->{m},$r->{demand},$r->{sha})."\n";}return $t;}
sub validate_axiom_list {
 my($list,$internal)=@_;my $x=$list;$x=~s/\s+//g;$x=~/\A(?:[A-Za-z0-9_.]+(?:,[A-Za-z0-9_.]+)*)?\z/ or die "axiom list grammar\n";my @a=length($x)?split(q{,},$x):();my %allowed=map{$_=>1}qw(propext Classical.choice Quot.sound);$allowed{lcProof}=1 if $internal;my %seen;for my $a(@a){$allowed{$a} or die "forbidden axiom $a\n";$seen{$a}++ and die "duplicate axiom\n";}return join(q{,},sort{$a cmp $b}@a);
}
sub audit_outputs {
 my($stdout,$stderr)=@_;my @streams=($stdout,$stderr);for my $raw(@streams){index($raw,"\0")<0&&index($raw,"\r")<0 or die "A0 output encoding\n";$raw!~/(?:Lean\.ofReduceBool|Lean\.trustCompiler|sorryAx|ABSOLUTELY_FORBIDDEN_AXIOM|UNEXPECTED_AXIOM_PROFILE|INVENTORY_(?:SIZE_MISMATCH|EMPTY|DUPLICATE)|DECLARATION_MISSING|UNEXPECTED_STABLE_DECLARATION|ORPHANED_INTERNAL_DETAIL|(?:^|\n)[^\n]*\berror:)/i or die "A0 forbidden/error marker\n";}
 my $rows_ns=q{CollatzClassical.KL2003.F3Block0ReverseBFSPilotRowsV3};my $payload_ns=q{CollatzClassical.KL2003.F3Block0ReverseBFSPilotPayloadsV3};my $pilot_ns=q{CollatzClassical.KL2003.F3Block0ReverseBFSPilotV3};
 my @rows_source=map{"$rows_ns.$_"}qw(FixedPilotRowV3 fixedRow01 fixedRow02 fixedRow03 fixedRow04 fixedRow05 fixedRow06 fixedRow01_coordinates fixedRow02_coordinates fixedRow03_coordinates fixedRow04_coordinates fixedRow05_coordinates fixedRow06_coordinates);
 my @payload_source=map{"$payload_ns.$_"}qw(fixedRow01Certificate fixedRow02Certificate fixedRow03Certificate fixedRow04Certificate fixedRow05Certificate fixedRow06Certificate);
 my @pilot_source=map{"$pilot_ns.$_"}qw(VerifiedTypedReverseBFSOutcome verifiedTypedReverseBFSOutcome_of_check fixedRow01_check fixedRow02_check fixedRow03_check fixedRow04_check fixedRow05_check fixedRow06_check fixedRow01_outcome fixedRow02_outcome fixedRow03_outcome fixedRow04_outcome fixedRow05_outcome fixedRow06_outcome);
 my @rows_generated=map{"$rows_ns.$_"}(qw(FixedPilotRowV3.mk FixedPilotRowV3.order FixedPilotRowV3.canonicalId FixedPilotRowV3.legacyRowId FixedPilotRowV3.occurrence FixedPilotRowV3.rec FixedPilotRowV3.recOn FixedPilotRowV3.casesOn FixedPilotRowV3.noConfusionType.withCtorType FixedPilotRowV3.noConfusionType.withCtor FixedPilotRowV3.noConfusionType FixedPilotRowV3.noConfusion FixedPilotRowV3.mk.inj FixedPilotRowV3.mk.injEq FixedPilotRowV3.mk.sizeOf_spec));
 my @pilot_generated=map{"$pilot_ns.$_"}qw(VerifiedTypedReverseBFSOutcome.saturated VerifiedTypedReverseBFSOutcome.deficient VerifiedTypedReverseBFSOutcome.rec VerifiedTypedReverseBFSOutcome.recOn VerifiedTypedReverseBFSOutcome.casesOn);
 my @source=(@rows_source,@payload_source,@pilot_source);my @stable=(@source,@rows_generated,@pilot_generated);@source==33&&@stable==53 or die "embedded A0 inventory cardinality\n";my %stable=map{$_=>1}@stable;
 my(@print_by_stream,%print_axioms);for my $raw(@streams){my @records;while($raw=~/'([^']+)'\s+(depends on axioms:\s*\[(.*?)\]|does not depend on any axioms)/sg){my($name,$form,$list)=($1,$2,$3);exists($print_axioms{$name}) and die "duplicate #print axiom record\n";$print_axioms{$name}=validate_axiom_list(defined($list)?$list:q{},0);push @records,$name;}push @print_by_stream,\@records;}my $print_stream=@{$print_by_stream[0]}?0:1;@{$print_by_stream[$print_stream]}==33&&@{$print_by_stream[1-$print_stream]}==0 or die "A0 #print stream/cardinality\n";for my $i(0..32){$print_by_stream[$print_stream][$i] eq $source[$i] or die "A0 #print order\n";}
 my(@public_records,@internal_records,%public_seen,%internal_seen,%profile_namespace_count);for my $raw(@streams){while($raw=~/((PUBLIC_STABLE|INTERNAL_DETAIL)_AXIOM_PROFILE\t([^\t\n]+)\t\[(.*?)\])/sg){my($record,$kind,$name,$list)=($1,$2,$3,$4);my $internal=$kind eq q{INTERNAL_DETAIL};my $normalized=validate_axiom_list($list,$internal);my @membership=(index($name,"$rows_ns.")==0,index($name,"$payload_ns.")==0,index($name,"$pilot_ns.")==0);my $members=grep{$_}@membership;$members==1 or die "profile namespace membership\n";$profile_namespace_count{$membership[0]?$rows_ns:$membership[1]?$payload_ns:$pilot_ns}++;if($internal){!$stable{$name}&&!$public_seen{$name} or die "internal/public profile collision\n";$internal_seen{$name}++ and die "duplicate internal profile\n";my $desc=grep{index($name,"$_.")==0}@stable;$desc>0 or die "orphan internal profile\n";push @internal_records,$record;}else{!$internal_seen{$name} or die "public/internal profile collision\n";$public_seen{$name}++ and die "duplicate public profile\n";$stable{$name} or die "unexpected public profile\n";if(exists($print_axioms{$name})){$print_axioms{$name} eq $normalized or die "#print/profile axiom mismatch\n";}push @public_records,$record;}}}
 @public_records==53&&keys(%public_seen)==53 or die "public profile coverage\n";for my $name(@stable){$public_seen{$name}==1 or die "missing public profile\n";}my $k=scalar(@internal_records);my $total=53+$k;
 my @namespaces;for my $raw(@streams){while($raw=~/(NAMESPACE_DECLARATION_COUNT\t([^\t\n]+)\t(0|[1-9][0-9]*))/g){push @namespaces,[$1,$2,0+$3];}}@namespaces==3 or die "namespace record cardinality\n";my @ns_expected=($rows_ns,$payload_ns,$pilot_ns);for my $i(0..2){$namespaces[$i][1] eq $ns_expected[$i]&&$namespaces[$i][2]==($profile_namespace_count{$ns_expected[$i]}//0) or die "namespace record/order/count\n";}my($nr,$np,$nv)=map{$_->[2]}@namespaces;$nr>=28&&$np>=6&&$nv>=19&&$nr+$np+$nv==$total or die "namespace counts\n";
 my @coverage_expected=(q{PUBLIC_SOURCE_DECLARATION_COVERAGE=33/33},q{STABLE_GENERATED_DECLARATION_COVERAGE=20/20},q{EXPECTED_STABLE_DECLARATION_COVERAGE=53/53},"INTERNAL_DETAIL_DECLARATION_COVERAGE=$k/$k","COMPLETE_ACTUAL_DECLARATION_COVERAGE=$total/$total");my @coverage;for my $raw(@streams){while($raw=~/((?:PUBLIC_SOURCE|STABLE_GENERATED|EXPECTED_STABLE|INTERNAL_DETAIL|COMPLETE_ACTUAL)_DECLARATION_COVERAGE=[0-9]+\/[0-9]+)/g){push @coverage,$1;}}@coverage==5 or die "coverage record cardinality\n";for my $i(0..4){$coverage[$i] eq $coverage_expected[$i] or die "coverage record/order\n";}
 my $pass_count=0;my $pass_stream=-1;for my $i(0,1){my $n=()=$streams[$i]=~/F3_R3_REVERSE_BFS_PILOT_V3_AXIOM_AUDIT_PASS/g;$pass_count+=$n;$pass_stream=$i if $n;}$pass_count==1 or die "A0 PASS cardinality\n";my $last_record=q{COMPLETE_ACTUAL_DECLARATION_COVERAGE=}.$total.q{/}.$total;index($streams[$pass_stream],$last_record)>=0&&rindex($streams[$pass_stream],q{F3_R3_REVERSE_BFS_PILOT_V3_AXIOM_AUDIT_PASS})>rindex($streams[$pass_stream],$last_record) or die "A0 PASS order\n";
 my $public="F3_PUBLIC_DECLARATION_COVERAGE_V1\n".join("\n",(map{$_->[0]}@namespaces),@coverage_expected,q{F3_R3_REVERSE_BFS_PILOT_V3_AXIOM_AUDIT_PASS})."\n";my $profiles="F3_AXIOM_PROFILE_COVERAGE_V1\n".join("\n",@public_records,@internal_records)."\n";return($public,$profiles);
}
sub phase_candidates {
 my($p)=@_;
 return qw(INPUT RAW_STDOUT RAW_STDERR EXIT_STATUS RESOURCE LAKE_ENVIRONMENT DEPENDENCIES LOADED_OBJECTS LAKE_DELTA MEMORY_VM_STAT MEMORY_RSS_MEMBERS MEMORY_RSS_SUMMARY MEMORY_GUARD_RECEIPT OUTPUT TERMINAL) if $p eq q{B0}||$p eq q{R0};
 return qw(INPUT RAW_STDOUT RAW_STDERR EXIT_STATUS SPECIAL PRE_ENVIRONMENT PRE_COMMANDS PRE_OBJECTS PRE_STATUS OUTPUT TERMINAL) if $p eq q{P0};
 return qw(INPUT RAW_STDOUT RAW_STDERR EXIT_STATUS RESOURCE LAKE_ENVIRONMENT FRAGMENT MEMORY_VM_STAT MEMORY_RSS_MEMBERS MEMORY_RSS_SUMMARY MEMORY_GUARD_RECEIPT OUTPUT TERMINAL) if $p=~/\AG0[1-6]\z/;
 return qw(INPUT RAW_STDOUT RAW_STDERR EXIT_STATUS OUTPUT TERMINAL PAYLOAD_SOURCE) if $p eq q{S0};
 return qw(INPUT RAW_STDOUT RAW_STDERR EXIT_STATUS SPECIAL OUTPUT TERMINAL) if $p eq q{P1};
 return qw(INPUT RAW_STDOUT RAW_STDERR EXIT_STATUS RESOURCE LAKE_ENVIRONMENT DEPENDENCIES LOADED_OBJECTS LAKE_DELTA COVERAGE MEMORY_VM_STAT MEMORY_RSS_MEMBERS MEMORY_RSS_SUMMARY MEMORY_GUARD_RECEIPT OUTPUT TERMINAL) if $p eq q{V0};
 return qw(INPUT RAW_STDOUT RAW_STDERR EXIT_STATUS RESOURCE LAKE_ENVIRONMENT DEPENDENCIES LOADED_OBJECTS LAKE_DELTA PUBLIC_DECLARATIONS AXIOM_PROFILES MEMORY_VM_STAT MEMORY_RSS_MEMBERS MEMORY_RSS_SUMMARY MEMORY_GUARD_RECEIPT OUTPUT TERMINAL) if $p eq q{A0};
 return qw(INPUT RAW_STDOUT RAW_STDERR EXIT_STATUS SPECIAL OUTPUT TERMINAL REPORT REPORT_CUSTODY) if $p eq q{F0};die "candidate phase\n";
}
sub preterminal_results {
 my($p)=@_;my @r=@{$phase_paths{$p}};my %drop=("$p.outputs.sha256"=>1,$terminal{$p}=>1);$drop{q{F3_R3_REVERSE_BFS_PILOT_V3_RUN_REPORT.md}}=1;$drop{q{F0_report_custody_receipt.sha256}}=1;@r=grep{!$drop{$_}}@r;push @r,rel($PAYLOAD) if $p eq q{S0};return map{index($_,q{/})==0?$_:rel("$RESULT/$_")}@r;
}
sub all_publication_candidate_paths {my @r;for my $p(@normal){push @r,map{rel(candidate_path($p,$_))}phase_candidates($p);}push @r,rel(candidate_path(q{C0},q{INVALID_MANIFEST})),rel(candidate_path(q{C0},q{INVALID_REPORT}));return @r;}
sub all_candidate_paths {return(rel("$CONTROL/normal-lease.candidate"),rel("$CONTROL/c0-lease.candidate"),rel("$CONTROL/contention.candidate"),all_publication_candidate_paths());}
sub directory_seed_paths {
 my @u=(authority_paths(),@seven_inputs,phase_sources(q{F0}),@run_inputs,@tools,@frozen_build_prestate,@generated_source_baseline_files,rel($PAYLOAD),control_paths(),all_candidate_paths());for my $p(@normal){push @u,map{rel("$RESULT/$_")}@{$phase_paths{$p}};push @u,lake_paths($p);}return stable_unique(@u);
}
sub unexpected_rows {
 my($known)=@_;my $source_root="$ROOT/CollatzClassical/KL2003";my %known_file=map{abs_path($_)=>1}(@$known,@generated_source_baseline_files);my %known_dir=map{$_=>1}($RESULT,"$ROOT/.lake/build",$source_root);for my $p(map{abs_path($_)}directory_seed_paths()){my $d=$p;while(($d=substr($d,0,rindex($d,q{/}))) ne q{}&&($d eq $RESULT||index($d,"$RESULT/")==0||$d eq "$ROOT/.lake/build"||index($d,"$ROOT/.lake/build/")==0||$d eq $source_root||index($d,"$source_root/")==0)){$known_dir{$d}=1;}}
 my @unexpected;for my $base($RESULT,"$ROOT/.lake/build",$source_root){my $base_state=inspect_path($base);next if $base_state->{state} eq q{ABSENT};if(!($base_state->{state} eq q{NONCANONICAL}&&$base_state->{kind} eq q{DIRECTORY})){push @unexpected,[$base,$base_state] unless $known_file{$base};next;}my @todo=($base);while(@todo){my $d=shift@todo;my $ds=inspect_path($d);if(!opendir(my $h,$d)){my $unreadable={state=>q{NONCANONICAL},kind=>q{UNREADABLE},mode=>$ds->{mode}//q{-},detail=>sha256_hex("opendir:$d:$!")};push @unexpected,[$d,$unreadable];next;}push @unexpected,[$d,$ds] if $d ne $base&&!$known_dir{$d};my @n=sort{$a cmp $b}grep{$_ ne q{.}&&$_ ne q{..}}readdir($h);unless(closedir($h)){my $unreadable={state=>q{NONCANONICAL},kind=>q{UNREADABLE},mode=>$ds->{mode}//q{-},detail=>sha256_hex("closedir:$d:$!")};push @unexpected,[$d,$unreadable] if $known_dir{$d};next;}for my $n(@n){my $p="$d/$n";my $s=inspect_path($p);if($s->{state} eq q{NONCANONICAL}&&$s->{kind} eq q{DIRECTORY}){push@todo,$p;}elsif(!$known_file{$p}||$s->{state} ne q{FILE}){push@unexpected,[$p,$s];}}}}
 my @rows;for my $u(sort{$a->[0] cmp $b->[0]}@unexpected){my($p,$s)=@$u;my $hex=unpack(q{H*},rel($p));if($s->{state} eq q{FILE}){push @rows,sprintf("UNEXPECTED_FILE\t__INDEX__\t%s\t%d\t%s\n",$s->{sha},$s->{bytes},$hex);}else{push @rows,sprintf("UNEXPECTED_NONCANONICAL\t__INDEX__\t%s\t%s\t%s\t%s\n",$s->{kind},$s->{mode},$s->{detail},$hex);}}return @rows;
}
sub output_manifest {
 my($p,$result,$metrics)=@_;my $pass=$result eq q{PASS};my @pre=preterminal_results($p);my @lake=lake_paths($p);my @cand=map{[$_,$pass?q{ABSENT}:q{CENSUS}]}all_publication_candidate_paths();my @control=control_specs($pass?q{LOCKED_PRETERMINAL_POST_ARCHIVE}:q{FAILURE_LOCKED_CENSUS},$p);my @spec=((map{[$_,$pass?q{FILE}:q{CENSUS}]}@pre),(map{[$_,$pass?q{FILE}:q{CENSUS}]}@lake),@cand,@control);my @known=normal_known_universe($p,q{OUTPUT});my @tail=unexpected_rows(\@known);@tail==0 or !$pass or die "unexpected path on PASS\n";
 my @m=([PHASE=>$p],[ATTEMPT=>1],[RESULT=>$result],[RESULT_PATH_COUNT=>scalar(@pre)],[LAKE_ALLOWED_COUNT=>scalar(@lake)],[LAKE_CHANGED_COUNT=>$metrics->{lake_changed}//0],[PACKAGE_DELTA_COUNT=>$metrics->{package_delta}//0],[SYSROOT_DELTA_COUNT=>$metrics->{sysroot_delta}//0],[ROOT_COUNT=>$metrics->{roots}//0],[DEPENDENCY_LINE_COUNT=>$metrics->{dep_lines}//0],[UNIQUE_OBJECT_COUNT=>$metrics->{objects}//0],[CONTROL_COUNT=>23],[CONTROL_VECTOR_SHA256=>vector_hash(\@control)],[CONTROL_CAPTURE=>$pass?q{LOCKED_PRETERMINAL_POST_ARCHIVE}:q{FAILURE_LOCKED_CENSUS}]);return typed_evidence(q{F3_OUTPUT_MANIFEST_V1},\@m,\@spec,\@tail);
}
sub terminal_specs {
 my($p,$failure)=@_;my @local=preterminal_results($p);@local=grep{$_ ne rel("$RESULT/$p.inputs.sha256")}@local;return([$p eq q{F0}?rel("$RESULT/F0.inputs.sha256"):rel("$RESULT/$p.inputs.sha256"),q{FILE}],[$p eq q{F0}?rel("$RESULT/F0.outputs.sha256"):rel("$RESULT/$p.outputs.sha256"),q{FILE}],map{[$_,$failure?q{CENSUS}:q{FILE}]}@local);
}
our $command_sha=q{};
sub terminal_receipt {
 my($p,$result,$exit,$extra,$failure)=@_;my $pred_names=@{$pred{$p}}?join(q{,},@{$pred{$p}}):q{NONE};my $pred_hashes=@{$pred{$p}}?join(q{,},map{sha_file(receipt_path($_))}@{$pred{$p}}):q{NONE};my @m=([PHASE=>$p],[ATTEMPT=>1],[RESULT=>$result],[GIT_HEAD=>git_value(q{head})],[GIT_BRANCH=>git_value(q{branch})],[PREDECESSOR_PHASES=>$pred_names],[PREDECESSOR_RECEIPT_SHA256S=>$pred_hashes],[COMMAND_SHA256=>$command_sha],[CWD=>$ROOT],[LC_ALL=>q{C}],[LANG=>q{C}],[WALL_LIMIT_SECONDS=>$ceiling{$p}],[EXIT_STATUS=>$exit],[START_UTC=>$start_utc],[END_UTC=>scalar(gmtime()).q{Z}],[PRE_REVALIDATION=>q{PASS}],[POST_REVALIDATION=>q{PASS}],[INPUT_MANIFEST_SHA256=>sha_file("$RESULT/$p.inputs.sha256")],[OUTPUT_MANIFEST_SHA256=>sha_file("$RESULT/$p.outputs.sha256")]);push @m,@$extra if $extra;my @s=terminal_specs($p,$failure);return typed_evidence($p eq q{F0}&&$extra&&@$extra?q{F3_F0_TERMINAL_RECEIPT_V1}:q{F3_PHASE_TERMINAL_RECEIPT_V1},\@m,\@s,[]);
}
sub special_manifest {
 my($p)=@_;my @control=control_specs(q{LOCKED_SPECIAL_PREARCHIVE},$p);
 if($p eq q{P0}){my @src=(phase_sources($p),@run_inputs[1,2]);my @obj=p0_resolved_objects();my @trans=($run_inputs[0],(map{rel(receipt_path($_)),rel("$RESULT/$_.outputs.sha256")}qw(B0 R0)),authority_paths(),@seven_inputs,@src,@obj);@trans=stable_unique(@trans);my @trans_specs=map{[$_,q{FILE}]}@trans;my @spec=(@trans_specs,@control);my @m=([PHASE=>q{P0}],[PREDECESSOR_PHASES=>q{B0,R0}],[PREDECESSOR_RECEIPT_SHA256S=>join(q{,},map{sha_file(receipt_path($_))}qw(B0 R0))],[AUTHORITY_COUNT=>7],[SEVEN_INPUT_COUNT=>7],[SOURCE_COUNT=>scalar(@src)],[OBJECT_COUNT=>scalar(@obj)],[TRANSITIVE_FILE_COUNT=>scalar(@trans)],[TRANSITIVE_VECTOR_SHA256=>vector_hash(\@trans_specs)],[CONTROL_COUNT=>23],[CONTROL_VECTOR_SHA256=>vector_hash(\@control)],[CONTROL_CAPTURE=>q{LOCKED_SPECIAL_PREARCHIVE}]);return typed_evidence(q{F3_PRE_GENERATION_MANIFEST_V1},\@m,\@spec,[]);}
 if($p eq q{P1}){my @chain=qw(P0 G01 G02 G03 G04 G05 G06 S0);my @rowchain=qw(G01 G02 G03 G04 G05 G06 S0);my @fr=map{rel("$FRAGMENTS/".sprintf(q{row_%02d.canonical_fragment.lean},$_))}1..6;my @build=map{[$_,q{ABSENT}]}(lake_paths(q{V0}),lake_paths(q{A0}));my @trans=(rel("$RESULT/pre_generation_manifest.sha256"),(map{(rel(receipt_path($_)),rel("$RESULT/$_.outputs.sha256"))}@rowchain),@fr,rel($PAYLOAD));my @trans_specs=map{[$_,q{FILE}]}@trans;my @vector_specs=(@trans_specs,@build);my @spec=(@vector_specs,@control);my @m=([PHASE=>q{P1}],[PREDECESSOR_PHASES=>join(q{,},@chain)],[PREDECESSOR_RECEIPT_SHA256S=>join(q{,},map{sha_file(receipt_path($_))}@chain)],[FRAGMENT_COUNT=>6],[PAYLOAD_SHA256=>sha_file($PAYLOAD)],[BUILD_PRESTATE_COUNT=>scalar(@build)],[TRANSITIVE_FILE_COUNT=>scalar(@trans)],[TRANSITIVE_VECTOR_SHA256=>vector_hash(\@vector_specs)],[CONTROL_COUNT=>23],[CONTROL_VECTOR_SHA256=>vector_hash(\@control)],[CONTROL_CAPTURE=>q{LOCKED_SPECIAL_PREARCHIVE}]);return typed_evidence(q{F3_POST_GENERATION_MANIFEST_V1},\@m,\@spec,[]);}
 if($p eq q{F0}){my @earlier=@normal[0..12];my @trans=((map{rel(receipt_path($_))}@earlier),(map{rel("$RESULT/$_.outputs.sha256")}@earlier),rel($PAYLOAD),lake_paths(q{V0}),lake_paths(q{A0}),rel("$RESULT/V0.checker_coverage.tsv"),rel("$RESULT/A0.public_declarations.tsv"),rel("$RESULT/A0.axiom_profiles.tsv"));@trans=stable_unique(@trans);my @trans_specs=map{[$_,q{FILE}]}@trans;my @spec=(@trans_specs,@control);my @m=([PHASE=>q{F0}],[PREDECESSOR_PHASES=>join(q{,},@earlier)],[PREDECESSOR_RECEIPT_SHA256S=>join(q{,},map{sha_file(receipt_path($_))}@earlier)],[PREDECESSOR_PHASE_COUNT=>13],[TERMINAL_RECEIPT_COUNT=>13],[TRANSITIVE_FILE_COUNT=>scalar(@trans)],[TRANSITIVE_VECTOR_SHA256=>vector_hash(\@trans_specs)],[VERDICT_INPUT_COUNT=>3],[CONTROL_COUNT=>23],[CONTROL_VECTOR_SHA256=>vector_hash(\@control)],[CONTROL_CAPTURE=>q{LOCKED_SPECIAL_PREARCHIVE}]);return typed_evidence(q{F3_FINAL_ARTIFACTS_MANIFEST_V1},\@m,\@spec,[]);}
 die "no special manifest\n";
}
sub line_count {my($p)=@_;my $b=slurp($p);my $n=()=$b=~/\n/g;return $n;}
sub replace_literal {my($textref,$old,$new)=@_;my $n=()=$$textref=~/\Q$old\E/g;$n==1 or die "template literal cardinality\n";$$textref=~s/\Q$old\E/$new/;}
sub fill_placeholders {
 my($textref,$map)=@_;for my $k(keys%$map){my $needle='{{'.$k.'}}';$$textref=~s/\Q$needle\E/$map->{$k}/g;}index($$textref,'{{')<0 or die "unresolved report placeholder\n";
}
sub normal_report {
 my($receipt_meta)=@_;my @rows=outcome_rows();my $def=grep{$_->{kind} eq q{DEFICIENT}}@rows;my $sat=6-$def;my $t=slurp($NORMAL_TEMPLATE);
 replace_literal(\$t,"REPORT_KIND = NORMAL_TERMINAL\n","REPORT_KIND = NORMAL_TERMINAL\nREPORT_SCHEMA_ID = F3_R3_REVERSE_BFS_PILOT_V3_SUCCESSOR_REPORT_V1\n");
 replace_literal(\$t,q{Every row below must be `PASS`, have an exact receipt SHA-256 and have passed
the required pre/post revalidation. A missing or invalid row makes this
normal report illegal and requires the INVALID template instead.},q{Rows B0 through A0 must have status PASS; F0 must have the exact specialized machine verdict; all fourteen rows require exact receipt hashes and PASS pre/post revalidation.});
 if($def==0){$t=~s/\n### 5B\. ANY DEFICIENT.*?(?=\n## 6\.)/\n/s or die "remove STOP branch\n";}else{$t=~s/\n### 5A\. ALL SIX SATURATED PASS.*?(?=\n### 5B\.)/\n/s or die "remove PASS branch\n";}
 my $checker=$def?q{AT_LEAST_ONE_CHECKER_ACCEPTED_DEFICIENT_ROW}:q{SIX_CHECKER_ACCEPTED_SATURATED_ROWS};my $branch=$def?q{ANY_DEFICIENT_SCOPED_STOP}:q{ALL_SIX_SATURATED_PASS};
 my $verdict=$def?q{STOP_R3_REVERSE_CAPACITY_COUNTEREXAMPLE_V3}:q{PASS_R3_REVERSE_BFS_PILOT_V3_6_OF_6};replace_literal(\$t,"TERMINAL_BRANCH = $branch\n","TERMINAL_BRANCH = $branch\nCHECKER_CLASSIFICATION = $checker\n");
 replace_literal(\$t,q{FINAL_READBACK_AFTER_REPORT = PASS},"F0_TERMINAL_RECEIPT_SHA256 = ".sha_file(receipt_path(q{F0}))."\nF0_REPORT_CUSTODY_ROLE = EXTERIOR_NONPHASE_SUCCESSOR\nREPORT_AUTHORITY_REQUIRES_F0_REPORT_CUSTODY_RECEIPT = YES");
 if($def){my @d=grep{$_->{kind} eq q{DEFICIENT}}@rows;my $table=q{};for my $r(@d){$table.=sprintf("| `%s` | %d | %d | `m(p)` | `D(p)-m(p)` | `(D(p)-m(p))*Q(p)/D(p)` |\n",$r->{id},$r->{demand},$r->{m});}my $old='| {{DEFICIENT_ROW_ID}} | {{D_P}} | {{M_P}} | `m(p)` | `D(p)-m(p)` | `(D(p)-m(p))*Q(p)/D(p)` |';replace_literal(\$t,$old,$table=~s/\n\z//r);}
 my %m=(GIT_HEAD=>git_value(q{head}),GIT_BRANCH=>git_value(q{branch}),WORKTREE=>$ROOT,CONTRACT_V6_PATH=>rel($CONTRACT_V6),CONTRACT_V6_SHA256=>sha_file($CONTRACT_V6),CONTRACT_V6_LINES=>line_count($CONTRACT_V6),REGISTRY_V10_PATH=>rel($REGISTRY_V10),REGISTRY_V10_SHA256=>sha_file($REGISTRY_V10),REGISTRY_V10_LINES=>line_count($REGISTRY_V10),PRE_GENERATION_MANIFEST_SHA256=>sha_file("$RESULT/pre_generation_manifest.sha256"),POST_GENERATION_MANIFEST_SHA256=>sha_file("$RESULT/post_generation_manifest.sha256"),FINAL_ARTIFACTS_SHA256=>sha_file("$RESULT/final_artifacts.sha256"),ALL_NORMAL_PHASES_COMPLETED_ONCE=>q{YES},ALL_HASH_AND_MANIFEST_REVALIDATIONS=>q{PASS},MEMORY_POLICY_VALID=>q{PASS},VERIFIER_COVERAGE_VALID=>q{PASS},AXIOM_AUDIT_COVERAGE_VALID=>q{PASS},SATURATED_ROWS=>$sat,DEFICIENT_ROWS=>$def,DEFICIENT_TABLE_ROW_COUNT=>$def,V0_VERIFICATION_RECEIPT_SHA256=>sha_file(receipt_path(q{V0})),A0_AUDIT_RECEIPT_SHA256=>sha_file(receipt_path(q{A0})),FINAL_ARTIFACTS_MANIFEST_PATH=>rel("$RESULT/final_artifacts.sha256"),FINAL_ARTIFACTS_MANIFEST_SHA256=>sha_file("$RESULT/final_artifacts.sha256"));
 for my $p(@normal){$m{"${p}_STATUS"}=$p eq q{F0}?$verdict:q{PASS};$m{"${p}_RECEIPT_SHA256"}=sha_file(receipt_path($p));$m{"${p}_REVALIDATION"}=q{PASS};}for my $r(@rows){my $n=sprintf(q{%02d},$r->{index});$m{"ROW${n}_KIND"}=$r->{kind};$m{"ROW${n}_CHECK"}=q{KERNEL_ACCEPTED_TRUE};$m{"ROW${n}_M"}=$r->{m};$m{"ROW${n}_THEOREM"}=$r->{kind} eq q{SATURATED}?q{verified_typed_saturated_capacity}:q{verified_deficient_fiber_card_lt_demand};$m{"ROW${n}_CERT_SHA256"}=$r->{sha};}
 fill_placeholders(\$t,\%m);my $observed=meta_map(slurp(receipt_path(q{F0})));$observed->{MACHINE_VERDICT} eq $verdict&&$observed->{SATURATED_ROWS}==$sat&&$observed->{DEFICIENT_ROWS}==$def or die "report receipt branch drift\n";return $t;
}
sub report_custody {
 my($report)=@_;my @m=([RESULT=>q{PASS}],[GIT_HEAD=>git_value(q{head})],[GIT_BRANCH=>git_value(q{branch})],[FINAL_ARTIFACTS_SHA256=>sha_file("$RESULT/final_artifacts.sha256")],[F0_TERMINAL_RECEIPT_SHA256=>sha_file(receipt_path(q{F0}))],[REPORT_SHA256=>sha256_hex($report)]);my @s=map{[$_,q{FILE}]}rel("$RESULT/final_artifacts.sha256"),rel(receipt_path(q{F0})),rel("$RESULT/F3_R3_REVERSE_BFS_PILOT_V3_RUN_REPORT.md");return typed_evidence(q{F3_F0_REPORT_CUSTODY_V1},\@m,\@s,[]);
}
sub phase_state_for_invalid {
 my($snapshot)=@_;my %s;for my $p(@normal){my $c=$snapshot->{phase}{$p};if($c->{class}=~/\ACOMPLETE_/){my $r=inspect_path(receipt_path($p));$s{$p}=[q{COMPLETED_PASS},$r->{sha}];}elsif($c->{class} eq q{CLEAN_NEVER}){$s{$p}=[q{NEVER_STARTED_AFTER_INVALID},q{NOT_CREATED_BEFORE_INVALID}];}elsif($p eq $snapshot->{first}){$s{$p}=[q{INVALID},$c->{evidence}];}else{$s{$p}=[q{INVALID_OUT_OF_ORDER_AFTER_FIRST_INVALID},$c->{evidence}];}}return \%s;
}
sub invalid_report {
 my($snapshot,$manifest_sha)=@_;my $first=$snapshot->{first};my $t=slurp($INVALID_TEMPLATE);my $states=phase_state_for_invalid($snapshot);my %m=(GIT_HEAD=>git_value(q{head}),GIT_BRANCH=>git_value(q{branch}),WORKTREE=>$ROOT,CONTRACT_V6_SHA256=>sha_file($CONTRACT_V6),REGISTRY_V10_SHA256=>sha_file($REGISTRY_V10),FIRST_FAILED_PHASE=>$first,INVALID_PREDICATE=>$snapshot->{predicate},TERMINAL_EXIT_STATUS=>$snapshot->{exit},EVENT_TIMESTAMP=>scalar(gmtime()).q{Z},C0_INVOKED=>q{YES},C0_ATTEMPT_COUNT=>1,INVALID_CUSTODY_MANIFEST_SHA256=>$manifest_sha,C0_TERMINAL_STATUS=>q{MANIFEST_SEALED_REPORT_IS_FINAL_UNRECEIPTED_OUTPUT});for my $p(@normal){$m{"${p}_STATE"}=$states->{$p}[0];$m{"${p}_RECEIPT_OR_ABSENCE"}=$states->{$p}[1];}fill_placeholders(\$t,\%m);return $t;
}
sub raw_targets {my($p)=@_;if($p=~/\AG0([1-6])\z/){my $n=sprintf(q{%02d},$1);return("$RESULT/row_$n.raw.stdout","$RESULT/row_$n.raw.stderr","$RESULT/row_$n.exit_status");}return("$RESULT/$p.raw.stdout","$RESULT/$p.raw.stderr","$RESULT/$p.exit_status");}
sub validate_guard {
 my($p,$status,$left)=@_;validate_phase_evidence("$RESULT/$p.lake_environment.tsv",0,q{F3_ENVIRONMENT_V1},$p);my($sha,$m)=validate_phase_evidence("$MEMORY/$p.guard_receipt.sha256",0,q{F3_GUARD_RECEIPT_V1},$p);$m->{ATTEMPT} eq q{1}&&$m->{EXIT_STATUS}==$status&&$m->{MEMORY_VIOLATION} eq q{NO} or die "guard receipt mismatch\n";validate_guard_child_argv_sha($p,$m->{EXACT_CHILD_ARGV_SHA256},$left);return $sha;
}
sub resource_text {my($p,$status,$stderr)=@_;return join("\n",q{F3_RESOURCE_SAMPLE_V1},"PHASE\t$p","EXIT_STATUS\t$status","RAW_STDERR_SHA256\t".sha_file($stderr),"GUARD_RECEIPT_SHA256\t".sha_file("$MEMORY/$p.guard_receipt.sha256"),q{});}
sub p0_auxiliary {
 my $b=slurp("$RESULT/B0.lake_environment.tsv");my $r=slurp("$RESULT/R0.lake_environment.tsv");my $env="F3_PRE_GENERATION_ENVIRONMENT_V1\nB0_SHA256\t".sha256_hex($b)."\nR0_SHA256\t".sha256_hex($r)."\n";publish_text(q{P0},q{PRE_ENVIRONMENT},"$RESULT/pre_generation_environment.txt",$env);
 my $cmd="F3_PRE_GENERATION_COMMANDS_V1\nCOMMAND_TABLE_SHA256\t".sha_file("$RESULT/F3_R3_V3_COMMAND_TABLE.tsv")."\n";publish_text(q{P0},q{PRE_COMMANDS},"$RESULT/pre_generation_commands.txt",$cmd);
 my $obj="F3_PRE_GENERATION_LOADED_OBJECTS_V1\nB0_TRACE_SHA256\t".sha_file("$RESULT/B0.loaded_objects.tsv")."\nR0_TRACE_SHA256\t".sha_file("$RESULT/R0.loaded_objects.tsv")."\n";publish_text(q{P0},q{PRE_OBJECTS},"$RESULT/pre_generation_loaded_objects.txt",$obj);publish_text(q{P0},q{PRE_STATUS},"$RESULT/pre_generation_status.txt","PASS\n");
}
sub phase_work {
 my($p)=@_;my($stdout,$stderr,$status_path)=raw_targets($p);my @allow=lake_paths($p);my $allowed_pre={map{$_=>lake_state($_)}@allow};my $project_pre=tree_snapshot("$ROOT/.lake/build");my $package_pre=tree_snapshot("$ROOT/.lake/packages");my $sys_pre=tree_snapshot(q{/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/lib/lean});my($status,$guard_left);my $metrics={lake_changed=>0,package_delta=>0,sysroot_delta=>0,roots=>0,dep_lines=>0,objects=>0};
 if($p=~/\A(?:B0|R0|G01|G02|G03|G04|G05|G06|V0|A0)\z/){$guard_left=remaining();my @a=($BASH,$GUARD,$p);$command_sha=sha256_hex(frame_argv(@a));$status=run_command($p,$stdout,$stderr,\@a,{F3_R3_SECONDS_REMAINING=>$guard_left});}
 elsif($p eq q{S0}){my $left=remaining();my @a=($GTIMEOUT,q{--foreground},q{--signal=TERM},q{--kill-after=5},$left,$BASH,$MATERIALIZER);$command_sha=sha256_hex(frame_argv(@a));$status=run_command($p,$stdout,$stderr,\@a,{});}
 else{$command_sha=sha256_hex(frame_argv(q{INTERNAL_FIXED_RECEIPT_WRITER_V1},$p));$status=empty_raw($p,$stdout,$stderr);}
 publish_text($p,q{EXIT_STATUS},$status_path,"$status\n");
 my $project_post=tree_snapshot("$ROOT/.lake/build");my $package_post=tree_snapshot("$ROOT/.lake/packages");my $sys_post=tree_snapshot(q{/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/lib/lean});
 my %allowed_abs=map{abs_path($_)=>1}@allow;my @project_changed=changed_paths($project_pre,$project_post);my @package_changed=changed_paths($package_pre,$package_post);my @sysroot_changed=changed_paths($sys_pre,$sys_post);$metrics->{lake_changed}=grep{$allowed_abs{$_}}@project_changed;$metrics->{package_delta}=scalar(@package_changed);$metrics->{sysroot_delta}=scalar(@sysroot_changed);return($status,$metrics) if $status!=0;
 if($p=~/\A(?:B0|R0|G01|G02|G03|G04|G05|G06|V0|A0)\z/){validate_guard($p,$status,$guard_left);my $resource=$p=~/\AG0([1-6])\z/?sprintf("$RESULT/row_%02d.resource_receipt",$1):"$RESULT/$p.resource_receipt.tsv";publish_text($p,q{RESOURCE},$resource,resource_text($p,$status,$stderr));}
 if(@allow){my($delta,$count,$changed)=lake_delta_text($p,$allowed_pre,$project_pre,$package_pre,$sys_pre,$project_post,$package_post,$sys_post);$changed==$metrics->{lake_changed} or die "Lake metric/delta mismatch\n";publish_text($p,q{LAKE_DELTA},"$RESULT/$p.lake_delta.tsv",$delta);}
 else{ensure_no_tree_delta($project_pre,$project_post,q{project});ensure_no_tree_delta($package_pre,$package_post,q{package});ensure_no_tree_delta($sys_pre,$sys_post,q{sysroot});}
 if($p=~/\A(?:B0|R0|V0|A0)\z/){my($deps,$trace,$roots,$lines,$objects)=make_dependencies($p,slurp($stdout));publish_text($p,q{DEPENDENCIES},"$RESULT/$p.dependencies.raw",$deps);publish_text($p,q{LOADED_OBJECTS},"$RESULT/$p.loaded_objects.tsv",$trace);@$metrics{qw(roots dep_lines objects)}=($roots,$lines,$objects);}
 if($p=~/\AG0([1-6])\z/){my $n=sprintf(q{%02d},$1);my $fragment=slurp($stdout);substr($fragment,-1) eq "\n" or die "fragment missing LF\n";publish_text($p,q{FRAGMENT},"$FRAGMENTS/row_$n.canonical_fragment.lean",$fragment);outcome_rows();}
 if($p eq q{P0}){p0_auxiliary();}
 if($p eq q{V0}){publish_text($p,q{COVERAGE},"$RESULT/V0.checker_coverage.tsv",coverage_text());}
 if($p eq q{A0}){my($public,$profiles)=audit_outputs(slurp($stdout),slurp($stderr));publish_text($p,q{PUBLIC_DECLARATIONS},"$RESULT/A0.public_declarations.tsv",$public);publish_text($p,q{AXIOM_PROFILES},"$RESULT/A0.axiom_profiles.tsv",$profiles);}
 return($status,$metrics);
}
sub eligible_failure_seal {
 my($p,$status,$metrics,$predicate)=@_;$status>0 or die "failure seal requires nonzero payload status\n";my $expected=($metrics->{package_delta}//0)>0||($metrics->{sysroot_delta}//0)>0?q{PACKAGE_OR_SYSROOT_DELTA}:q{PAYLOAD_NONZERO};$predicate eq $expected or die "failure predicate/metrics mismatch\n";flock($main::admission_fh,LOCK_EX) or die "failure admission\n";my $active=inspect_path("$CONTROL/active_normal_lease.tsv");my $input=inspect_path("$RESULT/$p.inputs.sha256");my $output="$RESULT/$p.outputs.sha256";my $term=receipt_path($p);my $oc=candidate_path($p,q{OUTPUT});my $tc=candidate_path($p,q{TERMINAL});
 return 0 unless $active->{state} eq q{FILE}&&$input->{state} eq q{FILE}&&no_entry($output)&&no_entry($term)&&no_entry($oc)&&no_entry($tc);validate_phase_evidence("$RESULT/$p.inputs.sha256",0,q{F3_INPUT_MANIFEST_V1},$p);validate_predecessors($p);archive_normal($p);my $out=output_manifest($p,q{INVALID},$metrics);publish_text($p,q{OUTPUT},$output,$out);validate_phase_evidence($output,0,q{F3_OUTPUT_MANIFEST_V1},$p);revalidate_seal_components($p,q{INVALID});my $tr=terminal_receipt($p,q{INVALID},$status,[],1);publish_text($p,q{TERMINAL},$term,$tr);validate_phase_evidence($term,0,q{F3_PHASE_TERMINAL_RECEIPT_V1},$p);return 1;
}
sub run_contract_paths {return(@contracts,rel($NORMAL_TEMPLATE),rel($INVALID_TEMPLATE),rel($REGISTRY_V10));}
sub run_source_paths {return(q{lean-toolchain},q{lake-manifest.json},q{lakefile.lean},map{module_source($_)}@b0_modules);}
sub expected_build_prestate_paths {return stable_unique(lake_paths(q{B0}),lake_paths(q{R0}));}
sub all_fixed_universe {
 my @pre=@frozen_build_prestate?@frozen_build_prestate:expected_build_prestate_paths();my @u=(authority_paths(),@seven_inputs,phase_sources(q{F0}),@run_inputs,@tools,@pre,@generated_source_baseline_files,rel($PAYLOAD),control_paths(),all_candidate_paths());for my $p(@normal){push @u,map{rel("$RESULT/$_")}@{$phase_paths{$p}};push @u,lake_paths($p);}return stable_unique(@u);
}
sub normal_known_universe {
 my($p,$stage)=@_;exists($normal_index{$p})&&$stage=~/\A(?:INPUT|GUARD|SPECIAL|OUTPUT|TERMINAL|COMPLETE)\z/ or die "normal known-universe selector\n";my $idx=$normal_index{$p};my @u=(authority_paths(),@seven_inputs,phase_sources($p),@run_inputs,@tools,@frozen_preexisting_build_files);for my $i(0..$idx){my $q=$normal[$i];push @u,map{rel("$RESULT/$_")}@{$phase_paths{$q}};push @u,lake_paths($q);}push @u,rel($PAYLOAD) if $idx>=$normal_index{S0};
 push @u,map{rel(candidate_path($p,$_))}phase_candidates($p);
 if($stage=~/\A(?:INPUT|SPECIAL|OUTPUT)\z/){push @u,control_paths();}else{push @u,rel("$CONTROL/admission.guard"),rel("$CONTROL/writer.guard"),rel("$CONTROL/active_normal_lease.tsv");if($idx>0){push @u,map{rel("$LEASES/$_.lease.tsv")}@normal[0..$idx-1];}push @u,rel("$LEASES/$p.lease.tsv") if $stage=~/\A(?:OUTPUT|TERMINAL|COMPLETE)\z/;}
 push @u,all_publication_candidate_paths() if $stage eq q{OUTPUT};return stable_unique(@u);
}
sub evidence_known_universe {
 my($type,$m)=@_;return all_fixed_universe() if $type eq q{F3_INVALID_CUSTODY_MANIFEST_V1};my $p=$type eq q{F3_F0_REPORT_CUSTODY_V1}?q{F0}:$m->{PHASE};exists($normal_index{$p}) or die "evidence known-universe phase\n";my $stage=$type eq q{F3_INPUT_MANIFEST_V1}?q{INPUT}:$type eq q{F3_OUTPUT_MANIFEST_V1}?q{OUTPUT}:$type eq q{F3_PHASE_TERMINAL_RECEIPT_V1}||$type eq q{F3_F0_TERMINAL_RECEIPT_V1}?q{TERMINAL}:$type eq q{F3_F0_REPORT_CUSTODY_V1}?q{COMPLETE}:$type eq q{F3_PRE_GENERATION_MANIFEST_V1}||$type eq q{F3_POST_GENERATION_MANIFEST_V1}||$type eq q{F3_FINAL_ARTIFACTS_MANIFEST_V1}?q{SPECIAL}:q{GUARD};return normal_known_universe($p,$stage);
}
sub require_meta_value {my($m,$key,$value)=@_;defined($m->{$key})&&$m->{$key} eq "$value" or die "META $key mismatch\n";}
sub validate_meta_values {
 my($path,$e)=@_;my $t=$e->{type};my $m=$e->{meta};
 for my $k(keys%$m){if($k=~/(?:COUNT|_KIB|_PID|^PGID$|_SECONDS|^ATTEMPT$|^EXIT_STATUS$|_ROWS$)\z/&&$k ne q{PROCESS_START_TOKEN}){canonical_uint($m->{$k}) or die "numeric META $k\n";}if($k=~/(?:SHA256|_SHA256)\z/){canonical_hash($m->{$k}) or die "hash META $k\n";}if($k=~/_SHA256S\z/){$m->{$k} eq q{NONE}||$m->{$k}=~/\A[0-9a-f]{64}(?:,[0-9a-f]{64})*\z/ or die "hash-list META $k\n";}}
 if(exists($m->{PHASE})&&$t ne q{F3_ENVIRONMENT_V1}){exists($normal_index{$m->{PHASE}})||$m->{PHASE} eq q{C0} or die "META phase token\n";}
 if(exists($m->{ATTEMPT})){require_meta_value($m,q{ATTEMPT},1);}
 if(exists($m->{CWD})){require_meta_value($m,q{CWD},$ROOT);}
 if(exists($m->{GIT_HEAD})){require_meta_value($m,q{GIT_HEAD},git_value(q{head}));}
 if(exists($m->{GIT_BRANCH})){require_meta_value($m,q{GIT_BRANCH},git_value(q{branch}));}
 if(exists($m->{CONTROL_COUNT})){require_meta_value($m,q{CONTROL_COUNT},23);canonical_hash($m->{CONTROL_VECTOR_SHA256}) or die "control vector hash\n";}
 if($t eq q{F3_INPUT_MANIFEST_V1}){require_meta_value($m,q{CONTROL_CAPTURE},q{POST_ACTIVE_PRE_PAYLOAD});require_meta_value($m,q{AUTHORITY_COUNT},7);require_meta_value($m,q{PREDECESSOR_COUNT},scalar(@{$pred{$m->{PHASE}}}));require_meta_value($m,q{TOOL_COUNT},scalar(@tools));}
 if($t eq q{F3_OUTPUT_MANIFEST_V1}){my $pass=$m->{RESULT} eq q{PASS};$pass||$m->{RESULT} eq q{INVALID} or die "output result token\n";my @rp=preterminal_results($m->{PHASE});my @lp=lake_paths($m->{PHASE});require_meta_value($m,q{CONTROL_CAPTURE},$pass?q{LOCKED_PRETERMINAL_POST_ARCHIVE}:q{FAILURE_LOCKED_CENSUS});require_meta_value($m,q{RESULT_PATH_COUNT},scalar(@rp));require_meta_value($m,q{LAKE_ALLOWED_COUNT},scalar(@lp));if($pass){require_meta_value($m,q{PACKAGE_DELTA_COUNT},0);require_meta_value($m,q{SYSROOT_DELTA_COUNT},0);}if($m->{PHASE}!~/\A(?:B0|R0|V0|A0)\z/){require_meta_value($m,q{LAKE_CHANGED_COUNT},0);require_meta_value($m,q{ROOT_COUNT},0);require_meta_value($m,q{DEPENDENCY_LINE_COUNT},0);require_meta_value($m,q{UNIQUE_OBJECT_COUNT},0);}}
 if($t eq q{F3_PRE_GENERATION_MANIFEST_V1}){my @chain=qw(B0 R0);require_meta_value($m,q{PHASE},q{P0});require_meta_value($m,q{PREDECESSOR_PHASES},join(q{,},@chain));require_meta_value($m,q{PREDECESSOR_RECEIPT_SHA256S},join(q{,},map{sha_file(receipt_path($_))}@chain));require_meta_value($m,q{AUTHORITY_COUNT},7);require_meta_value($m,q{SEVEN_INPUT_COUNT},7);require_meta_value($m,q{CONTROL_CAPTURE},q{LOCKED_SPECIAL_PREARCHIVE});}
 if($t eq q{F3_POST_GENERATION_MANIFEST_V1}){my @chain=qw(P0 G01 G02 G03 G04 G05 G06 S0);require_meta_value($m,q{PHASE},q{P1});require_meta_value($m,q{PREDECESSOR_PHASES},join(q{,},@chain));require_meta_value($m,q{PREDECESSOR_RECEIPT_SHA256S},join(q{,},map{sha_file(receipt_path($_))}@chain));require_meta_value($m,q{FRAGMENT_COUNT},6);require_meta_value($m,q{PAYLOAD_SHA256},sha_file($PAYLOAD));require_meta_value($m,q{CONTROL_CAPTURE},q{LOCKED_SPECIAL_PREARCHIVE});}
 if($t eq q{F3_FINAL_ARTIFACTS_MANIFEST_V1}){my @chain=@normal[0..12];require_meta_value($m,q{PHASE},q{F0});require_meta_value($m,q{PREDECESSOR_PHASES},join(q{,},@chain));require_meta_value($m,q{PREDECESSOR_RECEIPT_SHA256S},join(q{,},map{sha_file(receipt_path($_))}@chain));require_meta_value($m,q{PREDECESSOR_PHASE_COUNT},13);require_meta_value($m,q{TERMINAL_RECEIPT_COUNT},13);require_meta_value($m,q{VERDICT_INPUT_COUNT},3);require_meta_value($m,q{CONTROL_CAPTURE},q{LOCKED_SPECIAL_PREARCHIVE});}
 if($t eq q{F3_RUN_INPUT_MANIFEST_V1}){my @rc=run_contract_paths();my @rs=run_source_paths();require_meta_value($m,q{CWD},$ROOT);require_meta_value($m,q{AUTHORITY_COUNT},7);require_meta_value($m,q{CONTRACT_COUNT},scalar(@rc));require_meta_value($m,q{SEVEN_INPUT_COUNT},7);require_meta_value($m,q{SOURCE_COUNT},scalar(@rs));require_meta_value($m,q{TOOL_COUNT},scalar(@tools));$m->{BUILD_PRESTATE_COUNT}>0 or die "empty build prestate\n";require_meta_value($m,q{CONTROL_CAPTURE},q{BOOTSTRAP_PRE_ATTEMPT});require_meta_value($m,q{COMMAND_TABLE_SHA256},sha_file(abs_path($run_inputs[2])));require_meta_value($m,q{BASE_ENVIRONMENT_SHA256},sha_file(abs_path($run_inputs[1])));}
 if($t eq q{F3_PHASE_TERMINAL_RECEIPT_V1}||$t eq q{F3_F0_TERMINAL_RECEIPT_V1}){my $p=$m->{PHASE};require_meta_value($m,q{LC_ALL},q{C});require_meta_value($m,q{LANG},q{C});require_meta_value($m,q{WALL_LIMIT_SECONDS},$ceiling{$p});require_meta_value($m,q{PRE_REVALIDATION},q{PASS});require_meta_value($m,q{POST_REVALIDATION},q{PASS});require_meta_value($m,q{PREDECESSOR_PHASES},@{$pred{$p}}?join(q{,},@{$pred{$p}}):q{NONE});require_meta_value($m,q{PREDECESSOR_RECEIPT_SHA256S},@{$pred{$p}}?join(q{,},map{sha_file(receipt_path($_))}@{$pred{$p}}):q{NONE});}
 if($t eq q{F3_PHASE_TERMINAL_RECEIPT_V1}){$m->{RESULT}=~/\A(?:PASS|INVALID)\z/ or die "phase terminal result\n";}
 if($t eq q{F3_F0_TERMINAL_RECEIPT_V1}){require_meta_value($m,q{PHASE},q{F0});require_meta_value($m,q{RESULT},$m->{MACHINE_VERDICT});canonical_uint($m->{SATURATED_ROWS})&&canonical_uint($m->{DEFICIENT_ROWS})&&$m->{SATURATED_ROWS}+$m->{DEFICIENT_ROWS}==6 or die "F0 row counts\n";if($m->{DEFICIENT_ROWS}==0){require_meta_value($m,q{RESULT},q{PASS_R3_REVERSE_BFS_PILOT_V3_6_OF_6});require_meta_value($m,q{TERMINAL_BRANCH},q{ALL_SIX_SATURATED_PASS});require_meta_value($m,q{CHECKER_CLASSIFICATION},q{SIX_CHECKER_ACCEPTED_SATURATED_ROWS});require_meta_value($m,q{SCOPED_CLASSIFICATION_1},q{SIX_OWNER_SATURATION_PASS});require_meta_value($m,q{SCOPED_CLASSIFICATION_2},q{NOT_APPLICABLE});require_meta_value($m,q{SCOPED_CLASSIFICATION_3},q{NOT_APPLICABLE});require_meta_value($m,q{SATURATED_ROWS},6);}else{require_meta_value($m,q{RESULT},q{STOP_R3_REVERSE_CAPACITY_COUNTEREXAMPLE_V3});require_meta_value($m,q{TERMINAL_BRANCH},q{ANY_DEFICIENT_SCOPED_STOP});require_meta_value($m,q{CHECKER_CLASSIFICATION},q{AT_LEAST_ONE_CHECKER_ACCEPTED_DEFICIENT_ROW});require_meta_value($m,q{SCOPED_CLASSIFICATION_1},q{SIX_ROW_SATURATION_STOP});require_meta_value($m,q{SCOPED_CLASSIFICATION_2},q{FULL_CAPACITY_SUBROUTE_STOP});require_meta_value($m,q{SCOPED_CLASSIFICATION_3},q{NO_F3_STOP});}}
 if($t eq q{F3_GUARD_RECEIPT_V1}){require_meta_value($m,q{MIN_AVAILABLE_KIB},4194304);require_meta_value($m,q{MAX_SAMPLED_RSS_KIB},8388608);require_meta_value($m,q{SAMPLE_PERIOD_SECONDS},1);$m->{MEMORY_VIOLATION}=~/\A(?:YES|NO)\z/ or die "memory violation token\n";$m->{PROCESS_START_TOKEN}=~/\A(?:0|[1-9][0-9]*)\.[0-9]{9}\z/ or die "process start token\n";canonical_hash($m->{EXACT_CHILD_ARGV_SHA256}) or die "guard argv hash\n";}
 if($t eq q{F3_F0_REPORT_CUSTODY_V1}){require_meta_value($m,q{RESULT},q{PASS});}
 if($t eq q{F3_INVALID_CUSTODY_MANIFEST_V1}){require_meta_value($m,q{RESULT},q{INVALID});require_meta_value($m,q{WRITER_LOCK_ACQUIRED},q{YES});require_meta_value($m,q{C0_ATTEMPT},1);exists($normal_index{$m->{FIRST_INVALID_PHASE}}) or die "invalid first phase\n";}
}
sub expected_input_specs {
 my($p)=@_;my @cs=control_specs(q{POST_ACTIVE_PRE_PAYLOAD},$p);my @src=(@seven_inputs,phase_sources($p),@run_inputs);my @obj=phase_objects($p);return((map{[$_,q{FILE}]}(authority_paths(),predecessor_paths($p),@src,@tools,@obj)),@cs);
}
sub expected_special_specs {
 my($type)=@_;my $p=$type eq q{F3_PRE_GENERATION_MANIFEST_V1}?q{P0}:$type eq q{F3_POST_GENERATION_MANIFEST_V1}?q{P1}:q{F0};my @control=control_specs(q{LOCKED_SPECIAL_PREARCHIVE},$p);
 if($p eq q{P0}){my @src=(phase_sources($p),@run_inputs[1,2]);my @obj=p0_resolved_objects();my @trans=($run_inputs[0],(map{rel(receipt_path($_)),rel("$RESULT/$_.outputs.sha256")}qw(B0 R0)),authority_paths(),@seven_inputs,@src,@obj);@trans=stable_unique(@trans);return((map{[$_,q{FILE}]}@trans),@control);}
 if($p eq q{P1}){my @rowchain=qw(G01 G02 G03 G04 G05 G06 S0);my @fr=map{rel("$FRAGMENTS/".sprintf(q{row_%02d.canonical_fragment.lean},$_))}1..6;my @trans=(rel("$RESULT/pre_generation_manifest.sha256"),(map{rel(receipt_path($_)),rel("$RESULT/$_.outputs.sha256")}@rowchain),@fr,rel($PAYLOAD));return((map{[$_,q{FILE}]}@trans),(map{[$_,q{ABSENT}]}(lake_paths(q{V0}),lake_paths(q{A0}))),@control);}
 my @earlier=@normal[0..12];my @trans=((map{rel(receipt_path($_))}@earlier),(map{rel("$RESULT/$_.outputs.sha256")}@earlier),rel($PAYLOAD),lake_paths(q{V0}),lake_paths(q{A0}),rel("$RESULT/V0.checker_coverage.tsv"),rel("$RESULT/A0.public_declarations.tsv"),rel("$RESULT/A0.axiom_profiles.tsv"));@trans=stable_unique(@trans);return((map{[$_,q{FILE}]}@trans),@control);
}
sub expected_output_specs {
 my($m)=@_;my $p=$m->{PHASE};my $pass=$m->{RESULT} eq q{PASS};my @pre=preterminal_results($p);my @lake=lake_paths($p);my @control=control_specs($pass?q{LOCKED_PRETERMINAL_POST_ARCHIVE}:q{FAILURE_LOCKED_CENSUS},$p);return((map{[$_,$pass?q{FILE}:q{CENSUS}]}@pre),(map{[$_,$pass?q{FILE}:q{CENSUS}]}@lake),(map{[$_,$pass?q{ABSENT}:q{CENSUS}]}all_publication_candidate_paths()),@control);
}
sub row_reindexed_text {my($r,$index)=@_;my @f=@{$r->{fields}};$f[1]=sprintf(q{%04d},$index);return join("\t",@f)."\n";}
sub rows_vector_hash {my(@rows)=@_;my $t=q{};my $i=1;for my $r(@rows){$t.=row_reindexed_text($r,$i++);}return sha256_hex($t);}
sub project_build_file_paths {
 my $base="$ROOT/.lake/build";my $root=inspect_path($base);return() if $root->{state} eq q{ABSENT};$root->{state} eq q{NONCANONICAL}&&$root->{kind} eq q{DIRECTORY} or die "project build root state\n";my @todo=($base);my @files;
 while(@todo){my $d=shift @todo;opendir(my $h,$d) or die "project build opendir\n";my @names=sort{$a cmp $b}grep{$_ ne q{.}&&$_ ne q{..}}readdir($h);closedir($h) or die "project build closedir\n";for my $name(@names){my $p="$d/$name";my $s=inspect_path($p);if($s->{state} eq q{FILE}){push @files,rel($p);}elsif($s->{state} eq q{NONCANONICAL}&&$s->{kind} eq q{DIRECTORY}){push @todo,$p;}else{die "noncanonical project build entry\n";}}}
 return sort{$a cmp $b}@files;
}
sub recorded_row_matches_actual {
 my($row,$spec,$e,$historical)=@_;my($expected_path,$want)=@$spec;my $f=$row->{fields};$row->{path} eq $expected_path or die "fixed row path/order $expected_path\n";my $kind=$row->{kind};
 if($want eq q{FILE}){$kind eq q{FILE} or die "required recorded FILE $expected_path\n";}elsif($want eq q{ABSENT}){$kind eq q{ABSENT} or die "required recorded ABSENT $expected_path\n";}elsif($want eq q{PRESTATE}){$kind eq q{FILE}||$kind eq q{ABSENT} or die "invalid build prestate row\n";}elsif($want ne q{CENSUS}){die "unknown expected row state\n";}
 return 1 if ($historical==1||$historical==2)&&$kind eq q{ABSENT};
 my $actual_path=abs_path($expected_path);if($historical&&$kind eq q{FILE}&&$expected_path eq rel("$CONTROL/active_normal_lease.tsv")&&defined($e->{meta}{PHASE})){$actual_path="$LEASES/$e->{meta}{PHASE}.lease.tsv";}
 my $s=inspect_path($actual_path);
 if($kind eq q{FILE}){$s->{state} eq q{FILE}&&$s->{sha} eq $f->[2]&&$s->{bytes}==$f->[3] or die "FILE drift $expected_path\n";}
 elsif($kind eq q{ABSENT}){$s->{state} eq q{ABSENT} or die "ABSENT drift $expected_path\n";}
 else{$kind eq q{NONCANONICAL} or die "census row kind\n";$s->{state} eq q{NONCANONICAL}&&$s->{kind} eq $f->[2]&&$s->{mode} eq $f->[3]&&$s->{detail} eq $f->[4] or die "NONCANONICAL drift $expected_path\n";}
 return 1;
}
sub validate_unexpected_tail {
 my($tail,$known,$allowed,$ignore_self,$snapshot_only)=@_;@$tail==0||$allowed or die "unexpected tail forbidden\n";return 1 if $snapshot_only&&!$allowed&&@$tail==0;my @generated=unexpected_rows($known);my @raw;for my $line(@generated){my @f=split /\t/,$line,-1;my $hex=$f[-1];$hex=~s/\n\z//;my $raw=pack(q{H*},$hex);next if defined($ignore_self)&&$raw eq $ignore_self;push @raw,$raw;}if(!$allowed){@raw==0&&@$tail==0 or die "unexpected path outside allowlist\n";return;}@$tail==@raw or die "unexpected tail cardinality\n";for my $i(0..$#raw){$tail->[$i]{unexpected_path} eq $raw[$i] or die "unexpected tail order\n";my $s=inspect_path(abs_path($raw[$i]));my $f=$tail->[$i]{fields};if($tail->[$i]{kind} eq q{UNEXPECTED_FILE}){$s->{state} eq q{FILE}&&$s->{sha} eq $f->[2]&&$s->{bytes}==$f->[3] or die "unexpected FILE drift\n";}else{$s->{state} eq q{NONCANONICAL}&&$s->{kind} eq $f->[2]&&$s->{mode} eq $f->[3]&&$s->{detail} eq $f->[4] or die "unexpected NONCANONICAL drift\n";}}return 1;
}
sub validate_fixed_specs {
 my($rows,$specs,$e,$historical)=@_;@$rows==@$specs or die "fixed array cardinality $e->{type}\n";for my $i(0..$#$specs){recorded_row_matches_actual($rows->[$i],$specs->[$i],$e,$historical);}return 1;
}
sub validate_environment_rows {
 my($e)=@_;my $m=$e->{meta};my @r=@{$e->{rows}};(grep{$_->{kind} ne q{ENV}}@r)==0 or die "non-ENV row\n";require_meta_value($m,q{ENTRY_COUNT},scalar(@r));my $vector=q{};my $previous;for my $r(@r){my $key=$r->{env_key};my $value=$r->{env_value};length($key)>0&&index($key,"\0")<0&&index($value,"\0")<0 or die "ENV NUL/empty key\n";defined($previous)&&$previous ge $key and die "ENV unsigned-byte order/duplicate\n";$previous=$key;$vector.=length($key).q{:}.$key.length($value).q{:}.$value;}require_meta_value($m,q{VECTOR_SHA256},sha256_hex($vector));
}
sub input_object_rows_from_evidence {
 my($p,$m,$rows)=@_;my @authority=authority_paths();my @predecessor=predecessor_paths($p);my @source=(@seven_inputs,phase_sources($p),@run_inputs);my @object=phase_objects($p);require_meta_value($m,q{OBJECT_COUNT},scalar(@object));my $start=@authority+@predecessor+@source+@tools;@$rows==$start+@object+23 or die "input object slice cardinality\n";return() unless @object;my @slice=@$rows[$start..$start+$#object];for my $i(0..$#object){$slice[$i]{kind} eq q{FILE}&&$slice[$i]{path} eq $object[$i] or die "input object slice path/order\n";}return @slice;
}
sub input_object_rows {my($p)=@_;my(undef,$m,$rows)=validate_phase_evidence("$RESULT/$p.inputs.sha256",1,q{F3_INPUT_MANIFEST_V1},$p);return input_object_rows_from_evidence($p,$m,$rows);}
sub validate_trace_object_projection {
 my($p,$rows)=@_;my %current=map{$_=>1}producer_olean_paths($p);my @projected=grep{!$current{$_->{path}}}@$rows;my @ledger=phase_object_absolute_paths($p);my @roles=phase_object_roles($p);my @input=input_object_rows($p);@projected==@ledger&&@roles==@ledger&&@input==@ledger or die "loaded/input object projection cardinality\n";for my $i(0..$#ledger){my $tr=$projected[$i];my $in=$input[$i];$tr->{path} eq $ledger[$i]&&abs_path($in->{path}) eq $ledger[$i] or die "loaded/input object projection order\n";my $tf=$tr->{fields};my $if=$in->{fields};$tf->[2] eq $if->[2]&&$tf->[3] eq $if->[3] or die "loaded/input object hash/bytes mismatch\n";$roles[$i] eq expected_object_role($p,$ledger[$i]) or die "loaded/input object role drift\n";}return 1;
}
sub validate_generator_object_reference {
 my($p,$m,$input_rows)=@_;return 1 unless $p=~/\AG0[1-6]\z/;my @reference=dependency_root_segment_paths(q{R0},2,slurp("$RESULT/R0.dependencies.raw"));my @ledger=phase_object_absolute_paths($p);my @roles=phase_object_roles($p);my @input=input_object_rows_from_evidence($p,$m,$input_rows);my(undef,undef,$r0_rows)=validate_phase_evidence("$RESULT/R0.loaded_objects.tsv",1,q{F3_LOADED_OBJECT_TRACE_V1},q{R0});my %r0=map{$_->{path}=>$_}@{$r0_rows};@ledger==@reference&&@roles==@reference&&@input==@reference or die "generator object reference cardinality\n";for my $i(0..$#reference){$ledger[$i] eq $reference[$i]&&$roles[$i] eq expected_object_role($p,$ledger[$i])&&abs_path($input[$i]{path}) eq $ledger[$i] or die "generator object reference path/role\n";my $resolved=$r0{$ledger[$i]} or die "generator object absent from R0 trace\n";my $gf=$input[$i]{fields};my $rf=$resolved->{fields};$gf->[2] eq $rf->[2]&&$gf->[3] eq $rf->[3] or die "generator/R0 object hash/bytes mismatch\n";}return 1;
}
sub validate_loaded_object_rows {
 my($e)=@_;my $m=$e->{meta};my @r=@{$e->{rows}};(grep{$_->{kind} ne q{OBJECT}}@r)==0 or die "non-OBJECT row\n";my %root_count=(B0=>8,R0=>2,V0=>2,A0=>1);exists($root_count{$m->{PHASE}}) or die "loaded-object phase\n";require_meta_value($m,q{ROOT_COUNT},$root_count{$m->{PHASE}});require_meta_value($m,q{UNIQUE_OBJECT_COUNT},scalar(@r));my($project,$package,$sys)=(0,0,0);for my $r(@r){my $p=lexical_path($r->{path});$p=~/\.olean\z/ or die "OBJECT suffix\n";my @membership=(index($p,"$ROOT/.lake/build/")==0,index($p,"$ROOT/.lake/packages/")==0,index($p,q{/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/lib/lean/})==0);my $members=grep{$_}@membership;$members==1 or die "OBJECT root membership\n";$membership[0]?$project++:$membership[1]?$package++:$sys++;my $s=inspect_path($p);my $f=$r->{fields};$s->{state} eq q{FILE}&&$s->{sha} eq $f->[2]&&$s->{bytes}==$f->[3] or die "OBJECT drift\n";}require_meta_value($m,q{PROJECT_OBJECT_COUNT},$project);require_meta_value($m,q{PACKAGE_OBJECT_COUNT},$package);require_meta_value($m,q{SYSROOT_OBJECT_COUNT},$sys);my($deps,$trace,$roots,$lines,$objects)=make_dependencies($m->{PHASE},slurp("$RESULT/$m->{PHASE}.raw.stdout"));slurp("$RESULT/$m->{PHASE}.dependencies.raw") eq $deps&&$e->{bytes} eq $trace or die "loaded-object/dependency reconstruction\n";require_meta_value($m,q{DEPENDENCY_LINE_COUNT},$lines);require_meta_value($m,q{UNIQUE_OBJECT_COUNT},$objects);validate_trace_object_projection($m->{PHASE},\@r);
}
sub validate_delta_rows {
 my($e)=@_;my $m=$e->{meta};my @r=@{$e->{rows}};(grep{$_->{kind} ne q{DELTA}}@r)==0 or die "non-DELTA row\n";my @allow=lake_paths($m->{PHASE});require_meta_value($m,q{ALLOWED_PATH_COUNT},scalar(@allow));require_meta_value($m,q{CHANGED_PATH_COUNT},scalar(@allow));require_meta_value($m,q{PACKAGE_DELTA_COUNT},0);require_meta_value($m,q{SYSROOT_DELTA_COUNT},0);@r==@allow or die "incomplete LAKE7 delta\n";for my $i(0..$#allow){my $r=$r[$i];$r->{path} eq $allow[$i] or die "DELTA path/order\n";my $f=$r->{fields};$f->[2] eq q{ABSENT}&&$f->[3] eq q{-}&&$f->[4] eq q{-}&&$f->[5] eq q{FILE}&&canonical_hash($f->[6])&&canonical_uint($f->[7]) or die "DELTA exact cold-to-file transition\n";my $s=inspect_path(abs_path($r->{path}));$s->{state} eq q{FILE}&&$s->{sha} eq $f->[6]&&$s->{bytes}==$f->[7] or die "DELTA post FILE\n";}
}
sub validate_run_manifest_rows {
 my($e,$historical)=@_;my $m=$e->{meta};my @rows=@{$e->{rows}};my @prefix_paths=(authority_paths(),run_contract_paths(),@seven_inputs,run_source_paths(),@tools,$run_inputs[2],$run_inputs[1]);my $build_count=0+$m->{BUILD_PRESTATE_COUNT};my @control=control_specs(q{BOOTSTRAP_PRE_ATTEMPT},q{B0});@rows==@prefix_paths+$build_count+@control or die "run manifest row cardinality\n";my @prefix=@rows[0..$#prefix_paths];my @build=@rows[@prefix_paths..@prefix_paths+$build_count-1];my @control_rows=@rows[@prefix_paths+$build_count..$#rows];my @prefix_specs=map{[$_,q{FILE}]}@prefix_paths;validate_fixed_specs(\@prefix,\@prefix_specs,$e,$historical);my @required=expected_build_prestate_paths();$build_count>=@required or die "build prestate too short\n";my %required=map{$_=>1}@required;my %seen;my @extra;
 for my $i(0..$#build){my $r=$build[$i];my $p=$r->{path};exists($seen{$p}) and die "duplicate frozen prestate\n";$seen{$p}=1;if($i<@required){$p eq $required[$i]&&$r->{kind} eq q{ABSENT} or die "required cold build prestate\n";}else{$r->{kind} eq q{FILE} or die "extra build prestate must be FILE\n";index(abs_path($p),"$ROOT/.lake/build/")==0&&!$required{$p} or die "extra prestate root\n";push @extra,$p;}}
 for my $i(1..$#extra){$extra[$i-1] lt $extra[$i] or die "extra prestate order\n";}@frozen_build_prestate=map{$_->{path}}@build;@frozen_preexisting_build_files=@extra;
 if($historical){if(@build>@required){for my $i(scalar(@required)..$#build){recorded_row_matches_actual($build[$i],[$build[$i]{path},q{FILE}],$e,1);}}if($historical==2){for my $i(0..$#control){$control_rows[$i]{path} eq $control[$i][0]&&$control_rows[$i]{kind} eq $control[$i][1] or die "bootstrap control recorded shape\n";}}else{validate_fixed_specs(\@control_rows,\@control,$e,1);}}
 else{my %extra=map{$_=>1}@extra;for my $i(0..$#required){recorded_row_matches_actual($build[$i],[$required[$i],q{ABSENT}],$e,0);}if(@build>@required){for my $i(scalar(@required)..$#build){recorded_row_matches_actual($build[$i],[$build[$i]{path},q{FILE}],$e,0);}}my @current=project_build_file_paths();@current==@extra or die "project build prestate census cardinality\n";for my $i(0..$#extra){$current[$i] eq $extra[$i] or die "project build prestate census mismatch\n";}validate_fixed_specs(\@control_rows,\@control,$e,0);}
 require_meta_value($m,q{CONTROL_VECTOR_SHA256},rows_vector_hash(@control_rows));
}
sub validate_schema_rows {
 my($path,$e,$historical)=@_;my $t=$e->{type};my $m=$e->{meta};my @fixed=grep{$_->{kind}!~/\AUNEXPECTED_/}@{$e->{rows}};my @tail=grep{$_->{kind}=~/\AUNEXPECTED_/}@{$e->{rows}};
 if($t eq q{F3_ENVIRONMENT_V1}){validate_environment_rows($e);return;}
 if($t eq q{F3_LOADED_OBJECT_TRACE_V1}){validate_loaded_object_rows($e);return;}
 if($t eq q{F3_LAKE_DELTA_V1}){validate_delta_rows($e);return;}
 if($t eq q{F3_RUN_INPUT_MANIFEST_V1}){@tail==0 or die "run manifest unexpected tail\n";validate_run_manifest_rows($e,$historical);return;}
 my @spec;
 if($t eq q{F3_INPUT_MANIFEST_V1}){@spec=expected_input_specs($m->{PHASE});}
 elsif($t eq q{F3_OUTPUT_MANIFEST_V1}){@spec=expected_output_specs($m);}
 elsif($t eq q{F3_PRE_GENERATION_MANIFEST_V1}||$t eq q{F3_POST_GENERATION_MANIFEST_V1}||$t eq q{F3_FINAL_ARTIFACTS_MANIFEST_V1}){@spec=expected_special_specs($t);}
 elsif($t eq q{F3_PHASE_TERMINAL_RECEIPT_V1}){@spec=terminal_specs($m->{PHASE},$m->{RESULT} eq q{INVALID});}
 elsif($t eq q{F3_F0_TERMINAL_RECEIPT_V1}){@spec=terminal_specs(q{F0},0);}
 elsif($t eq q{F3_GUARD_RECEIPT_V1}){@spec=map{[$_,q{FILE}]}rel("$MEMORY/$m->{PHASE}.vm_stat_pre.txt"),rel("$MEMORY/$m->{PHASE}.rss_members.tsv"),rel("$MEMORY/$m->{PHASE}.rss_summary.tsv");}
 elsif($t eq q{F3_F0_REPORT_CUSTODY_V1}){@spec=map{[$_,q{FILE}]}rel("$RESULT/final_artifacts.sha256"),rel(receipt_path(q{F0})),rel("$RESULT/F3_R3_REVERSE_BFS_PILOT_V3_RUN_REPORT.md");}
 elsif($t eq q{F3_INVALID_CUSTODY_MANIFEST_V1}){@spec=map{[$_,q{CENSUS}]}all_fixed_universe();}
 else{die "schema row validator missing $t\n";}
 validate_fixed_specs(\@fixed,\@spec,$e,$historical);
 my $tail_allowed=($t eq q{F3_INVALID_CUSTODY_MANIFEST_V1})||($t eq q{F3_OUTPUT_MANIFEST_V1}&&$m->{RESULT} eq q{INVALID});my @known=evidence_known_universe($t,$m);my $self;if($t eq q{F3_INVALID_CUSTODY_MANIFEST_V1}&&$historical==3){my $active=inspect_path("$CONTROL/active_c0_lease.tsv");my $archive=inspect_path("$LEASES/C0.lease.tsv");my $manifest_target=inspect_path("$RESULT/invalid_custody_manifest.sha256");$manifest_target->{state} eq q{FILE}&&$active->{state} eq q{FILE}&&$archive->{state} eq q{FILE}&&$active->{inode} eq $archive->{inode}&&no_entry(candidate_path(q{C0},q{INVALID_MANIFEST}))&&no_entry(candidate_path(q{C0},q{INVALID_REPORT}))&&no_entry("$RESULT/INVALID_R3_REVERSE_BFS_PILOT_V3_RUN_REPORT.md") or die "C0 self-readback exception precondition\n";$self=rel("$RESULT/invalid_custody_manifest.sha256");}my $terminal_invalid=$t eq q{F3_PHASE_TERMINAL_RECEIPT_V1}&&($m->{RESULT}//q{}) eq q{INVALID};validate_unexpected_tail(\@tail,\@known,$tail_allowed,$self,(($historical==1||$historical==2)&&!$tail_allowed)||$terminal_invalid);
 if(exists($m->{CONTROL_COUNT})){my @control_rows=@fixed[-23..-1];require_meta_value($m,q{CONTROL_VECTOR_SHA256},rows_vector_hash(@control_rows));}
 if($t eq q{F3_INPUT_MANIFEST_V1}){my @src=(@seven_inputs,phase_sources($m->{PHASE}),@run_inputs);my @obj=phase_objects($m->{PHASE});require_meta_value($m,q{SOURCE_COUNT},scalar(@src));require_meta_value($m,q{OBJECT_COUNT},scalar(@obj));validate_generator_object_reference($m->{PHASE},$m,\@fixed);}
 if($t eq q{F3_PRE_GENERATION_MANIFEST_V1}){my $n=@fixed-23;my @src=phase_sources(q{P0});my @obj=p0_resolved_objects();require_meta_value($m,q{TRANSITIVE_FILE_COUNT},$n);require_meta_value($m,q{TRANSITIVE_VECTOR_SHA256},rows_vector_hash(@fixed[0..$n-1]));require_meta_value($m,q{SOURCE_COUNT},scalar(@src)+2);require_meta_value($m,q{OBJECT_COUNT},scalar(@obj));}
 if($t eq q{F3_POST_GENERATION_MANIFEST_V1}){my @build=(lake_paths(q{V0}),lake_paths(q{A0}));my $n=@fixed-23-@build;require_meta_value($m,q{BUILD_PRESTATE_COUNT},scalar(@build));require_meta_value($m,q{TRANSITIVE_FILE_COUNT},$n);require_meta_value($m,q{TRANSITIVE_VECTOR_SHA256},rows_vector_hash(@fixed[0..$n+@build-1]));}
 if($t eq q{F3_FINAL_ARTIFACTS_MANIFEST_V1}){my $n=@fixed-23;require_meta_value($m,q{TRANSITIVE_FILE_COUNT},$n);require_meta_value($m,q{TRANSITIVE_VECTOR_SHA256},rows_vector_hash(@fixed[0..$n-1]));}
 if($t eq q{F3_OUTPUT_MANIFEST_V1}){my $p=$m->{PHASE};my $pass=$m->{RESULT} eq q{PASS};my $env_path="$RESULT/$p.lake_environment.tsv";if($p=~/\A(?:B0|R0|G01|G02|G03|G04|G05|G06|V0|A0)\z/&&($pass||inspect_path($env_path)->{state} eq q{FILE})){validate_phase_evidence($env_path,$historical,q{F3_ENVIRONMENT_V1},$p);}if($p=~/\A(?:B0|R0|V0|A0)\z/){my $loaded="$RESULT/$p.loaded_objects.tsv";my $delta="$RESULT/$p.lake_delta.tsv";if($pass||inspect_path($loaded)->{state} eq q{FILE}){my(undef,$lm)=validate_phase_evidence($loaded,$historical,q{F3_LOADED_OBJECT_TRACE_V1},$p);require_meta_value($m,q{ROOT_COUNT},$lm->{ROOT_COUNT});require_meta_value($m,q{DEPENDENCY_LINE_COUNT},$lm->{DEPENDENCY_LINE_COUNT});require_meta_value($m,q{UNIQUE_OBJECT_COUNT},$lm->{UNIQUE_OBJECT_COUNT});}if($pass||inspect_path($delta)->{state} eq q{FILE}){my(undef,$dm)=validate_phase_evidence($delta,$historical,q{F3_LAKE_DELTA_V1},$p);require_meta_value($m,q{LAKE_ALLOWED_COUNT},$dm->{ALLOWED_PATH_COUNT});require_meta_value($m,q{LAKE_CHANGED_COUNT},$dm->{CHANGED_PATH_COUNT});}}}
 if($t eq q{F3_PHASE_TERMINAL_RECEIPT_V1}||$t eq q{F3_F0_TERMINAL_RECEIPT_V1}){require_meta_value($m,q{INPUT_MANIFEST_SHA256},sha_file("$RESULT/$m->{PHASE}.inputs.sha256"));require_meta_value($m,q{OUTPUT_MANIFEST_SHA256},sha_file("$RESULT/$m->{PHASE}.outputs.sha256"));}
 if($t eq q{F3_PHASE_TERMINAL_RECEIPT_V1}||$t eq q{F3_F0_TERMINAL_RECEIPT_V1}){my $p=$m->{PHASE};my(undef,$om)=validate_phase_evidence("$RESULT/$p.outputs.sha256",$historical,q{F3_OUTPUT_MANIFEST_V1},$p);if($t eq q{F3_F0_TERMINAL_RECEIPT_V1}){require_meta_value($om,q{RESULT},q{PASS});require_meta_value($m,q{FINAL_ARTIFACTS_SHA256},sha_file("$RESULT/final_artifacts.sha256"));}else{$p eq q{F0}&&$m->{RESULT} ne q{INVALID} and die "generic F0 terminal is operational INVALID only\n";require_meta_value($om,q{RESULT},$m->{RESULT});}my $expected_command;if($p=~/\A(?:B0|R0|G01|G02|G03|G04|G05|G06|V0|A0)\z/){$expected_command=sha256_hex(frame_argv($BASH,$GUARD,$p));}elsif($p eq q{S0}){validate_s0_command_sha($m->{COMMAND_SHA256});}elsif($p=~/\A(?:P0|P1|F0)\z/){$expected_command=sha256_hex(frame_argv(q{INTERNAL_FIXED_RECEIPT_WRITER_V1},$p));}require_meta_value($m,q{COMMAND_SHA256},$expected_command) if defined($expected_command);}
 if($t eq q{F3_F0_REPORT_CUSTODY_V1}){require_meta_value($m,q{FINAL_ARTIFACTS_SHA256},sha_file("$RESULT/final_artifacts.sha256"));require_meta_value($m,q{F0_TERMINAL_RECEIPT_SHA256},sha_file(receipt_path(q{F0})));require_meta_value($m,q{REPORT_SHA256},sha_file("$RESULT/F3_R3_REVERSE_BFS_PILOT_V3_RUN_REPORT.md"));}
}
sub validate_base_environment {
 my($sha,undef,$rows)=validate_phase_evidence(abs_path($run_inputs[1]),0,q{F3_ENVIRONMENT_V1},q{B0});my %seen=map{$_->{env_key}=>$_->{env_value}}@$rows;my %expected=(HOME=>q{/Users/MoiTam},ELAN_HOME=>q{/Users/MoiTam/.elan},PATH=>q{/Users/MoiTam/.elan/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin},LC_ALL=>q{C},LANG=>q{C},TMPDIR=>$TMP);keys(%seen)==keys(%expected) or die "base environment cardinality\n";for my $k(keys%expected){exists($seen{$k})&&$seen{$k} eq $expected{$k} or die "base environment value $k\n";}return $sha;
}
sub validate_frozen_run_inputs {
 my($historical)=@_;defined($live_git_head)&&defined($live_git_branch) or die "live Git cache unavailable\n";parse_command_table();my $base_sha=validate_base_environment();my $e=parse_evidence_file(abs_path($run_inputs[0]),q{F3_RUN_INPUT_MANIFEST_V1});canonical_git_oid($e->{meta}{GIT_HEAD})&&($e->{meta}{GIT_BRANCH}//q{})=~/\A[0-9A-Za-z._\/-]+\z/ or die "frozen Git identity grammar\n";$frozen_git_head=$e->{meta}{GIT_HEAD};$frozen_git_branch=$e->{meta}{GIT_BRANCH};$frozen_git_head eq $live_git_head&&$frozen_git_branch eq $live_git_branch or die "live/frozen Git identity mismatch\n";verify_live_tracked_source_baseline($frozen_git_head);validate_meta_values(abs_path($run_inputs[0]),$e);validate_schema_rows(abs_path($run_inputs[0]),$e,$historical);require_meta_value($e->{meta},q{BASE_ENVIRONMENT_SHA256},$base_sha);return sha256_hex($e->{bytes});
}
sub load_c0_frozen_context {
 $frozen_git_head=q{UNAVAILABLE};$frozen_git_branch=q{UNAVAILABLE};local $@;my($candidate_head,$candidate_branch);my $identity_ok=eval{my $e=parse_evidence_file(abs_path($run_inputs[0]),q{F3_RUN_INPUT_MANIFEST_V1});canonical_git_oid($e->{meta}{GIT_HEAD})&&($e->{meta}{GIT_BRANCH}//q{})=~/\A[0-9A-Za-z._\/-]+\z/ or die "C0 frozen Git identity grammar\n";$candidate_head=$e->{meta}{GIT_HEAD};$candidate_branch=$e->{meta}{GIT_BRANCH};1};if($identity_ok){($frozen_git_head,$frozen_git_branch)=($candidate_head,$candidate_branch);}my $validated=$identity_ok&&eval{parse_command_table();my $base_sha=validate_base_environment();my $e=parse_evidence_file(abs_path($run_inputs[0]),q{F3_RUN_INPUT_MANIFEST_V1});validate_meta_values(abs_path($run_inputs[0]),$e);validate_schema_rows(abs_path($run_inputs[0]),$e,2);require_meta_value($e->{meta},q{BASE_ENVIRONMENT_SHA256},$base_sha);1};unless($validated){$c0_run_input_error=q{FROZEN_RUN_INPUT_EXACT_VALIDATION_FAILED};$frozen_git_head=q{UNAVAILABLE};$frozen_git_branch=q{UNAVAILABLE};}return 1;
}
sub active_normal_phase {
 my $s=inspect_path("$CONTROL/active_normal_lease.tsv");return if $s->{state} eq q{ABSENT};return q{MALFORMED} unless $s->{state} eq q{FILE};return $1 if $s->{data}=~/\AF3_LEASE_V1\nKIND\tNORMAL\nPHASE\t([A-Z0-9]+)\n/&&exists($normal_index{$1});return q{MALFORMED};
}
sub phase_has_marker {
 my($p)=@_;for my $r(@{$phase_paths{$p}}){return 1 unless no_entry("$RESULT/$r");}return 1 if $p eq q{S0}&&!no_entry($PAYLOAD);return 1 unless no_entry("$LEASES/$p.lease.tsv");for my $role(phase_candidates($p)){return 1 unless no_entry(candidate_path($p,$role));}my $active=active_normal_phase();return 1 if defined($active)&&$active eq $p;return 0;
}
sub normal_candidate_phase {
 my $s=inspect_path("$CONTROL/normal-lease.candidate");return unless $s->{state} ne q{ABSENT};return q{MALFORMED} unless $s->{state} eq q{FILE}&&$s->{data}=~/\AF3_LEASE_V1\nKIND\tNORMAL\nPHASE\t([A-Z0-9]+)\n/&&exists($normal_index{$1});return $1;
}
sub contention_owner_from_path {
 my($path)=@_;my $s=inspect_path($path);return if $s->{state} eq q{ABSENT};return q{MALFORMED} unless $s->{state} eq q{FILE}&&$s->{data}=~/\AF3_CONTENTION_V1\nREQUESTED_PHASE\t(?:B0|R0|P0|G01|G02|G03|G04|G05|G06|S0|P1|V0|A0|F0|C0)\nACTIVE_STATE\tFILE\nACTIVE_SHA256\t([0-9a-f]{64})\nUTC\t[^\n]+\n\z/;my $sha=$1;my $active=inspect_path("$CONTROL/active_normal_lease.tsv");if($active->{state} eq q{FILE}&&$active->{sha} eq $sha){my $p=active_normal_phase();return $p if defined($p)&&exists($normal_index{$p});}for my $p(@normal){my $a=inspect_path("$LEASES/$p.lease.tsv");return $p if $a->{state} eq q{FILE}&&$a->{sha} eq $sha;}return q{MALFORMED};
}
sub contention_owner_phase {return contention_owner_from_path("$CONTROL/first_contention.tsv");}
sub contention_candidate_owner_phase {return contention_owner_from_path("$CONTROL/contention.candidate");}
sub try_exact_evidence {
 my($path,$historical,$type,$predicate)=@_;my @v;local $@;my $ok=eval{@v=validate_evidence($path,$historical,$type);1};return $ok?{ok=>1,sha=>$v[0],meta=>$v[1],rows=>$v[2]}:{ok=>0,predicate=>$predicate,error=>q{EXACT_VALIDATOR_REJECTED}};
}
sub try_exact_phase_evidence {
 my($path,$historical,$type,$p,$predicate)=@_;my @v;local $@;my $ok=eval{@v=validate_phase_evidence($path,$historical,$type,$p);1};return $ok?{ok=>1,sha=>$v[0],meta=>$v[1],rows=>$v[2]}:{ok=>0,predicate=>$predicate,error=>q{EXACT_PHASE_VALIDATOR_REJECTED}};
}
sub exact_lease {
 my($p,$kind)=@_;my $path=$kind eq q{NORMAL}?"$LEASES/$p.lease.tsv":"$LEASES/C0.lease.tsv";my $s=inspect_path($path);$s->{state} eq q{FILE} or die "lease state\n";my $expected_kind=$kind eq q{NORMAL}?q{NORMAL}:q{CUSTODY};$s->{data}=~/\AF3_LEASE_V1\nKIND\t\Q$expected_kind\E\nPHASE\t\Q$p\E\nPID\t(0|[1-9][0-9]*)\nPROCESS_START_TOKEN\t(0|[1-9][0-9]*)\.[0-9]{9}\nEXECUTOR_PATH\t\Q@{[rel($EXECUTOR)]}\E\nEXECUTOR_SHA256\t\Q@{[sha_file($EXECUTOR)]}\E\nARGV_SHA256\t\Q@{[sha256_hex(frame_argv($EXECUTOR,$p))]}\E\nUTC\t[^\t\r\n]+Z\nGIT_HEAD\t\Q$frozen_git_head\E\nGIT_BRANCH\t\Q$frozen_git_branch\E\n\z/ or die "lease grammar/content\n";return $s;
}
sub p0_auxiliary_exact {
 my $env="F3_PRE_GENERATION_ENVIRONMENT_V1\nB0_SHA256\t".sha_file("$RESULT/B0.lake_environment.tsv")."\nR0_SHA256\t".sha_file("$RESULT/R0.lake_environment.tsv")."\n";my $cmd="F3_PRE_GENERATION_COMMANDS_V1\nCOMMAND_TABLE_SHA256\t".sha_file("$RESULT/F3_R3_V3_COMMAND_TABLE.tsv")."\n";my $obj="F3_PRE_GENERATION_LOADED_OBJECTS_V1\nB0_TRACE_SHA256\t".sha_file("$RESULT/B0.loaded_objects.tsv")."\nR0_TRACE_SHA256\t".sha_file("$RESULT/R0.loaded_objects.tsv")."\n";slurp("$RESULT/pre_generation_environment.txt") eq $env&&slurp("$RESULT/pre_generation_commands.txt") eq $cmd&&slurp("$RESULT/pre_generation_loaded_objects.txt") eq $obj&&slurp("$RESULT/pre_generation_status.txt") eq "PASS\n" or die "P0 auxiliary reconstruction\n";
}
sub expected_s0_payload {
 my $source=slurp($MATERIALIZER);my $preamble_open="my \$preamble = <<'LEAN';\n";my $middle="\nLEAN\n\nmy \$postamble = <<'LEAN';\n";my $postamble_close="\nLEAN\n\nmy \$payload = \$preamble . join(q{}, \@fragments) . \$postamble;";for my $marker($preamble_open,$middle,$postamble_close){my $first=index($source,$marker);$first>=0&&$first==rindex($source,$marker) or die "materializer wrapper marker cardinality\n";}my $preamble_start=index($source,$preamble_open)+length($preamble_open);my $middle_at=index($source,$middle,$preamble_start);my $postamble_start=$middle_at+length($middle);my $postamble_at=index($source,$postamble_close,$postamble_start);$middle_at>$preamble_start&&$postamble_at>$postamble_start or die "materializer wrapper bounds\n";my $payload=substr($source,$preamble_start,$middle_at-$preamble_start+1);for my $i(1..6){$payload.=slurp(sprintf("$FRAGMENTS/row_%02d.canonical_fragment.lean",$i));}$payload.=substr($source,$postamble_start,$postamble_at-$postamble_start+1);return $payload;
}
sub exact_phase_payload_evidence {
 my($p,$tm)=@_;my $exit=$tm->{EXIT_STATUS};my($stdout,$stderr,$status_path)=raw_targets($p);slurp($status_path) eq "$exit\n" or die "exit-status payload mismatch\n";if(($tm->{RESULT}//q{}) ne q{INVALID}){$exit eq q{0} or die "successful terminal nonzero exit\n";}
 if($p=~/\A(?:B0|R0|G01|G02|G03|G04|G05|G06|V0|A0)\z/){validate_phase_evidence("$RESULT/$p.lake_environment.tsv",1,q{F3_ENVIRONMENT_V1},$p);my(undef,$gm)=validate_phase_evidence("$MEMORY/$p.guard_receipt.sha256",1,q{F3_GUARD_RECEIPT_V1},$p);require_meta_value($gm,q{EXIT_STATUS},$exit);require_meta_value($gm,q{MEMORY_VIOLATION},q{NO}) if ($tm->{RESULT}//q{}) ne q{INVALID};validate_guard_child_argv_sha($p,$gm->{EXACT_CHILD_ARGV_SHA256},undef);my $resource=$p=~/\AG0([1-6])\z/?sprintf("$RESULT/row_%02d.resource_receipt",$1):"$RESULT/$p.resource_receipt.tsv";slurp($resource) eq resource_text($p,$exit,$stderr) or die "resource receipt reconstruction\n";}
 if($p=~/\AG0([1-6])\z/){my $n=sprintf(q{%02d},$1);slurp("$FRAGMENTS/row_$n.canonical_fragment.lean") eq slurp($stdout) or die "generator fragment/stdout mismatch\n";}
 if($p eq q{P0}){slurp($stdout) eq q{}&&slurp($stderr) eq q{} or die "P0 raw stream\n";p0_auxiliary_exact();}
 if($p eq q{S0}){slurp($stdout) eq q{}&&slurp($stderr) eq q{}&&slurp($PAYLOAD) eq expected_s0_payload() or die "S0 materialization evidence\n";}
 if($p eq q{P1}||$p eq q{F0}){slurp($stdout) eq q{}&&slurp($stderr) eq q{} or die "internal writer raw stream\n";}
 if($p eq q{V0}){slurp("$RESULT/V0.checker_coverage.tsv") eq coverage_text() or die "V0 coverage reconstruction\n";}
 if($p eq q{A0}){my($public,$profiles)=audit_outputs(slurp($stdout),slurp($stderr));slurp("$RESULT/A0.public_declarations.tsv") eq $public&&slurp("$RESULT/A0.axiom_profiles.tsv") eq $profiles or die "A0 audit reconstruction\n";}
 return 1;
}
sub phase_owned_closure {
 my($p,$invalid)=@_;my @roles=$invalid?qw(OUTPUT TERMINAL):phase_candidates($p);for my $role(@roles){no_entry(candidate_path($p,$role)) or die "owned publication candidate residual\n";}my $archive=exact_lease($p,q{NORMAL});my $active_state=inspect_path("$CONTROL/active_normal_lease.tsv");if($invalid){$active_state->{state} eq q{FILE}&&$active_state->{inode} eq $archive->{inode}&&$active_state->{sha} eq $archive->{sha} or die "INVALID active/archive closure\n";}elsif($active_state->{state} eq q{FILE}&&active_normal_phase() eq $p){$active_state->{inode} eq $archive->{inode}&&$active_state->{sha} eq $archive->{sha} or die "retained active/archive mismatch\n";}my $normal_candidate=normal_candidate_phase();(!defined($normal_candidate)||$normal_candidate ne $p) or die "owned normal candidate residual\n";if(!$invalid){my $contention=contention_owner_phase();my $contention_candidate=contention_candidate_owner_phase();(!defined($contention)||$contention ne $p)&&(!defined($contention_candidate)||$contention_candidate ne $p) or die "owned contention residual\n";}return 1;
}
sub exact_f0_exterior {
 my($tm)=@_;my $final=try_exact_phase_evidence("$RESULT/final_artifacts.sha256",1,q{F3_FINAL_ARTIFACTS_MANIFEST_V1},q{F0},q{F0_FINAL_ARTIFACTS_EXACT_VALIDATION_FAILED});return $final unless $final->{ok};my $report=inspect_path("$RESULT/F3_R3_REVERSE_BFS_PILOT_V3_RUN_REPORT.md");return {ok=>0,predicate=>q{F0_NORMAL_REPORT_MISSING_OR_NONCANONICAL}} unless $report->{state} eq q{FILE};local $@;my $expected;my $rebuilt=eval{$expected=normal_report($tm);1};return {ok=>0,predicate=>q{F0_NORMAL_REPORT_RECONSTRUCTION_FAILED}} unless $rebuilt&&$report->{data} eq $expected;my $custody=try_exact_evidence("$RESULT/F0_report_custody_receipt.sha256",1,q{F3_F0_REPORT_CUSTODY_V1},q{F0_REPORT_CUSTODY_EXACT_VALIDATION_FAILED});return $custody unless $custody->{ok};for my $p("$CONTROL/normal-lease.candidate","$CONTROL/c0-lease.candidate","$CONTROL/contention.candidate","$CONTROL/active_c0_lease.tsv","$CONTROL/first_contention.tsv","$LEASES/C0.lease.tsv",all_publication_candidate_paths()){return {ok=>0,predicate=>q{F0_EXTERIOR_CONTROL_NOT_CLOSED}} unless no_entry(abs_path($p));}return {ok=>1};
}
sub exact_phase_bundle {
 my($p)=@_;my $receipt=inspect_path(receipt_path($p));return {ok=>0,predicate=>q{TERMINAL_RECEIPT_MISSING_OR_NONCANONICAL},exit=>q{UNKNOWN},evidence=>q{NOT_CREATED_BEFORE_INVALID}} unless $receipt->{state} eq q{FILE};my $header=$receipt->{data}=~/\AF3_EVIDENCE_V2\t([^\n]+)\n/?$1:q{};my $type=$header eq q{F3_PHASE_TERMINAL_RECEIPT_V1}?$header:$p eq q{F0}&&$header eq q{F3_F0_TERMINAL_RECEIPT_V1}?$header:q{};return {ok=>0,predicate=>q{TERMINAL_RECEIPT_SCHEMA_INVALID},exit=>q{UNKNOWN},evidence=>$receipt->{sha}} unless length($type);my $input=try_exact_phase_evidence("$RESULT/$p.inputs.sha256",1,q{F3_INPUT_MANIFEST_V1},$p,q{INPUT_MANIFEST_EXACT_VALIDATION_FAILED});return {%$input,exit=>q{UNKNOWN},evidence=>$receipt->{sha}} unless $input->{ok};my $output=try_exact_phase_evidence("$RESULT/$p.outputs.sha256",1,q{F3_OUTPUT_MANIFEST_V1},$p,q{OUTPUT_MANIFEST_EXACT_VALIDATION_FAILED});return {%$output,exit=>q{UNKNOWN},evidence=>$receipt->{sha}} unless $output->{ok};my $terminal=try_exact_phase_evidence(receipt_path($p),1,$type,$p,q{TERMINAL_RECEIPT_EXACT_VALIDATION_FAILED});return {%$terminal,exit=>q{UNKNOWN},evidence=>$receipt->{sha}} unless $terminal->{ok};my $tm=$terminal->{meta};my $result=$tm->{RESULT}//q{};if($result ne q{INVALID}){my($special_path,$special_type)=$p eq q{P0}?("$RESULT/pre_generation_manifest.sha256",q{F3_PRE_GENERATION_MANIFEST_V1}):$p eq q{P1}?("$RESULT/post_generation_manifest.sha256",q{F3_POST_GENERATION_MANIFEST_V1}):$p eq q{F0}?("$RESULT/final_artifacts.sha256",q{F3_FINAL_ARTIFACTS_MANIFEST_V1}):(undef,undef);if(defined($special_path)){my $special=try_exact_phase_evidence($special_path,1,$special_type,$p,q{SPECIAL_MANIFEST_EXACT_VALIDATION_FAILED});return {%$special,exit=>$tm->{EXIT_STATUS},evidence=>$receipt->{sha}} unless $special->{ok};}}
 local $@;if($result eq q{INVALID}){my $predicate;my $closed=eval{my(undef,undef,$status_path)=raw_targets($p);canonical_uint($tm->{EXIT_STATUS})&&$tm->{EXIT_STATUS}>0&&slurp($status_path) eq "$tm->{EXIT_STATUS}\n" or die "invalid exit status evidence\n";my $om=$output->{meta};$predicate=($om->{PACKAGE_DELTA_COUNT}//0)>0||($om->{SYSROOT_DELTA_COUNT}//0)>0?q{PACKAGE_OR_SYSROOT_DELTA}:q{PAYLOAD_NONZERO};phase_owned_closure($p,1);1};return {ok=>0,predicate=>q{INVALID_TERMINAL_CLOSURE_EXACT_VALIDATION_FAILED},exit=>$tm->{EXIT_STATUS}//q{UNKNOWN},evidence=>$receipt->{sha}} unless $closed;return {ok=>1,class=>q{INVALID},predicate=>$predicate,exit=>$tm->{EXIT_STATUS},evidence=>$receipt->{sha}};}my $payload_ok=eval{exact_phase_payload_evidence($p,$tm);phase_owned_closure($p,0);1};return {ok=>0,predicate=>q{PHASE_PAYLOAD_OR_CLOSURE_EXACT_VALIDATION_FAILED},exit=>$tm->{EXIT_STATUS}//q{UNKNOWN},evidence=>$receipt->{sha}} unless $payload_ok;if($p eq q{F0}){my $exterior=exact_f0_exterior($tm);return {%$exterior,exit=>$tm->{EXIT_STATUS},evidence=>$receipt->{sha}} unless $exterior->{ok};return {ok=>1,class=>q{COMPLETE_F0_EXTERIOR},predicate=>q{NONE},exit=>q{0},evidence=>$receipt->{sha}};}return {ok=>1,class=>q{COMPLETE_PASS},predicate=>q{NONE},exit=>q{0},evidence=>$receipt->{sha}};
}
sub revalidate_special_if_present {
 my($p,$historical)=@_;my($path,$type)=$p eq q{P0}?("$RESULT/pre_generation_manifest.sha256",q{F3_PRE_GENERATION_MANIFEST_V1}):$p eq q{P1}?("$RESULT/post_generation_manifest.sha256",q{F3_POST_GENERATION_MANIFEST_V1}):$p eq q{F0}?("$RESULT/final_artifacts.sha256",q{F3_FINAL_ARTIFACTS_MANIFEST_V1}):(undef,undef);return 1 unless defined($path);return 1 if inspect_path($path)->{state} eq q{ABSENT};validate_phase_evidence($path,$historical,$type,$p);return 1;
}
sub revalidate_seal_components {
 my($p,$result)=@_;validate_phase_evidence("$RESULT/$p.inputs.sha256",1,q{F3_INPUT_MANIFEST_V1},$p);validate_predecessors($p);revalidate_special_if_present($p,1);my(undef,$out)=validate_phase_evidence("$RESULT/$p.outputs.sha256",0,q{F3_OUTPUT_MANIFEST_V1},$p);if($result eq q{PASS}){my $pseudo={RESULT=>q{PASS},EXIT_STATUS=>q{0}};exact_phase_payload_evidence($p,$pseudo);no_entry("$CONTROL/first_contention.tsv")&&no_entry("$CONTROL/contention.candidate") or die "contention before terminal\n";}else{my(undef,undef,$status_path)=raw_targets($p);require_meta_value($out,q{RESULT},q{INVALID});slurp($status_path)=~/\A(?:0|[1-9][0-9]*)\n\z/ or die "invalid seal exit evidence\n";}return 1;
}
sub revalidate_terminal_chain_before_report {
 my($p,$type)=@_;validate_phase_evidence("$RESULT/$p.inputs.sha256",1,q{F3_INPUT_MANIFEST_V1},$p);validate_predecessors($p);revalidate_special_if_present($p,1);validate_phase_evidence("$RESULT/$p.outputs.sha256",0,q{F3_OUTPUT_MANIFEST_V1},$p);my(undef,$tm)=validate_phase_evidence(receipt_path($p),0,$type,$p);exact_phase_payload_evidence($p,$tm);return 1;
}
sub classify_normal_snapshot {
 my %phase;for my $p(@normal){if(phase_has_marker($p)){my $bundle=exact_phase_bundle($p);if($bundle->{ok}){$phase{$p}={class=>$bundle->{class},predicate=>$bundle->{predicate},exit=>$bundle->{exit},evidence=>$bundle->{evidence}};}else{my $receipt=inspect_path(receipt_path($p));$phase{$p}={class=>q{INVALID},predicate=>$bundle->{predicate},exit=>$bundle->{exit}//q{UNKNOWN},evidence=>$receipt->{state} eq q{FILE}?$receipt->{sha}:q{NOT_CREATED_BEFORE_INVALID}};}}else{$phase{$p}={class=>q{CLEAN_NEVER},predicate=>q{NONE},exit=>q{UNKNOWN},evidence=>q{NOT_CREATED_BEFORE_INVALID}};}}
 my $frontier=sub{for my $p(@normal){return $p if $phase{$p}{class}!~/\ACOMPLETE_/;}return q{F0};};if(defined($c0_run_input_error)){my($owner)=grep{phase_has_marker($_)}@normal;if(defined($owner)){my $receipt=inspect_path(receipt_path($owner));$phase{$owner}={class=>q{INVALID},predicate=>$c0_run_input_error,exit=>$phase{$owner}{exit}//q{UNKNOWN},evidence=>$receipt->{state} eq q{FILE}?$receipt->{sha}:q{NOT_CREATED_BEFORE_INVALID}};}}
 my $active=active_normal_phase();my $candidate=normal_candidate_phase();my $contention=contention_owner_phase();my $contention_candidate=contention_candidate_owner_phase();for my $pair([$active,q{RESIDUAL_ACTIVE_NORMAL_LEASE}],[$candidate,q{RESIDUAL_NORMAL_LEASE_CANDIDATE}],[$contention,q{CONTENTION_INVALIDATED_OWNER}],[$contention_candidate,q{RESIDUAL_CONTENTION_CANDIDATE}]){my($owner,$why)=@$pair;next unless defined($owner);if($owner eq q{MALFORMED}){$owner=$frontier->();$why=q{MALFORMED_GLOBAL_ATTEMPT_MARKER};}next if $phase{$owner}{class}=~/\A(?:INVALID|OUT_OF_ORDER)\z/;next if $why eq q{RESIDUAL_ACTIVE_NORMAL_LEASE}&&$phase{$owner}{class}!~/\ACOMPLETE_/;my $receipt=inspect_path(receipt_path($owner));$phase{$owner}={class=>q{INVALID},predicate=>$owner eq q{F0}&&$why eq q{RESIDUAL_ACTIVE_NORMAL_LEASE}?q{F0_SUCCESS_CLOSE_ACTIVE_LEASE}:$why,exit=>$phase{$owner}{exit}//q{UNKNOWN},evidence=>$receipt->{state} eq q{FILE}?$receipt->{sha}:q{NOT_CREATED_BEFORE_INVALID}};}
 my $gap=0;for my $p(@normal){if($phase{$p}{class} eq q{CLEAN_NEVER}){$gap=1;next;}if($gap&&$phase{$p}{class}=~/\ACOMPLETE_/){my $receipt=inspect_path(receipt_path($p));$phase{$p}={class=>q{OUT_OF_ORDER},predicate=>q{OUT_OF_ORDER_PHASE_AFTER_CLEAN_GAP},exit=>$phase{$p}{exit}//q{UNKNOWN},evidence=>$receipt->{state} eq q{FILE}?$receipt->{sha}:q{NOT_CREATED_BEFORE_INVALID}};}}
 my $seen_invalid=0;for my $p(@normal){if(!$seen_invalid&&($phase{$p}{class} eq q{INVALID}||$phase{$p}{class} eq q{OUT_OF_ORDER})){$seen_invalid=1;next;}next unless $seen_invalid;next if $phase{$p}{class} eq q{CLEAN_NEVER};my $receipt=inspect_path(receipt_path($p));$phase{$p}={class=>q{OUT_OF_ORDER},predicate=>q{PHASE_EVIDENCE_AFTER_FIRST_INVALID},exit=>$phase{$p}{exit}//q{UNKNOWN},evidence=>$receipt->{state} eq q{FILE}?$receipt->{sha}:q{NOT_CREATED_BEFORE_INVALID}};}
 my $first;for my $p(@normal){if($phase{$p}{class} eq q{INVALID}||$phase{$p}{class} eq q{OUT_OF_ORDER}){$first=$p;last;}}return {phase=>\%phase,first=>$first,predicate=>defined($first)?$phase{$first}{predicate}:undef,exit=>defined($first)?$phase{$first}{exit}:undef};
}
sub c0_manifest {
 my($snapshot)=@_;my $first=$snapshot->{first};my @never=grep{$snapshot->{phase}{$_}{class} eq q{CLEAN_NEVER}}@normal;my @u=all_fixed_universe();my @spec=map{[$_,q{CENSUS}]}@u;my @tail=unexpected_rows(\@u);my @m=([RESULT=>q{INVALID}],[FIRST_INVALID_PHASE=>$first],[FIRST_INVALID_PREDICATE=>$snapshot->{predicate}],[WRITER_LOCK_ACQUIRED=>q{YES}],[NORMAL_PHASES_NEVER_STARTED=>@never?join(q{,},@never):q{NONE}],[C0_ATTEMPT=>1]);return typed_evidence(q{F3_INVALID_CUSTODY_MANIFEST_V1},\@m,\@spec,\@tail);
}
sub run_c0 {
 my($admission,$writer)=@_;for my $p("$CONTROL/c0-lease.candidate","$CONTROL/active_c0_lease.tsv","$LEASES/C0.lease.tsv",candidate_path(q{C0},q{INVALID_MANIFEST}),candidate_path(q{C0},q{INVALID_REPORT}),"$RESULT/invalid_custody_manifest.sha256","$RESULT/INVALID_R3_REVERSE_BFS_PILOT_V3_RUN_REPORT.md"){no_entry($p) or die "C0 already consumed\n";}
 my $snapshot=classify_normal_snapshot();defined($snapshot->{first}) or die "C0 without consumed invalid attempt\n";
 my $candidate="$CONTROL/c0-lease.candidate";sysopen(my $h,$candidate,O_WRONLY|O_CREAT|O_EXCL|O_NOFOLLOW,0600) or die "C0 attempt boundary\n";sync_dir($CONTROL);chmod(0600,$candidate)==1 or die "C0 lease mode\n";my $lease=lease_text(q{C0},q{CUSTODY});binmode($h);print {$h}$lease or die "C0 lease write\n";sync_file($h);close($h) or die "C0 lease close\n";publish_existing_candidate($candidate,"$CONTROL/active_c0_lease.tsv",$lease);
 link("$CONTROL/active_c0_lease.tsv","$LEASES/C0.lease.tsv") or die "C0 archive link\n";sync_dir($LEASES);my $a=inspect_path("$CONTROL/active_c0_lease.tsv");my $z=inspect_path("$LEASES/C0.lease.tsv");$a->{state} eq q{FILE}&&$z->{state} eq q{FILE}&&$a->{inode} eq $z->{inode}&&$a->{sha} eq $z->{sha} or die "C0 archive readback\n";
 my $manifest=c0_manifest($snapshot);my $manifest_sha=publish_text(q{C0},q{INVALID_MANIFEST},"$RESULT/invalid_custody_manifest.sha256",$manifest);validate_evidence("$RESULT/invalid_custody_manifest.sha256",3,q{F3_INVALID_CUSTODY_MANIFEST_V1});my $report=invalid_report($snapshot,$manifest_sha);validate_evidence("$RESULT/invalid_custody_manifest.sha256",3,q{F3_INVALID_CUSTODY_MANIFEST_V1});publish_text(q{C0},q{INVALID_REPORT},"$RESULT/INVALID_R3_REVERSE_BFS_PILOT_V3_RUN_REPORT.md",$report);slurp("$RESULT/INVALID_R3_REVERSE_BFS_PILOT_V3_RUN_REPORT.md") eq $report or die "C0 report readback\n";flock($writer,LOCK_UN) or die "C0 writer unlock\n";flock($admission,LOCK_UN) or die "C0 admission unlock\n";return 0;
}

my @environment_keys=sort{$a cmp $b}keys%ENV;join("\n",@environment_keys) eq join("\n",qw(ELAN_HOME HOME LANG LC_ALL PATH TMPDIR)) or die "controller environment keys\n";$ENV{HOME} eq q{/Users/MoiTam}&&$ENV{ELAN_HOME} eq q{/Users/MoiTam/.elan}&&$ENV{PATH} eq q{/Users/MoiTam/.elan/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin}&&$ENV{LC_ALL} eq q{C}&&$ENV{LANG} eq q{C}&&$ENV{TMPDIR} eq $TMP or die "controller environment values\n";
for my $d($ROOT,$RESULT,$TMP,$CONTROL,$LEASES,$MEMORY,$FRAGMENTS,$SCRIPT_DIR){require_dir($d);}
my $admission=open_guard("$CONTROL/admission.guard",1);my $writer=open_guard("$CONTROL/writer.guard",0);$main::admission_fh=$admission;flock($admission,LOCK_EX) or die "admission lock\n";
unless(flock($writer,LOCK_EX|LOCK_NB)){publish_contention($phase);flock($admission,LOCK_UN) or die "contention unlock\n";exit 75;}
if($phase eq q{C0}){load_c0_frozen_context();exit run_c0($admission,$writer);}
cache_live_git_identity();validate_frozen_run_inputs($phase eq q{B0}?0:1);
check_normal_eligibility($phase);begin_normal_lease($phase);my $input=input_manifest($phase);publish_text($phase,q{INPUT},"$RESULT/$phase.inputs.sha256",$input);validate_phase_evidence("$RESULT/$phase.inputs.sha256",0,q{F3_INPUT_MANIFEST_V1},$phase);flock($admission,LOCK_UN) or die "payload admission release\n";
my($status,$metrics)=phase_work($phase);
if($status!=0){my $predicate=($metrics->{package_delta}//0)>0||($metrics->{sysroot_delta}//0)>0?q{PACKAGE_OR_SYSROOT_DELTA}:q{PAYLOAD_NONZERO};my $sealed=eligible_failure_seal($phase,$status,$metrics,$predicate);flock($writer,LOCK_UN) or die "failure writer unlock\n";flock($admission,LOCK_UN) or die "failure admission unlock\n";exit($sealed?$status:125);}
validate_phase_evidence("$RESULT/$phase.inputs.sha256",0,q{F3_INPUT_MANIFEST_V1},$phase);validate_predecessors($phase);flock($admission,LOCK_EX) or die "terminal admission\n";no_entry("$CONTROL/first_contention.tsv") or die "contention invalidated owner\n";validate_phase_evidence("$RESULT/$phase.inputs.sha256",0,q{F3_INPUT_MANIFEST_V1},$phase);validate_predecessors($phase);
if($phase eq q{P0}){publish_text($phase,q{SPECIAL},"$RESULT/pre_generation_manifest.sha256",special_manifest($phase));validate_phase_evidence("$RESULT/pre_generation_manifest.sha256",0,q{F3_PRE_GENERATION_MANIFEST_V1},q{P0});}
elsif($phase eq q{P1}){publish_text($phase,q{SPECIAL},"$RESULT/post_generation_manifest.sha256",special_manifest($phase));validate_phase_evidence("$RESULT/post_generation_manifest.sha256",0,q{F3_POST_GENERATION_MANIFEST_V1},q{P1});}
elsif($phase eq q{F0}){publish_text($phase,q{SPECIAL},"$RESULT/final_artifacts.sha256",special_manifest($phase));validate_phase_evidence("$RESULT/final_artifacts.sha256",0,q{F3_FINAL_ARTIFACTS_MANIFEST_V1},q{F0});}
archive_normal($phase);my $out=output_manifest($phase,q{PASS},$metrics);publish_text($phase,q{OUTPUT},"$RESULT/$phase.outputs.sha256",$out);validate_phase_evidence("$RESULT/$phase.outputs.sha256",0,q{F3_OUTPUT_MANIFEST_V1},$phase);my($terminal_result,$extra)=(q{PASS},[]);
if($phase eq q{F0}){my @rows=outcome_rows();my $def=grep{$_->{kind} eq q{DEFICIENT}}@rows;my $sat=6-$def;if($def){$terminal_result=q{STOP_R3_REVERSE_CAPACITY_COUNTEREXAMPLE_V3};$extra=[[FINAL_ARTIFACTS_SHA256=>sha_file("$RESULT/final_artifacts.sha256")],[TERMINAL_BRANCH=>q{ANY_DEFICIENT_SCOPED_STOP}],[CHECKER_CLASSIFICATION=>q{AT_LEAST_ONE_CHECKER_ACCEPTED_DEFICIENT_ROW}],[MACHINE_VERDICT=>$terminal_result],[SCOPED_CLASSIFICATION_1=>q{SIX_ROW_SATURATION_STOP}],[SCOPED_CLASSIFICATION_2=>q{FULL_CAPACITY_SUBROUTE_STOP}],[SCOPED_CLASSIFICATION_3=>q{NO_F3_STOP}],[SATURATED_ROWS=>$sat],[DEFICIENT_ROWS=>$def]];}else{$terminal_result=q{PASS_R3_REVERSE_BFS_PILOT_V3_6_OF_6};$extra=[[FINAL_ARTIFACTS_SHA256=>sha_file("$RESULT/final_artifacts.sha256")],[TERMINAL_BRANCH=>q{ALL_SIX_SATURATED_PASS}],[CHECKER_CLASSIFICATION=>q{SIX_CHECKER_ACCEPTED_SATURATED_ROWS}],[MACHINE_VERDICT=>$terminal_result],[SCOPED_CLASSIFICATION_1=>q{SIX_OWNER_SATURATION_PASS}],[SCOPED_CLASSIFICATION_2=>q{NOT_APPLICABLE}],[SCOPED_CLASSIFICATION_3=>q{NOT_APPLICABLE}],[SATURATED_ROWS=>6],[DEFICIENT_ROWS=>0]];}}
revalidate_seal_components($phase,q{PASS});
my $terminal_text=terminal_receipt($phase,$terminal_result,0,$extra,0);publish_text($phase,q{TERMINAL},receipt_path($phase),$terminal_text);validate_phase_evidence(receipt_path($phase),0,$phase eq q{F0}?q{F3_F0_TERMINAL_RECEIPT_V1}:q{F3_PHASE_TERMINAL_RECEIPT_V1},$phase);
if($phase eq q{F0}){my $report=normal_report(meta_map($terminal_text));revalidate_terminal_chain_before_report(q{F0},q{F3_F0_TERMINAL_RECEIPT_V1});publish_text($phase,q{REPORT},"$RESULT/F3_R3_REVERSE_BFS_PILOT_V3_RUN_REPORT.md",$report);my $custody=report_custody($report);publish_text($phase,q{REPORT_CUSTODY},"$RESULT/F0_report_custody_receipt.sha256",$custody);validate_evidence("$RESULT/F0_report_custody_receipt.sha256",0,q{F3_F0_REPORT_CUSTODY_V1});}
unlink("$CONTROL/active_normal_lease.tsv") or die "active lease unlink\n";sync_dir($CONTROL);flock($writer,LOCK_UN) or die "writer unlock\n";flock($admission,LOCK_UN) or die "admission unlock\n";exit 0;

F3_CONTROLLER_PROGRAM_V1
readonly CONTROLLER_PROGRAM_V1

exec /usr/bin/env -i \
  HOME=/Users/MoiTam \
  ELAN_HOME=/Users/MoiTam/.elan \
  PATH=/Users/MoiTam/.elan/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin \
  LC_ALL=C LANG=C TMPDIR="$tmp_root" \
  /opt/homebrew/Cellar/coreutils/9.7/bin/gtimeout --foreground --signal=TERM --kill-after=5 "$ceiling" \
  /usr/bin/perl -e "$CONTROLLER_PROGRAM_V1" "$phase"
