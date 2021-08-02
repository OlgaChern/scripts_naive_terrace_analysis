args = commandArgs(trailingOnly=TRUE)
# the file with adjacency matrix for all trees on a terrace (IQ-TREE format rf_all)
#file=args[1]
#file_tsc=args[2]
file_out=args[3]
file_conn_info=args[4]
trivial_terr_NUM=as.numeric(args[5])
f_scripts=args[6]

source(paste(f_scripts,"/script-colors.r",sep=""))
source(paste(f_scripts,"/script-donut-plot.r",sep=""))

################################
# colors
################################
library(RColorBrewer)
#royalColors=colorRampPalette(c("yellowgreen","royalblue"),bias=1,interpolate="linear",alpha=.5)

#cols <- brewer.pal(9, "YlGnBu")
#cols=c("red", "green", "blue", "yellow")
cols=brewer.pal(11, 'Spectral')


pal <- colorRampPalette(cols)

# color of vertices
#new_cols=pal(max(t))[membership(tsc)]

# color of borders of communities
#mark_border_cols=pal(max(t))


# color of communities
#pal2=colorRampPaletteAlpha(cols, n = max(t),alpha = 0.4)
#mark_cols=pal2

#######################################################
conn_info=read.table(file_conn_info)
conn_info=as.matrix(conn_info)

terrNUM=nrow(conn_info)

terrMAX=max(conn_info[,2])
conn_terr=which(conn_info[,3]==1)
dis_terr=which(conn_info[,3]==0)
disNUM=length(dis_terr)
connNUM=length(conn_terr)


hist_c=hist(conn_info[conn_terr,2],breaks=seq(0.5,terrMAX+0.5,1),main="Connected terraces",xlab="Terrace Size (# of trees)")
if(disNUM>0){
        hist_d=hist(conn_info[dis_terr,2],breaks=seq(0.5,terrMAX+0.5,1),main="Disconnected terraces",xlab="Terrace Size (# of trees)")
        countMAX=max(hist_c$counts,hist_d$counts)
}else{
        countMAX=max(hist_c$counts)
}

# colors
col_trans=addalpha(pal(2),0.75)
col_trans=addalpha(c("yellowgreen","firebrick"),0.75)

# plot--------------------------------------------------------------
pos=2
plot_text<-function(x,pos,col){
        for(i in 1:length(x)){
                if(x[i]!=0){
                        mycol=ifelse((i %% 2) == 0, col[1], col[2])
                        text(i,pos,paste(i),adj=0.5,cex=0.7)
                        #abline(v=c(i),col="lightgrey",lty=3)
                }
        }

}
#plot_text(hist_c$counts,pos,col_trans)
#plot_text(hist_d$counts,pos,col_trans)

col_trans_1=addalpha(col_trans)
col_trans_75=addalpha(col_trans,0.75)
col_trans_25=addalpha(col_trans,0.25)


#-------------------------------------
pdf(paste(file_out,"-terrace_info-hist.pdf",sep=""),w=5,h=5)
#par(mfrow=c(1,3))

# distribution of terrace sizes
        plot(hist_c,col=col_trans[1],ylim=c(0,countMAX+4),xaxt='n',
                main="Distribution of terraces sizes",xlab="Terrace size (# of trees)")
        if(disNUM>0){
                plot(hist_d,col=col_trans[2],add=TRUE,xaxt='n')
        }
        axis(side = 1, at = seq(0,terrMAX,2))

        #plot_text(hist_c$counts,pos,col_trans)

        #legend("topright", c(paste("connected - ",connNUM,sep=""), paste("disconnected - ",disNUM,sep="")), pch = c(19,19),bty='n',col=col_trans, title =paste("Number of terraces: ",terrNUM,sep=""))
dev.off()

#-------------------------------------
num_cex_donut=3.5
pdf(paste(file_out,"-terrace_info-split.pdf",sep=""),w=9,h=6)
# info about counts
        #par(mfrow=c(2,1),oma=c(0,0,0,0),mai = c(0, 0, 0, 0))
        par(oma=c(0,0,0,0),mai = c(0, 0, 0, 0))
        layout(matrix(c(1,1,2,3,4,5), nrow = 2, ncol = 3, byrow = FALSE))
        doughnut( c(terrNUM),inner.radius=0.55,
                 col=c(addalpha("royalblue",0.5)),
                 labels=c(""),clockwise=TRUE)
        text(0,0,terrNUM,adj=c(0.5,0.5),cex=num_cex_donut,col="royalblue",font=2)
        text(0,1.2,"Non-trivial\nTerraces",font=2,cex=num_cex_donut,col="royalblue",adj=0.5)
        text(0,-1.1,paste("+ ",trivial_terr_NUM,sep=""),font=2,cex=num_cex_donut,col="royalblue",adj=0.5)


        doughnut( c(connNUM,disNUM),inner.radius=0.55,
                 col=c(col_trans_1[1],col_trans_25[1]),
                 labels=c("",""),clockwise=TRUE)
        text(0,0,paste(round(connNUM/terrNUM*100,0),"%",sep=""),adj=c(0.5,0.5),
             cex=num_cex_donut,col=col_trans_1[1],font=2)

	doughnut( c(disNUM,connNUM),inner.radius=0.55,
         col=c(col_trans_1[2],col_trans_25[2]),
         labels=c("",""),clockwise=TRUE)
        text(0,0,paste(round(disNUM/terrNUM*100,0),"%",sep=""),
             adj=c(0.5,0.5),cex=num_cex_donut,col=col_trans_1[2],font=2)

        plot(0,type='n',axes=FALSE,ann=FALSE,xlim=c(0,1),ylim=c(-1,1))
        text(0,0,"connected",font=2,cex=3,adj=0,col=col_trans_1[1])
        plot(0,type='n',axes=FALSE,ann=FALSE,xlim=c(0,1),ylim=c(-1,1))
        text(0,0,"disconnected",font=2,cex=3,adj=0,col=col_trans_1[2])

#-------------------------------------
dev.off()

if(disNUM>0){
        pdf(paste(file_out,"-terrace_info-components-hist.pdf",sep=""),w=5,h=5)
        hist(conn_info[dis_terr,4],breaks=seq(0.5,max(conn_info[dis_terr,4])+1,1),col=addalpha("orange",0.75),main="Distribution of components",xlab="Number of disconnected components")
        #plot(hist_comp_NUM,col=addalpha("orange",0.75),main="Distribution of components",xlab="Number of disconnected components")
        dev.off()
}

