
args = commandArgs(trailingOnly=TRUE)
# the file with adjacency matrix for all trees on a terrace (IQ-TREE format rf_all)
file=args[1]
file_tsc=args[2]
file_out=args[3]
file_conn_info=args[4]
trivial_terr_NUM=as.numeric(args[5])

f_scripts=args[6]
source(paste(f_scripts,"/script-colors.r",sep=""))
source(paste(f_scripts,"/script-donut-plot.r",sep=""))
source(paste(f_scripts,"/script-plot_one_terrace.r",sep=""))
####################################################################################################
# aux function
###################################################################################################
get_edges_attributes<-function(g,comm,e_col_OUT,e_col_IN,e_width_OUT,e_width_IN,e_lty_OUT,e_lty_IN){
	e=get.edgelist(g)
	E(g)$color=c(rep(e_col_OUT,ecount(g)))
	E(g)$lty=c(rep(e_lty_OUT,ecount(g)))
	E(g)$width=c(rep(e_width_OUT,ecount(g)))


	for(i in 1:nrow(e)){
        	if(V(g)$community[e[i,1]] == V(g)$community[e[i,2]]){
                	E(g)$color[i]=e_col_IN
                	E(g)$width[i]=e_width_IN
                	E(g)$lty[i]=e_lty_IN
        	}
	}
	return(g)
}

#########################################################################################
#actual script
#########################################################################################

#print(file)

d=read.table(paste(file,sep=""),skip=1)
d=d[,-1]
d=as.matrix(d)

#print(d)

# get only 1-NNI neighbours
n=nrow(d)
rfdist=matrix(0,n,n)
for(i in 1:n){
    for(j in 1:n){
        if(d[i,j]==2){
            rfdist[i,j]=1
        }
    }
}
d=rfdist

library(igraph)
g<-graph.adjacency(t(d),mode="undirected")

vNUM=length(V(g))
if(vNUM>105){
	V(g)$size=2
}else{
	V(g)$size=3
}




# get info about tree space configuration
t=read.table(file_tsc)
t=as.matrix(t)

tsc=cluster_label_prop(g)
tsc$membership=t[,1]
V(g)$community=tsc$membership


# compute layout, weighting connections within terrace more

w=10
if(vNUM==15){
	w=3
}
weights <- ifelse(crossing(tsc, g), w, 1)	# 10,1 is best for kk | for fr 1,50
layout <- layout_with_kk(g, weights=weights)
#layout <- layout.reingold.tilford(g, circular=T)
#layout <- layout_with_fr(g, weights=weights)


# With kk easier to see the whole space
# With fr easier to see connections within terrace, but terraces overlap more then with kk. This one is possibly better to use for a subset of terraces.



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
new_cols=pal(max(t))[membership(tsc)]

# color of borders of communities
mark_border_cols=pal(max(t))


# color of communities
pal2=colorRampPaletteAlpha(cols, n = max(t),alpha = 0.4)
mark_cols=pal2

# color of edges
#E(g)$color <- apply(as.data.frame(get.edgelist(g)), 1, function(x) ifelse(V(g)$community[x[1]] == V(g)$community[x[2]],"black","grey"))


##### PLOTs ############################################
wd=20
ht=20


if(vNUM==15){
        V(g)$size=7

}


E(g)$width=1
if(vNUM<=105){
	#if(vNUM==15){
        	V(g)$size=7
		E(g)$width=5
        	E(g)$color="grey"
	#}

	# EDGE attributes
	e_OUT=1
	e_IN=2
	g=get_edges_attributes(g,tsc$membership,"lightgrey","black",e_OUT,e_IN,1,1)

	pdf(paste(file_out,"-1.pdf",sep=""),w=wd,h=ht)
	plot(tsc,g, layout=layout,vertex.label=NA,col=new_cols,mark.col=mark_cols,edge.width=E(g)$width,mark.border=mark_border_cols,edge.color=E(g)$color,edge.lty=E(g)$lty)
	dev.off()

	#------------------------------------------
	e_OUT=1
        e_IN=2
	g=get_edges_attributes(g,tsc$membership,"lightgrey","black",e_OUT,e_IN,3,1)

	pdf(paste(file_out,"-2.pdf",sep=""),w=wd,h=ht)
	plot(tsc,g, layout=layout,vertex.label=NA,col=new_cols,mark.col=mark_cols,edge.width=E(g)$width,mark.border=mark_border_cols,edge.color=E(g)$color,edge.lty=E(g)$lty)
	dev.off()

}
#------------------------------------------
e_OUT=1
e_IN=2
g=get_edges_attributes(g,tsc$membership,NA,"black",e_OUT,e_IN,3,1)

if(vNUM<1000){
	pdf(paste(file_out,"-3.pdf",sep=""),w=wd,h=ht)
	plot(tsc,g, layout=layout,vertex.label=NA,col=new_cols,mark.col=mark_cols,edge.width=E(g)$width,mark.border=mark_border_cols,edge.color=E(g)$color,edge.lty=E(g)$lty)
	dev.off()
}


#######################################################
conn_info=read.table(file_conn_info)
conn_info=as.matrix(conn_info)

terrNUM=nrow(conn_info)

terrMAX=max(conn_info[,2])
conn_terr=which(conn_info[,3]==1)
dis_terr=which(conn_info[,3]==0)
disNUM=length(dis_terr)
connNUM=length(conn_terr)
#------------------------------------------------------
# the above is used for plotting separate terraces
#------------------------------------------------------

#########################################
# Plotting terrace subgraphs
########################################
terrPLOT="TRUE"

if(terrPLOT=="TRUE"){
	terr_to_plot=which(conn_info[,2]>3)
	if(length(terr_to_plot)>0){
		for(terrID in terr_to_plot){
			if(conn_info[terrID,3]!=1 && conn_info[terrID,2]!=5){
			V_list=which(V(g)$community[]==terrID)
			plot_terrace_subgraph(g,V_list,terrNUM,terrID,cols=cols,
				file=paste(file_out,"-terrace_sub-conn_",conn_info[terrID,3],"-N_",conn_info[terrID,2],"-comp_",conn_info[terrID,4],"-ID_",terrID,".pdf",sep=""))
			}
		}
	}
}
########################################
terrEXAMPLE="FALSE"

if(terrEXAMPLE=="TRUE"){

# plot one example with 2 taxa
terr_to_plot=which(conn_info[,2]==2)
if(length(terr_to_plot)>0){
	terrID=terr_to_plot[1]
	V_list=which(V(g)$community[]==terrID)
	plot_terrace_subgraph(g,V_list,terrNUM,terrID,cols=cols,file=paste(file_out,"-terrace_sub-conn_",conn_info[terrID,3],"-N_",conn_info[terrID,2],"-comp_",conn_info[terrID,4],"-ID",terrID,".pdf",sep=""))
}

# plot one example with 3 taxa
terr_to_plot=which(conn_info[,2]==3)
if(length(terr_to_plot)>0){
        terrID=terr_to_plot[1]
        V_list=which(V(g)$community[]==terrID)
        plot_terrace_subgraph(g,V_list,terrNUM,terrID,cols=cols,file=paste(file_out,"-terrace_sub-conn_",conn_info[terrID,3],"-N_",conn_info[terrID,2],"-comp_",conn_info[terrID,4],"-ID",terrID,".pdf",sep=""))
}
}
