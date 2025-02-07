# Social Network Analysis
library(igraph)

g <- graph(c(1,2,2,3,3,4,4,1), directed = F, n=7)

plot(g,
     vertex.color = "green",
     vertex.size = 40,
     edge.color = 'red')

g[]

g1 <- graph(c("Amy", "Ram", "Ram","li","li","Amy","Amy",
        "li","kate","li"), directed = T)

plot(g1,
     vertex.color = "green",
     vertex.size = 40,
     edge.color = 'red')

g1[]
g1
# Network (graph) Measures
degree(g1, mode = 'all')
degree(g1, mode = 'in') # how many arrows coming to each one
degree(g1, mode = 'out')

diameter(g1, directed=F, weights = NA) # It’s the greatest distance (in terms of the number of edges) you would need to travel to go from one node to another, considering the shortest paths between all pairs of nodes in the graph.
edge_density(g1, loops=F) # Edge density is a measure of how many edges are present in a graph compared to the maximum possible number of edges.
# same result below: ecount: nb of edges, vcount(g1): nb of vertexes
ecount(g1)/(vcount(g1)*(vcount(g1)-1))

reciprocity(g1) #  calculates the reciprocity of a graph, which is a measure of how many reciprocal edges exist between pairs of nodes.
closeness(g1, mode = 'all', weights=NA) # closeness to other vertexes, calculates the closeness centrality of the nodes in the graph g1. Closeness centrality measures how close a node is to all other nodes in the graph, based on the shortest paths between nodes.
betweenness(g1, directed = T, weights=NA) # Betweenness centrality measures how often a node acts as a "bridge" along the shortest path between other nodes. A node with high betweenness has control over the flow of information or resources between other nodes.
edge_betweenness(g1, directed = T, weights=NA) #  Edge betweenness centrality measures how often an edge is part of the shortest path between two nodes. An edge with high betweenness is important for connecting different parts of the graph.


# Read Data File
# Examples: twitter / University website/ FB Friends/ Email networfs/ FB Likes

# Set seed for reproducibility
set.seed(123)

# Possible values for each column
first_values <- c('AA', 'AB', 'AC', 'AD', 'AE', 'AF', 'AG', 'AH', 'AI', 'AJ')
second_values <- c('BB', 'BC', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BK')
grades <- c(6, 7, 8, 9)
specs <- c('Y', 'R')

# Generate 50 rows of data
n <- 50
data <- data.frame(
  first = sample(first_values, n, replace = TRUE),
  second = sample(second_values, n, replace = TRUE),
  grade = sample(grades, n, replace = TRUE),
  spec = sample(specs, n, replace = TRUE)
)
data


y <- data.frame(data$first, data$second)

# create a Network
net <- graph.data.frame(y, directed = T)
plot(net)
V(net) # retrieves the vertices (nodes) of the graph net.
E(net) #  retrieves the edges of the graph net. 
V(net)$label <- V(net)$name # assigns the name of each vertex (node) in the graph to its label attribute.
V(net)$degree <- degree(net) #  calculates the degree of each vertex (the number of edges connected to it) and assigns it to the degree attribute of each vertex.


# Histogrm of Node Diagram
hist(V(net)$degree,
     col = 'green',
     main = "Histogram of node Degree",
     ylab = 'frequency',
     xlab = 'Degree of Vertices')


# Network Diagram
set.seed(222)
plot(net,
     vertex.color = 'green',
     edge.arrow.size = 0.1,
     vertex.label.cex = 0.8)

# Highlighting degrees & layouts
plot(net,
     vertex.color = rainbow(52),
     #vertex.size = V(net)$degree * 0.4,
     edge.arrow.size = 0.1,
     layout = layout_with_fr(net))

# Do not Work !!!!!
# Hub and authorities
hs <- hub_score(net)$vector # This function calculates the hub scores for the nodes in the graph net. Hub scores measure how influential a node is in terms of pointing to other highly authoritative nodes.
as <- authority.score(net)$vector # This function calculates the authority scores for the nodes in the graph net. Authority scores measure how authoritative a node is, based on how many good hubs point to it.
par(mfrow = c(1, 2)) 
set.seed(123)
plot(net,
     vertex.size=hs*30,
     main = "Hubs",
     vertex.color = rainbow(52),
     edge.arrow.size = 0.1,
     layout = layout_with_fr(net))

set.seed(123)
plot(net,
     vertex.size=as*30,
     main = "Authorities",
     vertex.color = rainbow(52),
     edge.arrow.size = 0.1,
     layout = layout_with_fr(net))

# Community Detection: detect groups of density connected nodes
# This helps group closely connected nodes and visualize the structure of communities
net <- graph.data.frame(y, directed = F)
cnet <- cluster_edge_betweenness(net)
plot(cnet,
     net,
     vertex.size = 10,
     vertex.label.cex = 0.8)
