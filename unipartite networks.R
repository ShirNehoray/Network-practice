# First, load the data 
otago_nodes <- read.csv('/Users/shirnehoray/GitHub/data/Otago_Data_Nodes.csv')
otago_links <- read.csv('/Users/shirnehoray/GitHub/data/Otago_Data_Links.csv')
otago_web <- graph.data.frame(otago_links, vertices = otago_nodes, directed = T)

# Also load a weighted food web
chesapeake_nodes <- read.csv('/Users/shirnehoray/GitHub/data/Chesapeake_bay_nodes.csv', header=F)
names(chesapeake_nodes) <- c('nodeId','species_name')
chesapeake_links <- read.csv('/Users/shirnehoray/GitHub/data/Chesapeake_bay_links.csv', header=F)
names(chesapeake_links) <- c('from','to','weight')
ches_web <- graph.data.frame(chesapeake_links, vertices = chesapeake_nodes, directed = T)
# plot(ches_web, edge.width=log(E(ches_web)$weight)/2, layout=layout.circle)

deg_dist_out <- igraph::degree(otago_web, mode = 'out')
deg_dist_in <- igraph::degree(otago_web, mode = 'in')
df <- data.frame(deg=c(deg_dist_out,deg_dist_in),
                 direction=c(rep('out',length(deg_dist_in)),rep('in',length(deg_dist_in))))
ggplot(df, aes(deg, fill=direction)) + geom_histogram(alpha=0.3)
