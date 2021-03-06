#!/usr/bin/perl -w



use Parallel::ForkManager;

#$vcf="tmpdir/ABgenome.GP08_thin10k_maf002.recode.vcf.chrID.part.gz";
#$vcf="1000EC/vcf/imputation/ABgenome.GP08_thin10k_maf002.recode.vcf.gz";
#$vcf="1000EC/vcf/imputation/ABgenome.GP08.vcf.gz";
#$vcf="1000EC/vcf/imputation/ABgenome.GP08_thin1k_maf01.vcf.gz";
#$vcf="1000EC/vcf/shared_SNPsites_with_otherDatasets/1k_emmer.vcf.gz";

#$vcf="1000EC/vcf/imputation/all.GP08.vcf.gz";

#$vcf="1000EC/vcf/shared_SNPsites_with_otherDatasets/1k_emmer.vcf.gz";

#$vcf="tmpdir/gcta/dat_1kEmmerThin1mMaf002/1k_emmer_thin1m_maf002.vcf.gz";
#$vcf="tmpdir/gcta/dat_1kEmmerThin10kMaf002/1k_emmer_thin10k_maf002.vcf.gz";

#`rm tmpdir/aa_*bed`;
#`rm tmpdir/bb_*`;
#@file=glob("tmpdir/gcta/dat_ABgenomeGP08/gWindow_*.bed.chrID");
#@file=glob("tmpdir/gcta/dat_ABgenomeGP08thin10Kmaf002/gWindow_*.bed.chrID");

#@file=glob("tmpdir/gcta/dat_1kEmmerThin10kMaf002/*bed.chrID");
#@file=glob("tmpdir/gcta/dat_allGP08/*bed.chrID");
#@file=glob("tmpdir/gcta/dat_1kEmmer/*bed.chrID");

#$file[0]="tmpdir/gWindow_fdHot_byTop1p.bed.chrID";
#$file[1]="tmpdir/gWindow_fdHot_byCount.bed.chrID";
#$file[2]="tmpdir/gWindow_fdCold.bed.chrID";

#$file[0]="1000EC/tmpdir/aa.ffp400.bed.chrID";
#$file[1]="1000EC/tmpdir/aa.ffp3.bed";
#$file[1]="1000EC/tmpdir/aa.ffp4.bed.chrID";


$file[0]="1000EC/tmpdir/aa.cold";
$file[1]="1000EC/tmpdir/aa.hot";


$vcf="1000EC/vcf/imputation/ABgenome.GP08_thin10k_maf002.recode.vcf.gz";


$pm = new Parallel::ForkManager(8);
foreach $in(@file){

	my $pid = $pm->start and next;
	print "$in\n";	
	$new=$in.".vcf.gz";


	`bcftools view -R $in $vcf |bgzip > $new`;
	


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





