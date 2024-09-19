A_u <- matrix(c(0,1,1,0,0, # An example input matrix
                1,0,0,1,1,
                1,0,0,0,0,
                0,1,0,0,0,
                0,1,0,0,0),5,5, byrow=F)
isSymmetric(A_u)
A_u
g <- igraph::graph.adjacency(A_u, mode = 'directed')
par(mar=c(0,0,0,0))
plot(g)
g <- igraph::graph.adjacency(A_u, mode = 'undirected')
par(mar=c(0,0,0,0))
plot(g)



A_d <- matrix(c(0,1,1,0,1, # An example input matrix
                1,0,0,1,1,
                1,0,0,0,0,
                0,1,0,0,0,
                0,1,1,0,0),5,5, byrow=F)
isSymmetric(A_d)
g1 <- igraph::graph.adjacency(A_d, mode = 'directed')
par(mar=c(0,0,0,0))
plot(g1)

A_w <- matrix(c(0,1,1,0,0, # An example input matrix
                1,0,0,1,1,
                1,0,0,0,0,
                0,1,0,0,0,
                0,1,0,0,0),5,5, byrow=F)
random_weights <- round(rnorm(10, 10, 4),2) # take weights from a normal distribution.
A_w[lower.tri(A_w)] <- A_w[lower.tri(A_w)]*random_weights # Fill the lower traiangle
A_w <- A_w+t(A_w) # This makes the matrix symmetric
isSymmetric(A_w)
A_w
library(igraph)
g <- igraph::graph.adjacency(A_w, mode = 'undirected', weighted = T)
E(g)$weight
par(mar=c(0,0,0,0))
plot(g, edge.color=E(g)$weight, edge.width = E(g)$weight,  weighted = T, vertex.label = E(g)$weight)

