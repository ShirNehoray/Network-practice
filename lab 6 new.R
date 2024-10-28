package.list=c("tidyverse", "magrittr","igraph","Matrix","DT","hablar","devtools")
loaded <-  package.list %in% .packages()
package.list <-  package.list[!loaded]
installed <-  package.list %in% .packages(TRUE)
if (!all(installed)) install.packages(package.list[!installed],repos="http://cran.rstudio.com/")

devtools::install_github('Ecological-Complexity-Lab/emln', force=T)

library(emln)

library(muxViz)
library(infomapecology)
library(igraph)
library(bipartite)
library(tidyverse)
library(magrittr)
library(readxl)
library(ggalluvial)

pond_1 <- matrix(c(0,1,1,0,0,1,0,0,0), byrow = T, nrow = 3, ncol = 3, dimnames = list(c('pelican','fish','crab'),c('pelican','fish','crab')))

pond_2 <- matrix(c(0,1,0,0,0,1,0,0,0), byrow = T, nrow = 3, ncol = 3, dimnames = list(c('pelican','fish','crab'),c('pelican','fish','crab')))

pond_3 <- matrix(c(0,1,1,0,0,1,0,0,0), byrow = T, nrow = 3, ncol = 3, dimnames = list(c('pelican','fish','tadpole'),c('pelican','fish','tadpole')))

layer_attrib <- tibble(layer_id=1:3,
                       layer_name=c('pond_1','pond_2','pond_3'),
                       location=c('valley','mid-elevation','uphill'))

multilayer <- create_multilayer_network(list_of_layers = list(pond_1, pond_2, pond_3), 
                                        bipartite = F, 
                                        directed = T)
multilayer$extended

# Load and organize the trophic interactions matrix
chilean_TI <- read_delim('/Users/shirnehoray/GitHub/data/chilean_TI.txt', delim = '\t')
nodes <- chilean_TI[,2]
names(nodes) <- 'Species'
chilean_TI <- data.matrix(chilean_TI[,3:ncol(chilean_TI)])
dim(chilean_TI)


dimnames(chilean_TI) <- list(nodes$Species,nodes$Species)

# Load and organize the negative non-trophic interactions matrix
chilean_NTIneg <- read_delim('/Users/shirnehoray/GitHub/data/chilean_NTIneg.txt', delim = '\t')
nodes <- chilean_NTIneg[,2]
names(nodes) <- 'Species'
chilean_NTIneg <- data.matrix(chilean_NTIneg[,3:ncol(chilean_NTIneg)])
dim(chilean_NTIneg)

dimnames(chilean_NTIneg) <- list(nodes$Species,nodes$Species)

# Are all row and column names the same?
setequal(rownames(chilean_TI), rownames(chilean_NTIneg))
setequal(colnames(chilean_TI), colnames(chilean_NTIneg))
chilean_NTIneg <- chilean_NTIneg[rownames(chilean_TI),colnames(chilean_TI)]
all(rownames(chilean_TI)==rownames(chilean_NTIneg))


# Load and organize the negative non-trophic positive matrix
chilean_NTIpos <- read_delim('/Users/shirnehoray/GitHub/data/chilean_NTIpos.txt', delim = '\t')
nodes <- chilean_NTIpos[,2]
names(nodes) <- 'Species'
chilean_NTIpos <- data.matrix(chilean_NTIpos[,3:ncol(chilean_NTIpos)])
dim(chilean_NTIpos)

dimnames(chilean_NTIpos) <- list(nodes$Species,nodes$Species)

# Are all row and column names the same?
setequal(rownames(chilean_TI), rownames(chilean_NTIpos))
setequal(colnames(chilean_TI), colnames(chilean_NTIpos))
chilean_NTIpos <- chilean_NTIpos[rownames(chilean_TI),colnames(chilean_TI)]
all(rownames(chilean_TI)==rownames(chilean_NTIpos))


# Total number of links
sum(chilean_TI, chilean_NTIpos, chilean_NTIneg)


# Create the multilayer object
layer_attributes <- tibble(layer_id=1:3, layer_name=c('TI','NTIneg','NTIpos'))

multilayer_kefi <- create_multilayer_network(list_of_layers = list(chilean_TI,chilean_NTIneg,chilean_NTIpos),
                                             interlayer_links = NULL,
                                             layer_attributes = layer_attributes,
                                             bipartite = F,
                                             directed = T)

# This is for the Kefi data set
chilean_TI_ll <- matrix_to_list_unipartite(x = chilean_TI, directed = TRUE)$edge_list
chilean_NTIneg_ll <- matrix_to_list_unipartite(x = chilean_NTIneg, directed = TRUE)$edge_list
chilean_NTIpos_ll <- matrix_to_list_unipartite(x = chilean_NTIpos, directed = TRUE)$edge_list
multilayer_kefi_ll <- create_multilayer_network(list_of_layers = list(chilean_TI_ll,chilean_NTIneg_ll,chilean_NTIpos_ll), layer_attributes = layer_attributes, bipartite = F, directed = T)

