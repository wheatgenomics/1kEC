#!/usr/bin/perl -w
use Parallel::ForkManager;



#This script rank the SNP based on bf factors of bayenv2 analysis.



@file=glob("/home/DNA/shared_project/1000EC/bayenv/bf/resMedian_*");

$pm = new Parallel::ForkManager(16);
foreach $in(@file){
	my $pid = $pm->start and next;
	print "processing $in\n";
	@name2=split/resMedian_/,$in;

	undef %hash;
	open MM,"$in" or die "l";
	while(<MM>){
		chomp;
		@tem=split/\t/;
		$hash{$tem[0]."\t".$tem[1]}=$tem[2];
	}
	close MM;
	undef @tem;
	foreach (sort {$hash{$a}<=>$hash{$b} || $a cmp $b} keys %hash){
		push @tem, $_;
	}

	
	#set how many bins you want to create for each bioclimate variable
	#20 bins
	$n=int @tem/20;

	print "bin=$n\n";
	for($x=0;$x<20;$x++){
		open NN,">tmpdir/$name2[-1]" or die "l";
	
		$j1=int $x*$n;
		$j2=int ($x+1)*$n;
		$j2=@tem if $x==19;
		#print "$j1\t$j2\n";
		for($i=$j1;$i<$j2;$i++){
			#$rr=int rand @tem;

			@name=split/\t/,$tem[$i];
			$p1=$name[1]-1;
			$p2=$name[1]+1;
			print NN "$name[0]\t$p1\t$p2\t.\t$hash{$tem[$i]}\n";
		}
		close NN;
	
		$new="tmpdir/bf_bin$x"."_$name2[-1]";
		print "$new\n";
		`sort-bed tmpdir/$name2[-1] > $new`;

	}



	$pm->finish;

}

$pm->wait_all_children;


#mv tmpdir/bf_bin* bayenv/bf/20bins/




















