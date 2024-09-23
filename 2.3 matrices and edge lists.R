# Matrix:
V(g)$name <- c('Sp1','Sp2','Sp3','Sp4','Sp5')
E(g)$weight <- rpois(10, 3)
g[]
plot(g)

as_adjacency_matrix(g, names = T, attr = 'weight', sparse = F)
# Edge list and nodes
igraph::as_data_frame(g, what = 'edges')


g <- igraph::graph.adjacency(A_w, mode = 'directed', weighted = T)
L <- igraph::as_data_frame(g, what = 'edges')
L
g
plot(g)
plot(L)

L_wd
g <- igraph::graph.data.frame(L_wd, directed = T)
A <- igraph::as_adjacency_matrix(g, attr = 'weight', sparse=T)
A

# install.packages('igraph')
library('igraph')
# install.packages('bipartite')
library('bipartite')
library('readr')
otago_nodes <- read.csv('/Users/shirnehoray/GitHub/data/Otago_Data_Nodes.csv')
otago_links <- read.csv('/Users/shirnehoray/GitHub/data/Otago_Data_Links.csv')
otago_nodes[1:4,1:6]
otago_links[1:4, 1:8]

# Import to igraph, including edge and node attributes
otago_web <- graph.data.frame(otago_links, vertices = otago_nodes, directed = T)
names(edge_attr(otago_web))
head(unique(E(otago_web)$LinkType))
names(vertex_attr(otago_web))
head(unique(V(otago_web)$WorkingName))


par(mar=c(0,0,0,0)) #Reduce margin size
plot(otago_web)


par(mar=c(0,0,0,0))
plot(otago_web, vertex.size=3, edge.arrow.size=0.4, vertex.label=NA, layout=layout.circle)


E(otago_web)$color <- "grey" # First, we set a default color
E(otago_web)[otago_links$LinkType == 'Predation']$color <- "black"
E(otago_web)[otago_links$LinkType == 'Macroparasitism']$color <- "blue"
E(otago_web)[otago_links$LinkType == 'Trophic Transmission']$color <- "red"
# Now plot
par(mar=c(0,0,0,0))
plot(otago_web, vertex.size=2, edge.arrow.size=0.2, vertex.label=NA, layout=layout.circle)


# Basal species (those that do not consume) -- do not have incoming links
basal <- which(igraph::degree(otago_web, mode = 'in') == 0)
# Top species do not have outgoing links
top <- which(igraph::degree(otago_web, mode = 'out') == 0)
# Intermediate are all the rest
interm <- V(otago_web)[which(!V(otago_web) %in% c(basal,top))]
# Are all the nodes included?
all(c(basal,top,interm) %in% V(otago_web))


V(otago_web)$troph_pos <- rep(0,length(V(otago_web)))
V(otago_web)$troph_pos[which(V(otago_web)$name %in% basal)] <- 1
V(otago_web)$troph_pos[which(V(otago_web)$name %in% top)] <- 3
V(otago_web)$troph_pos[which(V(otago_web)$name %in% interm)] <- 2
# create a matrix forthe layout coordinates.
coords <- matrix(nrow=length(V(otago_web)), ncol=2) #
# The x positions are randomly selected
coords[,1] <- runif(length(V(otago_web)))
# The y positions are the trophoc positions
coords[,2] <- V(otago_web)$troph_pos
par(mar=c(0,0,0,0))
plot(otago_web,layout=coords,
     vertex.color=V(otago_web)$troph_pos,
     vertex.label=NA,
     vertex.size=8,
     edge.color='black',
     edge.arrow.size=.3,
     edge.width=.5)
