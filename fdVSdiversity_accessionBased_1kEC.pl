#!/usr/bin/perl -w





#the output of fd statistic, calculated using:
#https://github.com/simonhmartin/genomics_general
#is in the folder:
#fd/results/population_based/


#this script compare the pi from 1kEC against introgression defined of count of fd positive accessions


#this script parses the data into file that can be R plot





use Statistics::RankCorrelation;
open NN,">tmpdir/aa" or die "l";
open MM,"summary_resultsData/info_fdCount.allAccession" or die "l";
while(<MM>){
	next if $_=~/^#/;
	chomp;
	@tem=split/\t/;
	print NN "$tem[0]\t$tem[1]\t$tem[2]\t$tem[0]:$tem[1]\t$tem[3]\n";

}
close MM;
close NN;
`sort-bed tmpdir/aa >tmpdir/aa1`;

#those statistic are based on 1kEC SNP. Not the share SNP!
@file=glob("basic_popGen_statistic/pi_*sites.pi");

foreach $in(@file){

#next if $in!~/durum/i;

print "$in\n";
open NN,">tmpdir/aa" or die "l";
open MM,"$in" or die "l";
while(<MM>){
	next if $_=~/^CHROM/;
	chomp;
	@tem=split/\t/;
	$tem[0]=&changeName2($tem[0]);
	next if $tem[0]=~/D/;
	next if $tem[2]=~/nan/i;
	$p1=$tem[1]-1;
	$p2=$tem[1]+2;
	$p1=1 if $p1<1;
	
	print NN "$tem[0]\t$p1\t$p2\t$tem[0]:$p1\t$tem[2]\n";
}
close MM;
close NN;

`sort-bed tmpdir/aa >tmpdir/aa2`;
`bedmap --echo --count --mean tmpdir/aa1 tmpdir/aa2 > tmpdir/res`;
`sed -i 's/|/\t/g' tmpdir/res`;
@name=split/_/,$in;
$new="out_fdVSpi_$name[-2]";


#output
#col5: introgression freq.
#col6: # of SNP in the window
#col7: pi for that window
`mv tmpdir/res  tmpdir/$new`;


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






