#!/usr/bin/perl -w

#R


open MM,"$ARGV[0]" or die "l";
@all=<MM>;
close MM;


open NN,">$ARGV[0].corrected" or die "l";
for($i=0;$i<@all-1;$i=$i+2){
	chomp $all[$i];
	chomp $all[$i+1];
	
	undef @cc;
	@aa=split/\t|\s/,$all[$i];
	@bb=split/\t|\s/,$all[$i+1];
	for($x=0;$x<@aa;$x++){
		push @cc,$aa[$x];
		push @cc,$bb[$x];
	}
	print NN "@cc\n";

}
close NN;


