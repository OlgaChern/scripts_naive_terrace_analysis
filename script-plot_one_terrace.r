library(igraph)
library(RColorBrewer)


#source("/Users/Olga/Google_Drive/PhD/Projects/terraces/scripts/script-colors.r")


plot_terrace_subgraph<-function(g,V_list,terrNUM,terrID = 1,cols,file=""){

	if(file == ""){
		file=paste("plot-terrace-",terrID,".pdf",sep="")
	}

	if(length(cols)==0){
		cols=brewer.pal(11, 'Spectral')
	}

	pal <- colorRampPalette(cols)
	new_cols=pal(terrNUM) # color of vertices
	mark_border_cols=pal(terrNUM)	# color of borders of communities
	
	# color of communities
	pal2=colorRampPaletteAlpha(cols, n = terrNUM,alpha = 0.4)
	mark_cols=pal2
	

	#V(g)$community=comm
	g2=induced_subgraph(g,V_list)

	vNUM=length(V(g2))
	V(g2)$community=rep(terrID,vNUM)

	tsc_g2=cluster_label_prop(g2)
	tsc_g2$membership=V(g2)$community

	wd=5
	ht=5
	if(vNUM>2){
		#weights <- ifelse(crossing(tsc_g2, g2), 10, 1)      # 10,1 is best for kk | for fr 1,50
		#layout <- layout_with_kk(g2, weights=weights)
		#layout <- layout_with_kk(g2)
		#layout=layout_as_star(g2, center = V(g2)[1], order = NULL)
		layout=layout_with_fr(g2)
		#layout=layout_nicely
	}else if(vNUM==2){
		layout=matrix(c(1,2,1,1),nrow=2,ncol=2)
	}

	pdf(file,w=wd,h=ht)
	par(oma=c(0,0,0,0),mai = c(0, 0, 0, 0))
        plot(tsc_g2,g2, 
	     vertex.label=NA,vertex.size=10,
	     col=new_cols[terrID],mark.col=mark_cols[terrID],
	     edge.width=1,
	     mark.border=mark_border_cols[terrID],
	     edge.color="black",edge.lty=1,
	     layout=layout)
        dev.off()

}
