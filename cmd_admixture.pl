#!/usr/bin/perl -w

#this is the script to run admixture on beocat


















$in="/homes/feihe/project/admixture/tmpdir/acc283/acc283.bed";

open NN,">runA10.sh" or die "l";




for($k=2;$k<20;$k=$k+1){

	$ii++;
	$err=$in.".$k.log";
	$rr=1+int rand (10000);
	#$cmd="/homes/feihe/tool/admixture_linux-1.3.0/admixture  --supervised  --cv -s $rr  $in $k -j8   > $err";
	$cmd="/homes/feihe/tool/admixture_linux-1.3.0/admixture    --cv -s $rr  $in $k -j8   > $err";
	$out="$in".".$k".".finished";

	print NN "date\n";
	print NN "if [ \$SGE_TASK_ID == $ii ]; then\n";
	
	print NN "$cmd\n";
	print NN "touch $out\n";
	
	print NN "fi\ndate\n\n";



}
close NN;
