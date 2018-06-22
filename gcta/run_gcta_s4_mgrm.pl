#!/usr/bin/perl -w
use Parallel::ForkManager;





$cmd="/home/feihe/tool/gcta_1.91.1beta/gcta64";




$cpu=16;




	
	
	`rm tmpdir/out*`;
	
	for($i=1;$i<12;$i++){
		$out="tmpdir/out.REMLout$i";
		$cc="$cmd --mgrm  tmpdir/grm.list --mpheno $i --pheno tmpdir/gcta/pheno.all.ranked --reml --qcovar tmpdir/gcta/dat_ABgenomeGP08thin10Kmaf002/res.pca.eigenvec.3pc  --out $out --thread-num $cpu ";
		#$cc="$cmd --mgrm  tmpdir/grm.list --mpheno $i --pheno tmpdir/gcta/pheno.all.ranked --reml --qcovar tmpdir/gcta/pca.vec  --out $out --thread-num $cpu ";
		print "$cc\n";
		`$cc`;

	}
	




	

















