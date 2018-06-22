
pd=read.table('tmpdir/aa',head=F)
gd=read.table('tmpdir/bb',head=F)

iw=approx(gd[,1],gd[,2],pd[,1],method="linear",rule=1)

write.table(iw,file='tmpdir/info.txt',row.names=F,col.names=F)



