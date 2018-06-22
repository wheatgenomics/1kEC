#!/usrbin/perl -w


#Direct count of introgressed allele
#step1
#generate freq. file from vcf






#$vcf="vcf/shared_SNPsites_with_otherDatasets/1k_emmer.vcf.chrID";
$vcf="vcf/shared_SNPsites_with_otherDatasets/1k_emmer.vcf";


open MM,"/home/DNA/shared_project/1000EC/data/sample_for_populationStructureAnalysis.txt" or die "l";
#open MM,"/home/DNA/shared_project/1000EC/data/1kEC_sample_information.txt" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	#next if $tem[5] ne "lr" ;
	next if $tem[0] =~/accession/;
	next if $tem[1] eq "AVS";
	#next if $tem[5] ne "cul";
	#next if $tem[8] eq "-";
	$tem[9]=$tem[6];

	#introgression group
	#$g2acc->{$tem[8]}->{$tem[0]}=1;
	#$acc2group{$tem[0]}=$tem[8];


	if($tem[9]=~/Eur/){
		$g2acc->{"Europe"}->{$tem[0]}=1;
		$acc2group{$tem[0]}="Europe";
	}
	if($tem[9]=~/MiddleEast1/){
		$g2acc->{"MiddleEast"}->{$tem[0]}=1;
		
	}

	if($tem[9]=~/MiddleEast2/){
		$g2acc->{"Turkey"}->{$tem[0]}=1;
		
	}


	if($tem[9]=~/AsiaEast|AsiaIndia/){
		#$g2acc->{"EastAsia"}->{$tem[0]}=1;
		#$acc2group{$tem[0]}="EastAsia";
	}

	if($tem[9]=~/AsiaCentral/){
		#$g2acc->{"CentralAsia"}->{$tem[0]}=1;
		#$acc2group{$tem[0]}="CentralAsia";
	}

	if($tem[9]=~/AsiaEast|India/){
		$g2acc->{$tem[9]}->{$tem[0]}=1;
		$acc2group{$tem[0]}=$tem[9];
	
	}



}
close MM;









$n=@tem=keys %acc2group;
print "$n accession has groups\n";


=head
#psr920-forward
#chr4A, from 179060863 to 179060604

#psr920-rev
#chr4A, from 179060203 to 179060535

#set the range of flanking sequence around psr920 here:

open AA,">tmpdir/bb2" or die "l";
print AA "#chr\tstart\tend\n";
print AA "chr4A\t178810682\t179310682\n"; #500kb around psr920
close AA;
=cut



`rm tmpdir/psr920_groupFreq_*`;

use Parallel::ForkManager;

$pm = new Parallel::ForkManager(22);


foreach $gg(sort keys %$g2acc){
	
	my $pid = $pm->start and next;
	print "$gg\n";
	$bb="tmpdir/bb_$gg";
	open NN,">$bb" or die "l";
	foreach $in(sort keys %{$g2acc->{$gg}}){
		print NN "$in\n";
	}
	close NN;
	`vcftools --vcf $vcf  --keep $bb  --freq --out tmpdir/psr920_groupFreq_$gg`;
	#`vcftools --vcf $vcf  --keep tmpdir/bb --bed tmpdir/bb2 --freq --out tmpdir/psr920_groupFreq_$gg`;
	
	$pm->finish;

	
}
$pm->wait_all_children;















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





