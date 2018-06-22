#!/usrbin/perl -w
use Statistics::Basic qw(:all);


`rm tmpdir/recombin_bin*`;

open MM,"/home/DNA/shared_project/1000EC/data/sample_for_populationStructureAnalysis.txt" or die "l";

while(<MM>){
	chomp;
	@tem=split/\t/;
	#next if $tem[5] ne "lr" ;
	next if $tem[0] =~/accession/;
	next if $tem[1] eq "AVS" && $_=~/AUSTRALIA/;
	next if $tem[4]!~/compactum|macha|spelta|sphaerococcum|aestivum/;
	
	
	$allacc{$tem[0]}=1;

}
close MM;
$n=@tem=keys %allacc;
print "$n acc\n";
	





`cat ~/project/1000genome/res_data/recombRate_chr* > tmpdir/recombABD`;


$in="tmpdir/recombABD";

open NN,">tmpdir/cc" or die "l";
open MM,"$in" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	if( $tem[5]==0){
		$hash0{$tem[0]."\t".$tem[1]."\t".$tem[2]}=1;
		print NN "$tem[0]\t$tem[1]\t$tem[2]\n";
	}else{
	
		$hash{$tem[0]."\t".$tem[1]."\t".$tem[2]}=$tem[5];
	}

}
close MM;
`sort-bed tmpdir/cc > tmpdir/recombin_bin100`;

undef @oo;
foreach (sort {$hash{$a}<=>$hash{$b} || $a cmp $b} keys %hash){
	push @oo,$_;
}

$n=@oo/20;


open II,">tmpdir/info" or die "l";
open NN,">tmpdir/aa" or die "l";
for($x=0;$x<20;$x++){
	open NN,">tmpdir/cc" or die "l";
	$j1=int $x*$n;
	$j2=int ($x+1)*$n;
	$j2=@oo if $x==19;

	undef @tem;
	for($i=$j1;$i<$j2;$i++){
		print NN "$oo[$i]\n";
		push @tem,$hash{$oo[$i]};
	}
	close NN;
	$n=@tem;
	$m1=sprintf "%.4f",mean(@tem);
	$m2=sprintf "%.4f",median(@tem);
	$new="tmpdir/recombin_bin$x";
	`sort-bed tmpdir/cc > $new`;

	$ll=&getLen($new);

	print  II "$x\t$m1\t$m2\t$ll\t$n\n";
}
close II;







@file=glob("tmpdir/recombin_bin*");



open NN,">tmpdir/res" or die "l";
foreach $in(@file){
	#for each bin
	
	#next if $in!~/19/;

	@name=split/bin/,$in;
	$name[-1]++;
	foreach $acc(sort keys %allacc ){
	
		$i1="tmpdir/geneticLoad_acc/dAllele.$acc";
		$i2="tmpdir/geneticLoad_acc/synAllele.$acc";
		$i3="tmpdir/geneticLoad_acc/nsynAllele.$acc";
		next if !-e $i1;
		
		open MM,"$i1" or die "l";
		$a1=@all=<MM>;
		close MM;
		open MM,"$i2" or die "l";
		$a2=@all=<MM>;
		close MM;


		$n1=0;
		print "$in\t$i1\n";
		$cmd="bedmap --echo --skip-unmapped  $i1 $in > tmpdir/aa ";
		#print "$cmd\n\n";
		`$cmd`;
		open MM,"tmpdir/aa" or die "l";
		$n1=@all=<MM>;
		close MM;
		

		$n2=0;
		$cmd="bedmap --echo --skip-unmapped  $i2 $in > tmpdir/aa ";
		#print "$cmd\n\n";
		`$cmd`;
		open MM,"tmpdir/aa" or die "l";
		$n2=@all=<MM>;
		close MM;
	

		$n3=0;
		$cmd="bedmap --echo --skip-unmapped  $i3 $in > tmpdir/aa ";
		#print "$cmd\n\n";
		`$cmd`;
		open MM,"tmpdir/aa" or die "l";
		$n3=@all=<MM>;
		close MM;
	




		print NN "$acc\t$name[-1]\t$n1\t$n2\t$n3\n";
	
	}



	

}

close NN;
















	
sub getLen{
	my $in=shift;
	my $l2;
	my $l1=0;

	open MM,"$in" or die "l";
	my @all=<MM>;
	close MM;
	foreach $in (@all){
		chomp $in;
		@tem=split/\t|\|/,$in;
		$l2 = $tem[2]-$tem[1];
		$l1 += $l2;
	
	}

	$l1=sprintf "%.2e",$l1;
	return $l1;



}
