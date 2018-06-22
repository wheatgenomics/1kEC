#!/usrbin/perl -w


#updated on 02232018


#fst was calculated using several SNP dataset, to ensure different SNP dataset does not change the results


#set the SNP dataset here:
#@file=glob("basic_popGen_statistic/fst_lrVScul/all.GP08/fst_*log"); #A very large SNP datasets. N=7.3M
#@file=glob("basic_popGen_statistic/fst_lrVScul/all.GP08.thin100k.maf002/fst_*log"); # a thinned SNP dataset, N=84K
@file=glob("basic_popGen_statistic/fst_lrVScul/1kEmmer/fst_*log"); #merged SNP dataset, N=345K
#@file=glob("basic_popGen_statistic/fst_improvement/fst_*log"); #merged SNP dataset, N=345K


print "output: tmpdir/res\n\n";
open NN,">tmpdir/res" or die "l";
foreach $in(@file){
	
	#next if $in=~/OCEANIA|AfricaN/;
	
	open MM,"$in" or die "l";
	@all=<MM>;
	close MM;
	
	
	#$in=~s/Other/USother/;
	print "w\n" if $all[18]!~/mean Fst/;
	print "w\n" if $all[19]!~/weighted Fst/;
	
	
	#do you want to use weighted or un-weighted?
	#@tem=split/\s/,$all[15]; # un-weighted
	@tem=split/\s/,$all[19]; #weighted

	$tem[-1] =0  if $tem[-1]<0;
	@name=split/\.|_/,$in;
	$p1=$name[-5]."_".$name[-4];
	$p2=$name[-3]."_".$name[-2];
	
	#lr/cul geo
	#$p1=$name[-4]."_".$name[-5];
	#$p2=$name[-2]."_".$name[-3];
	
	#improvement
	#print NN "$name[-4]-$name[-2]\t$tem[-1]\n";
	#print NN "$name[-2]-$name[-4]\t$tem[-1]\n";
	
	next if exists $hash{$p1}{$p2};
	$hash{$p1}{$p2}=1;
	$hash{$p2}{$p1}=1;


	#lr/cul
	#geo

	#local lr and cul
	if($name[-3] eq $name[-5] && $name[-4] ne $name[-2] ){
		print NN "$p1\t$p2\t$tem[-1]\tlocal,cul-lr\n";
	}
	
	#distant lr and cul
	if($name[-3] ne $name[-5] && $name[-4] ne $name[-2]  ){
		print NN "$p1\t$p2\t$tem[-1]\tdistant,cul-lr\n";
	}

	if($name[-3] ne $name[-5] && $name[-4] eq $name[-2] && $name[-2] eq "lr" ){
		print NN "$p1\t$p2\t$tem[-1]\tdistant,lr-lr\n";
	}

	if($name[-3] ne $name[-5] && $name[-4] eq $name[-2] && $name[-2] eq "cul" ){
		print NN "$p1\t$p2\t$tem[-1]\tdistant,cul-cul\n";
	}


		
	


}
close NN;




#R code:
#iw=read.table('tmpdir/res')
#ggplot()+geom_boxplot(aes(iw[,4],iw[,3]))+theme_bw()+theme(axis.text=element_text(size=12))+theme(panel.grid.major=element_blank(),panel.grid.minor=element_blank())+theme(plot.margin=unit(c(1,1,1,1),"cm"),axis.title=element_text(size=12))+labs(x='',y="weighted fst",title="")+coord_flip()



