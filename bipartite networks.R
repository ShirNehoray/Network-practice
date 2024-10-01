library(igraph)
library(bipartite)
library(ggplot2)

data(olesen2002flores) # Check out the help for information on this data set!
olesen2002flores_binary <- 1 * (olesen2002flores > 0) # Make the data binary (unweighted)
I <- nrow(olesen2002flores_binary) # Number of lower level species (e.g., hosts, plants)
J <- ncol(olesen2002flores_binary) # Number of higher level species (e.g., parasites, pollinators)
S <- I + J # Total number of species, aka: Network size
L <- sum(olesen2002flores_binary > 0) # Number of edges in the network
A_i <- rowSums(olesen2002flores_binary) # The degree of hosts
A_j <- colSums(olesen2002flores_binary) # The degree of parasites
C <- L / (I * J) # Connectance
# Clustering coefficient higher level (the number of realized links 
# divided by the number of possible links for each species)
cc_high <- colSums(olesen2002flores_binary) / nrow(olesen2002flores_binary) 
# Clustering coefficient lower level 
# (the number of realized links divided by the number of possible links for each species)
cc_low <- rowSums(olesen2002flores_binary) / ncol(olesen2002flores_binary) 

olesen2002flores
  
S_i <- rowSums(olesen2002flores) # Node strength of hosts
S_j <- colSums(olesen2002flores) # Node strength of parasites

# Species level:
sl_metrics <- specieslevel(olesen2002flores)
names(sl_metrics$`higher level`)
sl_metrics$`higher level`$degree # The degree of flower visitors


# Group level:
gl_metrics <- grouplevel(olesen2002flores)
gl_metrics

# Network level
nl_metrics <- networklevel(olesen2002flores)
nl_metrics

degreedistr(memmott1999)

# Original
networklevel(memmott1999, index='connectance')

# Project plants
plants_projected <- tcrossprod(memmott1999>0) # Number of shared pollinators. Note the diagonal
plants_projected[1:5,1:5]


diag(plants_projected) <- 0
g <- graph.adjacency(plants_projected, mode = 'undirected', weighted = T)
par(mar=c(0,0,0,0))
plot(g, vertex.size=6, vertex.label=NA,
     edge.color='black', edge.width=log(E(g)$weight), 
     layout=layout.circle)
qplot(E(g)$weight)

pollinators_binary <- (memmott1999 > 0)
pollinators_project <- tcrossprod(pollinators_binary)
diag(pollinators_project) <- 0
g2 <- graph.adjacency(pollinators_project, mode = 'undirected', weighted = T)
par(mar=c(0,0,0,0))
plot(g2, vertex.size=6, vertex.label=NA,
     edge.color='black', edge.width=log(E(g)$weight), 
     layout=layout.circle)

plants_projected <- as.one.mode(memmott1999, project = 'lower')
g <- graph.adjacency(plants_projected, mode = 'undirected', weighted = T)
qplot(E(g)$weight)


plants_projected
