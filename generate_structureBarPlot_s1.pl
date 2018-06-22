#!/usrbin/perl -w

#updated on 02222018

print "usage:\n perl generate_structureBarPlot_s1.pl number_of_acc\n";
print "this script uses number_of_accession to represent the dataset of ADMIXTURE results\n\n";



#outliers are detected based on phylogenetic tree analysis.
#One wild emmer and one domesticated are removed in this analysis
open MM,"resultsData/sampleList_outlier" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	next if $_!~/emmer/;
	next if !$tem[3] || $tem[3] ne "Y";
	$bad{$tem[0]}=1;

}
close MM;
$n=@tem=keys %bad;
print "$n bad samples\n";



print "read metadata for samples. Which geo group?\n";
open MM,"data/sample_for_populationStructureAnalysis.txt" or die "l";
while(<MM>){
	chomp;
	next if $_=~/^acc/;
	@tem=split/\t/;
	
	next if exists $bad{$tem[0]};

	$acc2country{$tem[0]}=$tem[3];
	
	if($tem[1] eq "published" && $tem[6] =~/domesticatedE/){
		$tem[6]="_".$tem[6];
	}

	if($tem[1] ne "published" && $tem[6] =~/domesticatedE/){
		$tem[6]="_1k_".$tem[6];
	}

	if($tem[1] eq "published" && $tem[6] =~/wild/){
		$tem[6]="_".$tem[6];
	}


	$acc2info{$tem[0]}=$tem[6];
	
}
close MM;

$n=@tem=keys %acc2info;
print "$n accession has groups\n";


print "get the order of sample ID from fam file\n";
print "Hint: the fam file, is related to bed and bim file\n\n";


$acc=$ARGV[0];
$in="admixture/acc$acc"."_maf001_thin1k_ld04_rep0/acc$acc"."_maf001_thin1k_ld04.fam";
open MM,"$in" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t|\s/;
	push @sample,$tem[0] ;# if exists $acc2info{$tem[0]};
}
close MM;








$in="tmpdir/acc$acc"."_maf001_thin1k_ld04_ind.*out";
print "For, $in \nthose files are generated from previous step, run_clumpp_s2.pl\n\n";


@file=glob("$in");

foreach $in(@file){
	print "$in\n";
	undef %data;
	undef %data2;
	open TM,">tmpdir/popLabel_acc$acc.txt" or die "l";
	open TMM,">tmpdir/indLabel_acc$acc.txt" or die "l";

	$x=-1;
	open NN,">$in.forPlot" or die "l";
	open NNN,">$in.forHumanCheck" or die "l";



	open MM,"$in" or die "l";
	while(<MM>){
		chomp;
		$_=~s/^\s+//;
		@tem=split/\s+|\t/;
		shift @tem;
		shift @tem;
		shift @tem;
		shift @tem;
		shift @tem;

		$ll=join "\t",@tem;
	
		$x++;


		if(  !exists $acc2info{$sample[$x]}){
			#print "==$x\n";
			next;
		}
	
	
		push @{$data{$acc2info{$sample[$x]}}},$ll;
		push @{$data2{$acc2info{$sample[$x]}}},$sample[$x];

	

	
	}
	close MM;


	foreach $aa(sort keys %data){
		#$aa is group name

		for($i=0;$i<@{$data{$aa}};$i++){
			#$i is membership assignment
		
			print NN "$data{$aa}[$i]\n";
			print TM "$aa\n";
			print TMM "$data2{$aa}[$i]\n";
			
			print NNN "$data2{$aa}[$i]\t$aa\t$acc2country{$data2{$aa}[$i]}\t$data{$aa}[$i]\n";
		}

	}

	close NN;
	close TM;
	close TMM;



}
