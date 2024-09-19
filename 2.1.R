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


L_u <- data.frame(i=c(1,1,2,2),
                j=c(2,3,4,5))
g <- igraph::graph.data.frame(L_u, directed = T)
par(mar=c(0,0,0,0))
plot(g)


L_u <- data.frame(from = c(1, 1, 2, 2, 2, 3, 3, 4, 5, 5),
                  to =c(2, 3, 1, 4, 5, 1, 5, 2, 1, 2))
g <- igraph::graph.data.frame(L_u, directed = T)
par(mar=c(1,0,0,0))
plot(g)


L_w <- data.frame(i=c(1,1,2,2),
                  j=c(2,3,4,5),
                  weight=round(rnorm(4, 10, 4),2) # take weights from a normal distribution.
)
g <- igraph::graph.data.frame(L_w, directed = T)
E(g)$weight

par(mar=c(0,0,0,0))
plot(g, edge.width=E(g)$weight, weighted = T, vertex.label = E(g)$weight, edge.color = E(g))

L_wd <- data.frame(from=c(1, 1, 2, 2, 2, 3, 3, 4, 5, 5),
                   to=c(2, 3, 1, 4, 5, 1, 5, 2, 1, 2),
                   weight=round(rnorm(10, 1, 0.2),2))
g <- igraph::graph.data.frame(L_wd, directed = T)
g
plot(g)
E(g)$weight
par(mar=c(0,0,0,0))
plot(g, edge.width=log(E(g)$weight)*10, # possible to rescale edge weights when plotting 
     edge.arrow.size=1.2,
     edge.curved=0.5,
     edge.color='black')
