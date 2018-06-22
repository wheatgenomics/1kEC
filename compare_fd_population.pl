#!/usr/bin/perl -w

#compare pop-fd based introgression

#the output of fd statistic, calculated using:
#https://github.com/simonhmartin/genomics_general
#is in the folder:
#fd/results/population_based/

#this script parses the data into file that can be R plot


@file=glob("introgression/fd/results/population_based/LRgroup/out100site*");
#@file=glob("introgression/fd/results/population_based/LRgroup/out1m*");

open NN,">tmpdir/aa" or die "l";
foreach $in(@file){
	
	@name=split/group_/,$in;
	open MM,"$in" or die "l";
	while(<MM>){
		chomp;
		@tem = split /,/;
		next if $_=~/^sca/;
		next if $tem[7] eq "nan";
		next if $tem[7] >1 || $tem[7]<0;
		next if $tem[5]<3;
		
		print NN "$name[-1]\t$tem[7]\n";
		$dat->{$name[-1]}->{$tem[0]."\t".$tem[1]."\t".$tem[2]}=$tem[7];
	}
	close MM;


}
close NN;

#compare the top5% fd windows

open AA,">tmpdir/res_lengthTotal" or die "l"; # total length of top5% window in each pop
open AAA,">tmpdir/res_lengthSegment" or die "l"; # length of segment, defined by top5% window in each pop
open NN,">tmpdir/aa1" or die "l";
foreach $in(sort keys %$dat){
	print "$in\n";
	@name=split/_/,$in;
	%hash=%{$dat->{$in}};
	undef @oo;
	foreach (sort {$hash{$a}<=>$hash{$b} || $a cmp $b} keys %hash ){
		push @oo,$_;
	}
	#$n=@oo/20; # top5%
	
	open BB,">tmpdir/bb" or die "l";
	#for($i=-1;$i>-$n;$i--){ #top5%
	for($i=0;$i<@oo;$i++){
		print NN "$in\t$dat->{$in}->{$oo[$i]}\n";
		print BB "$oo[$i]\n";

	}
	close BB;

	`sort-bed tmpdir/bb > tmpdir/bb1`;
	`bedops -m tmpdir/bb1 > tmpdir/bb`;
	$ll=&getLen("tmpdir/bb");
	print AA "$name[-1]\t$ll\n"; #total length of introgression for each population


	#`bedops -m --range 100000 tmpdir/bb > tmpdir/bb1`;
	`bedops -m --range 500000 tmpdir/bb > tmpdir/bb1`;
	open TM,"tmpdir/bb1" or die "l";
	while(<TM>){
		chomp;
		@tem=split/\t/;
		$ll=$tem[2]-$tem[1];
		print AAA "$name[-1]\t$ll\n"; # length of introgressed segment
	}


}
close NN;
close AA;
close AAA;




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


	return $l1;



}





