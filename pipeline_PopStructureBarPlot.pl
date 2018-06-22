#!/usrbin/perl -w



#this is the pipeline to process admixture results

print "usage:\nperl pipeline_PopStructureBarPlot.pl 869\n\n";

print "please set the number of accession\n" if !$ARGV[0];
$acc=$ARGV[0];


print "merge 10 repeats of asmixture runs\n\n";
`perl run_clumpp_s1.pl $acc`;
`perl run_clumpp_s2.pl $acc`;


print "#parse the Q matirx, into the format needed by pophelper\n\n";
`perl generate_structureBarPlot_s1.pl $acc`;
#`perl generate_structureBarPlot_s2.pl $acc`;



$in="tmpdir/acc$acc"."_maf001_thin1k_ld04_ind.*";
$dir="admixture/acc$acc"."_maf001_thin1k_ld04_merged/";
#`mv $in $dir`;

