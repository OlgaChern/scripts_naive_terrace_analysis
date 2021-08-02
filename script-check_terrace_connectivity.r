args = commandArgs(trailingOnly=TRUE)
# the file with adjacency matrix for all trees on a terrace (IQ-TREE format rf_all)
file=args[1]

d=read.table(paste(file,sep=""),skip=1)
d=d[,-1]
d=as.matrix(d)

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

c=cohesion(g) # how many edges needed to be deleted, such that a vertex, when deleted splits the graph, if 0 then the graph is alread disconnected
con=is_connected(g) # TRUE or FALSE

comp=components(g, mode = c("weak")) # analyses disconnected components. Outputs: $membership each vertex (tree) to which component it belongs to; $csize - the size of each component; $no - the number of components

print(paste(nrow(d),con,comp$no,paste(comp$csize,collapse=" "),paste(comp$membership,collapse=" "),c,sep="|"))


