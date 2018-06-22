#!/usr/bin/perl -w


open MM,"$ARGV[0]" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	$good{$tem[0]}=1;
}
close MM;


@name1=split/\//,$ARGV[0];
@name2=split/\/|_beagleOutGL/,$ARGV[1];
$new=$name1[-1].".".$name2[-2]."ped";
open NN,">xpclr_dir6/$new" or die "l";

open MM,"$ARGV[1]" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t|\s/;
	next if !exists $good{$tem[0]};
	print  NN "$_\n";

}
close MM;
close NN;


