## Firstly install all necessary packages.

install.packages("ggmap")
install.packages("ggrepel")
install.packages("gridExtra")

library(tidyverse)
library(lubridate)
library(ggmap)
library(ggrepel)
library(gridExtra)
library(pander)
library(dplyr)
library("readxl")
library("xlsx")
install.packages("rlang", type = "source")
library("rlang")
install.packages("reshape")
library("reshape")

require(ggplot2)
install.packages("ggforce")
install.packages("svgPanZoom")
install.packages("svglite")
library(svglite)
library("svgPanZoom")
library("ggforce")
install.packages("ggpubr")
library(ggpubr)


install.packages("HistData")
library(HistData)
data(Nightingale)
require(reshape)

## Picking deaths columns, date column
Data<- Nightingale[,c(1,5:7)]
## Pivot the data in a variable column
pivoted_data <- melt(Data, "Date")
## Give meaningful names to columns
names(pivoted_data) <- c("Date", "Cause", "Deaths")

# subsets, to facilitate separate plotting
before_data <- subset(pivoted_data, Date < as.Date("1855-04-01"))
after_data <- subset(pivoted_data, Date >= as.Date("1855-04-01"))

# sort according to Deaths in decreasing order, so counts are not obscured
before_data <- before_data[order(before_data$Deaths, decreasing=TRUE),]
after_data <- after_data[order(after_data$Deaths, decreasing=TRUE),]

## Define color values for three categories(Death- blue, Wound- pink, other- black)
color_values <- c("Wounds" = "#f8cef0",
                  "Disease" = "#b3bcef", 
                  "Other" = "#231919"
)



# Before plot
a<- ggplot(b1, aes(x = factor(Date), y=Deaths, fill =Cause)) + geom_bar(width = 1, position="identity", stat="identity", color="black")+  scale_y_sqrt()  + coord_polar(start=3*pi/2) + 
  ggtitle("Nightingale' Rose Chart from April 1854 to March 1855") +  scale_fill_manual(values = color_values, limits= names(color_values))

## After plot
b<-ggplot(after_data, aes(x = factor(Date), y=Deaths, fill = Cause)) +
  geom_bar(width = 1, position="identity", stat="identity", color="black") +
  scale_y_sqrt() + coord_polar(start=3*pi/2) +  ggtitle("Nightingale' Rose Chart from April 1855 to March 1856") +  xlab("")+ scale_fill_manual(values = color_values, limits= names(color_values))


## Plotting both graphs together
ggarrange(b, a, labels = c("B", "A"), ncol = 2, nrow = 1)


## Zoom into the second graph. Zoom in will happen when mouse will scrolled up and down.
svgPanZoom(
  svglite:::inlineSVG(
        show(
      a
    )
  )
)  




