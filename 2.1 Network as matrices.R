#This code is from the course Networks in Biology and Ecology.
# See: https://ecological-complexity-lab.github.io/network_course/index.html
# See license details here: https://ecological-complexity-lab.github.io/network_course/index.html#License

## ----load libraries, echo=TRUE, message=FALSE, warning=FALSE-----------------------------------------
# install.packages('igraph')
library('igraph')
# install.packages('bipartite')
library('bipartite')


## ----echo=TRUE---------------------------------------------------------------------------------------
?igraph::betweenness()


## ----------------------------------------------------------------------------------------------------
g1 <- graph(edges=c(1,2, 2,3, 3, 1), n=3, directed=F) 
plot(g1) # A simple plot of the network - we'll talk more about plots later
class(g1)
g1


## ----------------------------------------------------------------------------------------------------
g2 <- graph(edges=c(1,2, 2,3, 3, 1), n=10, directed=T)
plot(g2)
g2

g3 <- graph(c("plankton", "fish1", "plankton", "fish2",
              "fish2", "fish1", "shark", "fish1", "shark", "fish2"), directed=T) # named vertices
plot(g3, edge.arrow.size=.5, vertex.color="gold", vertex.size=15,
     vertex.frame.color="gray", vertex.label.color="black", 
     vertex.label.cex=0.8, vertex.label.dist=2, edge.curved=0.2)
E(g3)
V(g3)

V(g3)$taxonomy <- c("diatoms", "Genus sp1", "Genus sp2", "Genus sp3")
E(g3)$type <- "predation" # Edge attribute, assign "email" to all edges
E(g3)$weight <- c(1,1.5,4,10, 6) 
edge_attr(g3)

vertex_attr(g3)
g <- make_bipartite_graph(rep(0:1,length=10), c(1:10))
g
vertex_attr(g)
plot(g, edge.arrow.size=.5, vertex.color="gold", vertex.size=15,
     vertex.frame.color="gray", vertex.label.color="black", 
     vertex.label.cex=0.8, vertex.label.dist=2, edge.curved=0.2)
is_bipartite(g)
plot(g, layout=layout_as_bipartite)

