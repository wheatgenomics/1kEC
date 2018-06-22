#!/usr/bin/perl -w

use Text::NSP::Measures::2D::Fisher::twotailed;
use Statistics::Multtest qw(:all);
#ftp://ftp.arabidopsis.org/home/tair/Genes/TAIR10_genome_release/TAIR10_gene_lists/TAIR10_representative_gene_models

#$n=99386;
#total gene number in wheat genome
#$n=91576;
#$n=187062;#total number of genes by Fei

#$n=220195; #HC_G + LC_G + stringtie_with_EV
$n=179936; #ID fixed

$n_genes=$n;
#ta_IWGSC_MIPSv2.2_HighConf_PROTEIN_2014Jul18.fa

$cutoff=0.05; #pv
#$cutoff=100; #pv



#read in graph_path
open PATH,"go_daily-termdb-tables/graph_path.txt" or die "No graph_path\n";
while(<PATH>){
	chomp;
	@tem=split/\t/;
	next if $tem[3] !=1;# only consider is-a
	$joint=$tem[1]."\t".$tem[2];
	if (exists $path{$joint}){
	 	 push @{$path{$joint}},$tem[4];
 	}
	else{
	 	$path{$joint}=[$tem[4]];
	}
}
close PATH;

#read in term
open TER,"go_daily-termdb-tables/term.txt" or die "No term";
while (<TER>){
	chomp;
	@tem=split/\t/;
	$goterm2goid{$tem[3]}=$tem[0];
	$goid2goterm{$tem[0]}=$tem[3];
	$goid2godes{$tem[0]}=$tem[1];
	$goterm2type{$tem[3]}=$tem[2];
}
close TER or die "hell";

#find the level for each term
foreach (keys %goid2goterm){
	$get_joint="46032"."\t"."$_";  #40406 is the id of root in GO system. this number may change if you use another version of GO file
	$path{$get_joint}->[0]="100000" if !exists $path{$get_joint};  #assign an rough number if the distance between a go id and root can not be found in %path
	@tem=sort{$a<=>$b}(@{$path{$get_joint}});
	$goid2depth{$_}=$tem[0];#get the min level(i.e distance to the root)
	#print "@tem\n";

}




#open NN,"complete_go_Arabidopsis_bp" or die "l";
#open NN,"tmpdir/complete_go_wheatByFei_combined" or die "l";
#open NN,"tmpdir/complete_go_V1Fei" or die "l";
open NN,"tmpdir/complete_go_V1FeiEv" or die "l";
while(<NN>){
	chomp;
	@tem=split/\t/;
	@temm=split/;/,$tem[1];
	foreach $in(@temm){
		next if $goid2depth{$in}<2;
		
		push @{$gene2go{$tem[0]}},$in;
		
		$gene2goInfo->{$tem[0]}->{$goid2goterm{$in}}=1;
	
	}
	

}
close NN;

=head
$n=@tem=keys %gene2go;
print "$n\n";

foreach (sort keys %gene2go){
	$line=join ";",@{$gene2go{$_}};
	print "$_\t$line\n";
}
=cut

#count the number of genes associated with each go term
foreach $gene(keys %gene2go){
	@tem=@{$gene2go{$gene}};
	foreach $in(@tem){
		$background->{$goid2depth{$in}}->{$in}++;
	}
}
open NN,">tmpdir/wheatV1_go_data" or die "l";
foreach $dep(sort {$a <=> $b} keys %{$background}){
	
	#print "$dep\n";
	foreach $in(keys %{$background->{$dep}}){
		print NN "$dep\t$in\t$goid2goterm{$in}\t$goid2godes{$in}\t$background->{$dep}->{$in}\n";
	}

}
close NN;


open NN,">tmpdir/wheatV1_go_filtered_data" or die "l";
open MM,"tmpdir/wheatV1_go_data" or die "l";
@all=<MM>;
close MM;

$n_goterm=@all;
foreach (@all){
	chomp;
	@tem=split/\t/;
	$v1=($tem[4]/$n_genes)**2;
	$v2=0.05/$n_goterm;
	
	$v3=(sqrt $v2)*$n_genes;
	#print "$v3\n";

	if($v1 < $v2){
		print NN "$_\n";
		$filtered_go{$tem[1]}=1;
	}

}
close NN;


foreach (keys %gene2go){
	$tmp=join ";",@{$gene2go{$_}};
	$new_gene2go->{$_}=$tmp
}


