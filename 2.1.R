A_u <- matrix(c(0,1,1,0,0, # An example input matrix
                1,0,0,1,1,
                1,0,0,0,0,
                0,1,0,0,0,
                0,1,0,0,0),5,5, byrow=F)
isSymmetric(A_u)
A_u
g <- igraph::graph.adjacency(A_u, mode = 'undirected')
par(mar=c(0,0,0,0))
plot(g)
