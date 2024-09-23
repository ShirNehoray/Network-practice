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