# Check that the set of links is the same in both
links_mat <- multilayer_kefi$extended_ids %>% unite(layer_from, node_from, layer_to, node_to)
links_ll <- multilayer_kefi_ll$extended_ids %>% unite(layer_from, node_from, layer_to, node_to)

any(duplicated(links_mat$layer_from))
setequal(links_mat$layer_from, links_ll$layer_from)

# Create the ELL tibble with interlayer links.
interlayer <- tibble(layer_from=c('pond_1','pond_1','pond_1'),
                     node_from=c('pelican','crab','pelican'),
                     layer_to=c('pond_2','pond_2','pond_3'), 
                     node_to=c('pelican','crab','pelican'),
                     weight=1)

# This is a directed network so the links should go both ways, even though they are symmetric.
interlayer_2 <- interlayer[,c(3,4,1,2,5)]
names(interlayer_2) <- names(interlayer)
interlayer <- rbind(interlayer, interlayer_2)

# An example with layer attributes and interlayer links
multilayer_unip_toy <- create_multilayer_network(list_of_layers = list(pond_1, pond_2, pond_3),
                                                 interlayer_links = interlayer,
                                                 layer_attributes = layer_attrib,
                                                 bipartite = F,
                                                 directed = T)
multilayer_unip_toy$extended

# Import layers
Sierras_matrices <- NULL
for (layer in 1:12){
  d <- suppressMessages(read_excel('/Users/shirnehoray/GitHub/data/Gilarranz2014_Datos Sierras.xlsx', sheet = layer+2))
  web <- data.matrix(d[,2:ncol(d)])
  rownames(web) <- as.data.frame(d)[,1]
  web[is.na(web)] <- 0
  Sierras_matrices[[layer]] <- web
}
names(Sierras_matrices) <- excel_sheets('/Users/shirnehoray/GitHub/data/Gilarranz2014_Datos Sierras.xlsx')[3:14]
# Layer dimensions
sapply(Sierras_matrices, dim)

layer_attrib <- tibble(layer_id=1:12, layer_name=excel_sheets('/Users/shirnehoray/GitHub/data/Gilarranz2014_Datos Sierras.xlsx')[3:14])

multilayer_sierras <- create_multilayer_network(list_of_layers = Sierras_matrices, bipartite = T, directed = F, layer_attributes = layer_attrib)

multilayer_sierras$extended

dist <- data.matrix(read_csv('/Users/shirnehoray/GitHub/data/Gilarranz2014_distances.csv'))
dimnames(dist) <- list(layer_attrib$layer_name, layer_attrib$layer_name)

# Get the dispersal matrix, for pollinators only. This matrix shows which pollinator is in which layer
dispersal <- multilayer_sierras$extended %>% group_by(node_from) %>% dplyr::select(layer_from) %>% table()
dispersal <- 1*(dispersal>0)

Sierras_interlayer <- NULL
for (s in rownames(dispersal)){ # For each pollinator
  x <- dispersal[s,]
  locations <- names(which(x!=0)) # locations where pollinator occurs
  if (length(locations)<2){next}
  pairwise <- combn(locations, 2)
  # Create interlayer edges between pairwise combinations of locations
  for (i in 1:ncol(pairwise)){
    a <- pairwise[1,i]
    b <- pairwise[2,i]
    weight <- dist[a,b] # Get the interlayer edge weight
    Sierras_interlayer %<>% bind_rows(tibble(layer_from=a, node_from=s, layer_to=b, node_to=s, weight=weight))
  }
}

# Re-create the multilayer object with interlayer links
multilayer_sierras_interlayer <- create_multilayer_network(list_of_layers = Sierras_matrices, bipartite = T, directed = F, layer_attributes = layer_attrib, interlayer_links = Sierras_interlayer)

# See the interlayer links
multilayer_sierras_interlayer$extended %>% filter(layer_from!=layer_to)
multilayer_sierras_interlayer$extended_ids %>% filter(layer_from!=layer_to)

#plotting
g <- get_igraph(multilayer = multilayer_kefi, bipartite = F, directed = T) # get a list of igraph objects using EMLN
muxViz::plot_multiplex(g.list=g$layers_igraph, layer.colors = c('orange','blue','red'))



library(muxViz)
library(infomapecology)
library(igraph)
library(bipartite)
library(tidyverse)
library(magrittr)
library(readxl)
library(ggalluvial)

mEdges <- as.data.frame(multilayer_kefi$extended_ids[,c(2,1,4,3,5)])
colnames(mEdges)[1:4] <- c("node.from", "layer.from", "node.to", "layer.to")
M <- BuildSupraAdjacencyMatrixFromExtendedEdgelist(mEdges,3,106,T)
out_deg <- GetMultiOutDegree(M, Layers = 3, Nodes = 106, isDirected = T)
in_deg <- GetMultiInDegree(M, Layers = 3, Nodes = 106, isDirected = T)
tibble(out_deg, in_deg) %>% ggplot(aes(in_deg, out_deg))+geom_point()+labs(x='In degree', y='Out degree')+
  geom_abline()+
  xlim(0,85)+
  ylim(0,85)+
  coord_fixed()

