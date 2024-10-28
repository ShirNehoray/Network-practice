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
