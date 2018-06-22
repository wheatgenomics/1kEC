#!/usr/bin/perl -w


#@file=glob("res_data2/ped_file/*map");
#@file=glob("xpclr_dir2/*GT*recode01.map");
@file=glob("xpclr_dir5/*GL*recode01.map");


foreach $in(@file){
next if $in=~/^22/;
	print "$in\n";


open MM,"$in" or die "L";
@info=<MM>;
close MM;
@ii=split/\t|_/,$info[0];




#@name=split/\/|_GL/,$in;
@name=split/\/|_beagleOutGL/,$in;
$new=$name[-2].".map_for_xpclr" or die "l";



undef %snp;
open MM,"$in" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t|\s/;
	@tm=split/_/,$tem[1];
	###$snp{$tm[1]."_".$tm[2]}=1;
	$snp{$tem[1]}=1;
}
close MM;


open NN,">xpclr_dir5/$new" or die "l";

print "$ii[1]\n";
open MM,"xpclr_dir5/$ii[1].GeneticMap_forXPCLR" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t|\s/;
	next if !exists $snp{$tem[0]};
	print NN "$_\n";


}
close MM;
close NN;


}
