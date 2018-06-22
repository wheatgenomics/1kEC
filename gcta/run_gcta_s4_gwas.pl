#!/usr/bin/perl -w
use Parallel::ForkManager;





$cmd="/home/feihe/tool/gcta_1.91.1beta/gcta64";




$cpu=8;


$pm = new Parallel::ForkManager(6);


#$pc="res_data/introgression_file/out_intergression.eigenvec";
#$grm="res_data/introgression_file/out_intergression";

#$pc="tmpdir/gcta/res_GWAS_ABgenomeGP08/pca.3pc";
#$grm="tmpdir/gcta/res_GWAS_ABgenomeGP08_maf002/ABgenome.GP08_maf002";	
#$grm="tmpdir/gcta/res_GWAS_ABgenomeGP08/ABgenome.GP08";

#$bfile="1000EC/vcf/imputation/ABgenome.GP08_maf002";



$bfile="tmpdir/all.GP08_maf05";
$grm=$bfile;
$pc="tmpdir/all.GP08_maf05_pca.eigenvec_3pc";




	for($i=1;$i<12;$i++){
		
	my $pid = $pm->start and next;
		
		$out="tmpdir/out.GWASout3_$i";
		$log=$out.".log";
		$cc="$cmd  --bfile $bfile --grm  $grm   --mpheno $i --pheno tmpdir/gcta/pheno.all.ranked --mlma --qcovar $pc  --out $out --thread-num $cpu > $log ";
		print "$cc\n";
		`$cc`;

	$pm->finish;

	}

#$pm->wait_all_children;

	














