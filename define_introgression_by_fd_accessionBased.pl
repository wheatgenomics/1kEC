#!/usr/bin/perl -w



#the output of fd statistic, calculated using:
#https://github.com/simonhmartin/genomics_general
#is in the folder:
#fd/results/population_based/


#this script will read all the accession based fd statistics, 
#then, it outputs introgression hotspot, desert , freq. of introgression and etc.


##################################################################
##################################################################
##################################################################
##################################################################




=head
#read sample information
open MM,"data/sample_for_populationStructureAnalysis.txt" or die "l";
while(<MM>){
	chomp;
	next if $_=~/^acc/;
	@tem=split/\t/;
	next if $_=~/^accession|outgroup/; # exclude outgroup
	next if $tem[1] eq "AVS" && $_=~/AUSTRALIA/; # exclude Australia AVS lines.
	#next if $tem[5] ne "cul" && $tem[5] ne "lr" ;
	next if $_=~/published|dicoccon/; 
	$acc2country{$tem[0]}=$tem[3];

	$acc{$tem[0]}=1;


}
close MM;
$n=@tem=keys %acc;
print "$n\n";
=cut


open MM,"data/1kEC_sample_information_updated02022018.txt" or die "l";
#open MM,"/home/DNA/shared_project/1000EC/data/sample_for_populationStructureAnalysis.txt" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	#next if $tem[5] ne "lr" ;
	next if $tem[0] =~/accession/;
	next if $tem[1] eq "AVS" && $_=~/AUSTRALIA/;
	next if $_=~ /outgroup/;
	#$acc2imp{$tem[0]}=$tem[5];
	

	if($tem[5]=~/lr/ || $tem[4] =~/compactum|macha|spelta|sphaerococcum/){
		$acc{$tem[0]}=1;
	}

}
close MM;

	







#get all the files of fd statistics
#window size =100 SNP sites
#@file=glob("introgression/fd/results/accession_based/landrace_100site/out100*");
#@file1=glob("introgression/fd/results/accession_based/cultiva_100site/outACC100*");
#@file2=glob("introgression/fd/results/accession_based/landraceOther_100site/out100site_*");


#winodw size =1Mb
@file=glob("introgression/fd/results/accession_based/landrace_1Mb/out*");
#@file1=glob("introgression/fd/results/accession_based/cultiva_1Mb/out*");

#window size =100Kb
#@file=glob("introgression/fd/results/accession_based/landrace_100Kb/out100k_lr_ExomeCapture-*");
#@file1=glob("introgression/fd/results/accession_based/cultiva_100Kb/out100k_cul_ExomeCapture-*");

#push @file,@file1;
#push @file,@file2;

foreach $in(@file){
	#print "$in\n";
	@name=split/group_|_/,$in;

	next if !exists $acc{$name[-1]}; #ignore Australia AVS lines
	
	print "$in\n" if exists $rec{$name[-1]};
	$rec{$name[-1]}=1;

	$n1++;
	open MM,"$in" or die "l";
	while(<MM>){
		chomp;
		@tem = split /,/;
		next if $_=~/^sca/;
		$tem[0]=&changeName2($tem[0]);

		next if $tem[5]<10;#ignore windows with few SNP. 



		$allwin{$tem[0]."\t".$tem[1]."\t".$tem[2]}++;
		next if $tem[7] eq "nan"; #ignore windows where fd is 'nan'.
		next if $tem[7] >1 || $tem[7]<0; #ignore windows where fd is not in the range of [0,1]
		
		$fdwin{$tem[0]."\t".$tem[1]."\t".$tem[2]}++; #count freq. of fd positive window
		
		
		
		#$dat->{$name[-1]}->{$tem[0]."\t".$tem[1]."\t".$tem[2]}=$tem[7];
		$dat->{$name[-1]."\t".$tem[0]."\t".$tem[1]."\t".$tem[2]}=$tem[7];
	}
	close MM;


}
close NN;
print "\n$n1 acc\n";
$n=@tem=keys %rec;
print "real acc=$n\n";


open NN,">tmpdir/aa" or die "l";
open NNN,">tmpdir/aa1" or die "l";

#output freq. of introgression
open FF,">tmpdir/info" or die "l";
foreach (sort keys %allwin){
	
	@tem=split/\t/;
	
	print NNN "$tem[0]\t$tem[1]\t$tem[2]\n" if exists $fdwin{$_} && $fdwin{$_}>400;
	
	
	print FF "$tem[0]\t$tem[1]\t$tem[2]\t$fdwin{$_}\n" if  exists $fdwin{$_};
	print FF "$tem[0]\t$tem[1]\t$tem[2]\t0\n" if  !exists $fdwin{$_};
	
	
	
	#set the cutoff for desert here:
	next if exists $fdwin{$_}; #freq of fd positive=0 for desert
	#next if $fdwin{$_}>1; #freq of fd positive no more than 1 for desert
	#next if $fdwin{$_}>2; #freq of fd positive no more than 2 for desert
	


	#output desert
	print NN "$tem[0]\t$tem[1]\t$tem[2]\n";
	
}
close NN;
close NNN;



