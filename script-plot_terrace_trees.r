library(ape)

args = commandArgs(trailingOnly=TRUE)
file=args[1]
file_out=args[2]
terrace_size=as.numeric(args[3])


y=min(terrace_size,5)
x=ceiling(terrace_size/5)



if(terrace_size>1){
    pdf(paste(file_out,"-plot_trees.pdf",sep=""),w=y*3,h=x*3)
    par(mfrow=c(x,y),oma=c(0,0,0,0))
    for(i in 1:terrace_size){
        t=read.tree(paste(file,i,sep=""))
        plot.phylo(t,type="unrooted",no.margin=TRUE,cex=1)
        #title(paste("T",i,sep=""),cex.main=1)
    }
    invisible(dev.off())
}else{
    pdf(paste(file_out,"-plot_trees.pdf",sep=""),w=3,h=3)
    par(oma=c(1,1,1,1))
    i=1
    t=read.tree(paste(file,i,sep=""))
    plot.phylo(t,type="unrooted",no.margin=TRUE,cex=0.5)
    invisible(dev.off())
}
