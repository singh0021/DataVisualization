# 0. Loading libaries

#install.packages("tidyr")
#install.packages("tidyverse")
#install.packages("sf") 
#install.packages("maptools")
#install.packages("gganimate")
#install.packages("gifski")
#install.packages("png")
# devtools::install_github("jakelawlor/PNWColors")
#install.packages("rlang", type = "source")

library(rlang)
library(tidyverse)
library(sf) 
library(maptools)
library(gganimate)
library(dplyr)
library(tidyr)
library(usmap)
library(gganimate)
library(PNWColors)
library(extrafont) #getting fonts
library(gifski)#loading gif renderer
library(png)
library(PNWColors)

# 1. Read beer data in a data frame
## Data Downloaded from Kaggle
setwd('S:/Acctn/Trinity/Modules/DataVisualization/Assignment3')
data.beer <- read.csv('S:/Acctn/Trinity/Modules/DataVisualization/Assignment3/beer_states.csv')


# 2 cleaning things up a bit
names(state.abb) <- state.name 
names(state.name) <- state.abb

# lets reorganize dataframe: making "type" into separate columns and cleaning data a little bit

data.beer$type <- gsub("\\s", "_", data.beer$type) %>% tolower()
View(data.beer)

# Now lets convert data into column heads
c.beer <-  data.beer %>% spread(type, barrels)%>%
  mutate(total = on_premises + bottles_and_cans + kegs_and_barrels,
         Aggtotal = total / 1000000)

View(c.beer)
#Fixing the order of colors, more beer gets darker beer.
light_Dark.color <- rev(pnw_palette("Shuksan", 100))#light to dark

#Now lets plot the final graph with each state
map.beer <- plot_usmap(data = c.beer, values = "Aggtotal", region = "states", labels =TRUE) +   scale_fill_gradientn(name = "Million barrels", colors = light_Dark.color) +
  theme(plot.background   =element_rect(fill = "orange"), panel.background = element_blank(),
        plot.title = element_text(size = rel(2.5), family = "Bahnschrift",
                                  hjust = 0.5,
                                  color="black"),
        plot.subtitle = element_text(size = rel(1.8), 
                                     family = "Bahnschrift", 
                                     color = "black", 
                                     lineheight = 1.4,
                                     hjust = 0.5),
        legend.position = "bottom",
        legend.justification = "center",
        legend.background = element_rect(fill = "#f5f3f3"),
        legend.text = element_text(size = rel(1),
                                   family = "Bahnschrift",
                                   color="black"),
        legend.title = element_text(size = rel(1.4),
                                    family = "Bahnschrift",
                                    color="black"))+ labs(title = "Total Beer Production in US States", subtitle = "Year: {current_frame}")+transition_manual(year)

#Seeing the final map
final.map <- animate(map.beer)

final.map

## Lets save it in directory
anim_save("Assignment3_19308502.gif", final.map)
getwd()
