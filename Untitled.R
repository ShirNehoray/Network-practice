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
