#!/usrbin/perl -w

open MM,"../1000EC/tmpdir/geneList.info" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	$gene2info{$tem[2]}=$_;

}
close MM;





#@file=glob("tmpdir/aa.T*_pi.sites.pi");
@file=glob("tmpdir/aa.T*_pi.windowed.pi");
#@file=glob("tmpdir/pi/$ARGV[0]/aa.T*_pi.sites.pi");



open NN,">tmpdir/res2" or die "l";
foreach $in(@file){

	@name=split/aa\.|_pi/,$in;
	$in2=$in;
	$in2=~s/aa/bb/;
	$ff="tmpdir/bb.".$name[-2];
	#$ff="tmpdir/pi/$ARGV[0]/bb.".$name[-2];
	open MM,"$ff" or die "l";
	$N=@all=<MM>;
	close MM;


	`cp $in tmpdir/aa`;
	`cp $in2 tmpdir/bb`;
	
	open MM,"tmpdir/aa" or die "l";
	$n=@all=<MM>;
	close MM;

	`R CMD BATCH t-test.r `;

	next if !-e "tmpdir/out";
	open MM,"tmpdir/out" or die "l";
	@all=<MM>;
	close MM;
	
	next if $all[0] =~/na/i;

	$pv=sprintf "%.2e",$all[0];
	$v1=sprintf "%.2e",$all[1];
	$v2=sprintf "%.2e",$all[2];
	$pv2=sprintf "%.2e",$all[3];
	$dd=sprintf "%.2e",($v1-$v2);


	$N=795-$N;
	print NN "$N\t$n\t$pv\t$pv2\t$v1\t$v2\t$dd\t$gene2info{$name[-2]}\n";
	print "$in\t$pv\t$pv2\t$v1\t$v2\t$dd\n";
	unlink("tmpdir/out");

}
close NN;




