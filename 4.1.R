data("memmott1999") # load
class(memmott1999)
library(bipartite)

memmott1999[1:4,1:4] # view first lines
plant_species <- rownames(memmott1999)
flower_visitor_species <- colnames(memmott1999)
head(plant_species, 3)


data("memmott1999") # load
class(memmott1999)
visweb(memmott1999)

memmott1999_binary <- 1*(memmott1999>0)
visweb(memmott1999_binary)


visweb(memmott1999,prednames = F, prey.lablength = 10)

plotweb(memmott1999, method="normal", arrow="up", y.width.low=0.3, low.lablength=4)

plotweb(memmott1999, arrow="both", y.width.low=0.05, text.rot=90, col.high="blue", 
        col.low="green")

# -------4.3

ural_data <- read.csv('/Users/shirnehoray/GitHub/data/Ural_valley_A_HP_048.csv')
ural_data[1:4,1:4]

rownames(ural_data) <- ural_data[,1] # Set row names
num_hosts_sampled <- ural_data[,2] # save in a variable
ural_data <- ural_data[,-2] # remove column
ural_data <- ural_data[,-1] # remove column
class(ural_data) # This is a data frame!

ural_data <- data.matrix(ural_data) # Transform to a matrix format
ural_data[1:4,1:4]



library(network)
library(sna)
ggnetwork(n, layout = "fruchtermanreingold", cell.jitter = 0.75)
ggnetwork(n, layout = "target", niter = 100)
ggplot(n, aes(x = x, y = y, xend = xend, yend = yend)) +
  geom_edges(aes(linetype = type), color = "grey50") +
  theme_blank()

