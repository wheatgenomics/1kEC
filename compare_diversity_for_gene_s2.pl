#!/usrbin/perl -w






open MM,"result_data2000/geneList2window" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t|\|/;
	$tem[0]=&changeName1($tem[0]);
	$tem[1]=$tem[1]-50000;
	$tem[2]=$tem[2]+50000;
	$gene2win{$tem[3]}=$tem[0]."\t".$tem[1]."\t".$tem[2];

}
close MM;

open MM,"tmpdir/res" or die ";";
while(<MM>){
	chomp;
	@tem=split/\t/;

	if($tem[2] >0.5){
		$gene2fdp->{$tem[1]}->{$tem[0]}=1;
	}else{
		$gene2fdn->{$tem[1]}->{$tem[0]}=1;
	
	}
}
close MM;

`rm tmpdir/aa.*`;
`rm tmpdir/bb.*`;
foreach $gg(sort keys %$gene2fdp){
	@tem1=sort keys %{$gene2fdp->{$gg}};
	@tem2=sort keys %{$gene2fdn->{$gg}};

	open TM,">tmpdir/aa.$gg" or die "l";
	foreach (@tem1){
		print TM "$_\n";
	}
	foreach (@tem2){
		print TM "$_\n";
	}
	close TM;

	open TM,">tmpdir/bb.$gg" or die "l";
	foreach (@tem2){
		print TM "$_\n";
	}

	close TM;


	#@tem=split/\t/,$gene2win{$gg};
	#$cmd="vcftools --gzvcf vcf/imputation/all.GP08.vcf.gz  --site-pi --keep tmpdir/aa --maf 0.002 --chr $tem[0] --from-bp $tem[1]  --to-bp $tem[2]  ";
	#print "$cmd\n";

	#$cmd="vcftools --gzvcf vcf/imputation/all.GP08.vcf.gz  --site-pi --keep tmpdir/bb --maf 0.002 --chr $tem[0] --from-bp $tem[1]  --to-bp $tem[2]  ";
	#print "$cmd\n";

#die;
}



@file=glob("tmpdir/aa.*");

use Parallel::ForkManager;
$pm = new Parallel::ForkManager(48);

foreach $in(@file){
	
	my $pid = $pm->start and next;
	$in2=$in;
	$in2=~s/aa/bb/;
	@name=split/\./,$in;
	@tem=split/\t/,$gene2win{$name[-1]};
	#$tem[0]=&changeName1($tem[0]);
	
	$out1=$in."_maf";
	$out2=$in2."_maf";

	#$vcf="../1000EC/vcf/imputation/all.GP08.wheat784_maf01.vcf.gz";
	$vcf="../1000EC/vcf/imputation/all.GP08.vcf.gz";

	
	#$cmd1="vcftools --gzvcf $vcf  --site-pi --keep $in  --chr $tem[0] --from-bp $tem[1]  --to-bp $tem[2] --out $out1 ";
	#$cmd2="vcftools --gzvcf $vcf  --site-pi --keep $in2  --chr $tem[0] --from-bp $tem[1]  --to-bp $tem[2] --out $out2 ";
	
	#$cmd1="vcftools --gzvcf $vcf --window-pi 1000  --window-pi-step 100 --keep $in  --chr $tem[0] --from-bp $tem[1]  --to-bp $tem[2] --out $out1";
	#$cmd2="vcftools --gzvcf $vcf --window-pi 1000  --window-pi-step 100 --keep $in2  --chr $tem[0] --from-bp $tem[1]  --to-bp $tem[2] --out $out2 ";
	
	$cmd1="vcftools --gzvcf $vcf  --chr $tem[0] --from-bp $tem[1]  --to-bp $tem[2] --out $out1 --freq --keep $in  ";
	$cmd2="vcftools --gzvcf $vcf  --chr $tem[0] --from-bp $tem[1]  --to-bp $tem[2] --out $out2 --freq --keep $in2 ";
	
	
	
	print "$cmd1\n";
	`$cmd1`;
	`$cmd2`;

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





