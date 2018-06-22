#!/usrbin/perl -w



#this scripts extract the data from the output of SNPeff.
#then, extract synonymous SNPs and SNPs with strong effect


#The SNPeff file are provided by Gabriel Keeble-Gagnere
#This script outputs bed formart files for SNP with strong effect or synonymous effect

#the output of this script can be used to calculate the genetic load(ratio of strong/syn) among different genomic regions, using bedops






print "read SNP id/position information\n\n";
open MM,"/home/feihe/project/1000genome/data/170208_AllChr-IWGSC_WGA_v1_SNPList.vcf" or die "l";
while(<MM>){
	chomp;
	next if $_=~/^#CHROM/;
	@tem=split/\t/;

	#snpID = SNP position
	$id{$tem[2]}=$tem[0]."_".$tem[1];
}
close MM;


print "read SNP freq information\n\n";
open MM,"resultsData/info_wheat784_plink.frq" or die "l";
while(<MM>){
	chomp;
	next if $_=~/MAF/;
	$_=~s/^\s+//g;
	@tem=split/\s+/;
	
	#set maf:
	next if $tem[4] <0.002;
	#next if $tem[4] <0.05;
	
	
	@name=split/_/,$tem[1];
	$ss=$name[1]."_".$name[2];
	$ss=$id{$ss};
	
	#record SNP freq
	$snp2v{$ss}=$tem[4];
}
close MM;
$n=@tem=keys %snp2v;
print "$n SNP have maf>0.002, and will be included in the analysis\n";


print "read SNPeff information\n\n";
open MM,"/home/feihe/project/1000genome/data/170208_AllChr-IWGSC_WGA_v1_SNPList.ann.HC.vcf" or die "l";
while(<MM>){
	chomp;
	next if $_=~/^#/;
	@tem=split/\t/;
	$ss=$tem[0]."_".$tem[1];

	#ignore SNP that have maf<0.002 in the 784 wheat samples
	next if !exists $snp2v{$ss};		
	
	$eff{$ss}=1;
	
	
	if($_=~/synonymous_variant/){
		$dat->{"syn"}->{$ss}=1;
	}
	if($_=~/\|HIGH\|/){
		$dat->{"HIGH"}->{$ss}=1;
	}
	if($_=~/\|MODERATE\|/){
		$dat->{"MODERATE"}->{$ss}=1;
	}
	
	$allsnp{$ss}=1;

}
close MM;





#do you want to include SNP effect based on LC gene model in the analysis?
open MM,"/home/feihe/project/1000genome/data/170208_AllChr-IWGSC_WGA_v1_SNPList.ann.LC.vcf" or die "l";
while(<MM>){
	chomp;
	next if $_=~/^#/;
	@tem=split/\t/;
	$ss=$tem[0]."_".$tem[1];
	next if !exists $snp2v{$ss};		
	
	$eff{$ss}=1;
	
	if($_=~/synonymous_variant/){
		$dat->{"syn"}->{$ss}=1;
	}
	if($_=~/\|HIGH\|/){
		$dat->{"HIGH"}->{$ss}=1;
	}
	if($_=~/\|MODERATE\|/){
		$dat->{"MODERATE"}->{$ss}=1;
	}
	
	$allsnp{$ss}=1;
	
	

}
close MM;



print "generate output file of SNP effect \n\n";
open NN,">tmpdir/info_SNPeff" or die "l";
#foreach (sort keys %snp2v){
foreach (sort keys %allsnp){
	if(exists $dat->{'HIGH'}->{$_}){
		print NN "$_\tHIGH\n";
	}
	if(exists $dat->{'MODERATE'}->{$_}){
		print NN "$_\tMODERATE\n";
	}
	if(exists $dat->{'syn'}->{$_}){
		print NN "$_\tsyn\n";
	}
}
close NN;






open AA,">tmpdir/aa" or die "l";
open BB,">tmpdir/bb" or die "l";
open MM,"tmpdir/info_SNPeff" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	@name=split/_/,$tem[0];
	$p2=$name[1]+2;
	
	#if($tem[1] =~/HIGH|MODERATE|LOW/){

	#define HIGH and MODERATE as strong effect
	#if($tem[1] =~/HIGH/){
	if($tem[1] =~/HIGH|MODERATE/){
		
		print AA "$name[0]\t$name[1]\t$p2\n" if !exists $hash1{$tem[0]};
		$hash1{$tem[0]}=1;
	}
	
	#print BB "$name[0]\t$name[1]\t$p2\n" if !exists $hash2{$tem[0]};
	#$hash2{$tem[0]}=1;
	if($tem[1] =~/syn/){
	#	print BB "$name[0]\t$name[1]\t$p2\n";
		print BB "$name[0]\t$name[1]\t$p2\n" if !exists $hash2{$tem[0]};
		
		$hash2{$tem[0]}=1;
		
	}

}
close MM;
close AA;
close BB;

print "generating output files...\n";
print "the SNPs with strong effect and the syn-SNPs are extracted\n";


#`sort-bed tmpdir/aa > tmpdir/info_SNPeff_wheat784_maf05.high`;
`sort-bed tmpdir/aa > tmpdir/info_SNPeff_wheat784_maf002.highANDmoderate`;
#`sort-bed tmpdir/aa > tmpdir/info_SNPeff_wheat784_maf002.high`;


#`sort-bed tmpdir/bb > tmpdir/info_SNPeff_wheat784_maf05.syn`;
`sort-bed tmpdir/bb > tmpdir/info_SNPeff_wheat784_maf002.syn`;




#grep -P "A|B" info_SNPeff_wheat784.strong  > info_SNPeff_wheat784.strong.ABgenome
#grep -P 'A|B' info_SNPeff_wheat784.syn > info_SNPeff_wheat784.syn.ABgenome






