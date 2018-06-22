#!/usr/bin/perl -w



#the output of fd statistic, calculated using:
#https://github.com/simonhmartin/genomics_general




##################################################################
##################################################################
##################################################################
##################################################################





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






#get all the files of fd statistics
#window size =100 SNP sites
@file=glob("introgression/fd/results/accession_based/landrace_100site/out100*");
@file1=glob("introgression/fd/results/accession_based/cultiva_100site/outACC100*");
@file2=glob("introgression/fd/results/accession_based/landraceOther_100site/out100site_*");


#winodw size =1Mb
#@file=glob("introgression/fd/results/accession_based/landrace_1Mb/out*");
#@file1=glob("introgression/fd/results/accession_based/cultiva_1Mb/out*");

#window size =100Kb
#@file=glob("introgression/fd/results/accession_based/landrace_100Kb/out100k_lr_ExomeCapture-*");
#@file1=glob("introgression/fd/results/accession_based/cultiva_100Kb/out100k_cul_ExomeCapture-*");

push @file,@file1;
push @file,@file2;

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



		#$allwin{$tem[0]."\t".$tem[1]."\t".$tem[2]}++;
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



#output freq. of introgression
open NN,">tmpdir/info" or die "l";
print NN "#fd_value\tfreq_introgression\n";
foreach (sort keys %$dat){
	
	@tem=split/\t/;
	
	$ww=$tem[1]."\t".$tem[2]."\t".$tem[3];
	$freq=$fdwin{$ww}  if  exists $fdwin{$ww};
	$freq=0  if  !exists $fdwin{$ww};
	print NN "$dat->{$_}\t$freq\n";
}
close NN;




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






#R code
#ggplot()+geom_point(aes(x=iw$m1,y=iw$m2),color='black',size=1)+ geom_errorbar(aes(x=iw$m1,ymax = iw$m2 + iw$c2, ymin=iw$m2 - iw$c2),color='red')+geom_line(data=iw,aes(iw$m1,iw$m2),color='red')+theme_bw()+theme(axis.text=element_text(size=12))+     theme(panel.grid.major=element_blank(),panel.grid.minor=element_blank())+   labs(x='fd value, N=1052k',y="freq. of accession where a window is fd>0")+  theme(plot.margin=unit(c(2,2,2,2),"cm"),axis.title=element_text(size=12,face="bold"))
#ggsave('1.pdf',height = 5,width =5)





