networkdata <- read.csv("networkdata.csv")

# Interactive network diagram using networkD3
install.packages("networkD3")
library(networkD3)
simpleNetwork(networkdata, fontSize=16,
              nodeColour= "black",
              nodeClickColour = "red",
              zoom=T)