$in="/home/feihe/project/RNAseq/tmpdir/stringTie_all_fpkm.txt.filtered2.eQTL_Mar01.topSNP.hotspot";
$in="/home/feihe/project/RNAseq/tmpdir/stringTie_all_fpkm.txt.filtered3.tra_eQTL.Mar02.topSNP.hotspot";


$in=$ARGV[0];

open MM,"$in" or die "l";
while(<MM>){
	chomp;
	#$_=uc $_;

	@tem=split/\t|\|/;
		@tm=split/\s|;/,$tem[2];
	#next if @tm<5;
	#undef %tm_gene;
	foreach $in(@tm){
		#@ee=split/\./,$in;
		#$ee[0]=uc $ee[0];
		#$m2gene->{$tem[0]."\t".$tem[1]."\t".$tem[2]."\t".$tem[3]}->{$in}=1;
		$m2gene->{$tem[0]}->{$in}=1;
	}

}
close MM;


open FO,">$in._GOenrichment.txt" or die "l";
foreach $instr(keys %$m2gene){
	#@name=split/_/,$instr;
	
	@geneIDList=keys %{$m2gene->{$instr}};
	#get N
	$N=@geneIDList;
	#print "$instr\t$N\t@geneIDList\n";
	print "$instr\t$N\n";
	#get all GO annotation among input geneIDlist
	#counting at the same level
	
	undef $input_go;
	foreach (@geneIDList){
		next if !exists $new_gene2go->{$_}; 
		#print "$_\n";
		@tem=split/;/,$new_gene2go->{$_};
		foreach $in(@tem){
		#	next if $goid2depth{$in}>7 or $goid2depth{$in}<2; #the enrichment test only apply from level 2 to level 7 
			$input_go->{$goid2depth{$in}}->{$in}++;
			#print "=$in\n";
		}
	}

	open NN,">file_for_test" or die "l";
	#get the background number
	undef @tem_pv;
	for($i=2;$i<16;$i++){
		next if !exists $input_go->{$i};
		@tem=keys %{$input_go->{$i}};
		foreach $in(@tem){
			$N1=$input_go->{$i}->{$in};
			$n1=$background->{$i}->{$in};
			#for each GO term($in), there are 4 numbers for enrichment test: $n,$n1, $N, $N1.
			next if !exists $filtered_go{$in};
			next if $N1 <3;
			$pv=calculateStatistic(n11 => $N1, n1p => $N, np1 => $n1, npp => $n);
			#next if $pv >$cutoff;
			$pv=sprintf "%e",$pv;
			print NN "$i\t$goid2goterm{$in}\t$goid2godes{$in}\t$N1\t$N\t$n1\t$n\t$pv\n";	
			push @tem_pv,$pv;
		}
	}
	close NN;
	next if @tem_pv < 1;



	$new_pv=BH(\@tem_pv);
	open MM,"file_for_test" or die "l";
	@info_tmp=<MM>;
	close MM;
	open NN,">file_for_test2" or die "l";
	for($x=0;$x<@info_tmp;$x++){
		chomp $info_tmp[$x];
		print NN "$info_tmp[$x]\t$new_pv->[$x]\n";
	}
	close NN;



	open KK,"file_for_test2" or die "l";
	@tmp_all=<KK>;
	close KK;
	#shift @tmp_all;
	

	
	undef %rec_enrichment;
	foreach $line(@tmp_all){
		chomp $line;
		@tem=split/\t/,$line;
		next if $tem[8]>$cutoff;
		$rec_enrichment{$tem[1]}=$tem[-1];
	}
	$i=0;
	foreach $line(sort {$rec_enrichment{$a}<=>$rec_enrichment{$b}|| $a cmp $b} keys %rec_enrichment){
		$i++;
		next if $i>1;
		$fterm=$line;
	}

	foreach $line(@tmp_all){
		chomp $line;
		@tem=split/\t/,$line;
		#next if $tem[1] ne $fterm;
		$fc=sprintf "%.2f", ($tem[3]/$tem[4])/($tem[5]/$tem[6]);
		
		#next if $fc <1;
		#next if $tem[8]>$cutoff;
		$tem[8]=sprintf "%e",$tem[8];

		$line=join"\t",@tem;
		#print FO "$name[0]\t$name[1]\t$instr\t$line\t$fc\n";
		print FO "$instr\t$line\t$fc\n";
		#print  "$instr\t$line\t$fc\n";

	}

	


}
close FO;