die;

#more output in the following

`sort-bed tmpdir/aa > tmpdir/bb`;
`bedops -m tmpdir/bb > tmpdir/info_introgressionDesert`;
$ll=&getLen("tmpdir/info_introgressionDesert");
print "introgression dersert\t$ll\n\n";


`sort-bed tmpdir/aa1 > tmpdir/bb`;
`bedops -m tmpdir/bb > tmpdir/info_introgressionCount400`;
$ll=&getLen("tmpdir/info_introgressionCount400");
print "introgression hotspot, where freq of a window > 400\t$ll\n\n";








%hash=%$dat;
undef @oo;
foreach (sort {$hash{$a}<=>$hash{$b} || $a cmp $b} keys %hash ){	
	push @oo,$_;
	#print "$_\t$hash{$_}\n";
}
$n=-int @oo/100;
print "cutoff using top percentile fd=$hash{$oo[$n]}\t$n\n\n\n";

#output top1% fd windows
open NN,">tmpdir/info_introgressionTop1p" or die "l";
for($i=-1;$i>$n;$i--){
	@tem=split/\t/,$oo[$i];
	shift @tem;
	print NN "$tem[0]\t$tem[1]\t$tem[2]\n";
}
close NN;

#merge overlapping windows
`sort-bed tmpdir/info_introgressionTop1p > tmpdir/aa`;
`bedops -m tmpdir/aa > tmpdir/info_introgressionTop1`;
$ll=&getLen("tmpdir/info_introgressionTop1p");
print "all introgression for the top1% fd windows, after merged:\t$ll\n";











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




sub changeName1{

		my $id=$_[0];
		my $id2;
$id2=	1	if	$id eq 	"chr1A"	;
$id2=	2	if	$id eq	"chr1B"	;
$id2=	3	if	$id eq	"chr1D"	;
$id2=	4	if	$id eq	"chr2A"	;
$id2=	5	if	$id eq	"chr2B"	;
$id2=	6	if	$id eq	"chr2D"	;
$id2=	7	if	$id eq	"chr3A"	;
$id2=	8	if	$id eq	"chr3B"	;
$id2=	9	if	$id eq	"chr3D"	;
$id2=	10	if	$id eq	"chr4A"	;
$id2=	11	if	$id eq	"chr4B"	;
$id2=	12	if	$id eq	"chr4D"	;
$id2=	13	if	$id eq	"chr5A"	;
$id2=	14	if	$id eq	"chr5B"	;
$id2=	15	if	$id eq	"chr5D"	;
$id2=	16	if	$id eq	"chr6A"	;
$id2=	17	if	$id eq	"chr6B"	;
$id2=	18	if	$id eq	"chr6D"	;
$id2=	19	if	$id eq	"chr7A"	;
$id2=	20	if	$id eq	"chr7B"	;
$id2=	21	if	$id eq	"chr7D"	;
$id2=	22	if	$id eq	"chrUn"	;



		return $id2;
}






sub changeName2{
		
		my $id=$_[0];
		my $id2;
$id2= "chr1A" if $id== 1 ;
$id2= "chr1B" if $id== 2 ;
$id2= "chr1D" if $id== 3 ;
$id2= "chr2A" if $id== 4 ;
$id2= "chr2B" if $id== 5 ;
$id2= "chr2D" if $id== 6 ;
$id2= "chr3A" if $id== 7 ;
$id2= "chr3B" if $id== 8 ;
$id2= "chr3D" if $id== 9 ;
$id2= "chr4A" if $id== 10 ;
$id2= "chr4B" if $id== 11 ;
$id2= "chr4D" if $id== 12 ;
$id2= "chr5A" if $id== 13 ;
$id2= "chr5B" if $id== 14 ;
$id2= "chr5D" if $id== 15 ;
$id2= "chr6A" if $id== 16 ;
$id2= "chr6B" if $id== 17 ;
$id2= "chr6D" if $id== 18 ;
$id2= "chr7A" if $id== 19 ;
$id2= "chr7B" if $id== 20 ;
$id2= "chr7D" if $id== 21 ;
$id2= "chrUn" if $id== 22 ;



		return $id2;

}





