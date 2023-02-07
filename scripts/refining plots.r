
require(ggplot2)
require(lubridate)
require(colorspace)
require(ggridges)
require(ggthemes)
require(pkgsimon)
require(cowplot)
require(colorblindr)
require(viridis)

################################################################################

breaks = c("setosa", "virginica", "versicolor")
labels = paste0("Iris ", breaks)

# Custom color palette

my_col <- c("#1b9e77", "#d95f02", "#7570b3")


# Base plot

p <- ggplot(iris,
            aes(x = Sepal.Length,
                y = Sepal.Width)) + 
  geom_point()

p

# Change the size of points

p <- ggplot(iris,
            aes(x = Sepal.Length,
                y = Sepal.Width)) + 
  geom_point(size=2.5)

p

# Separate species by different filled colors
# shape must be one of the filled symbols 21,22,23,24
#   vignette("ggplot2-specs")

p <- ggplot(iris,
            aes(x   = Sepal.Length,
                y   = Sepal.Width,
                fill= Species)) + 
  geom_point(size  = 2.5,
             shape = 21) 

#experimenting for lab 3
#labs(subtitle = "Flowers"{color="red"})

p


vignette('ggplot2-specs')
  # Try without changing the 'shape', and see what happens?

 
# Add some random jittering, why?

p <- ggplot(iris,
            aes(x     = Sepal.Length,
                y     = Sepal.Width,
                fill  = Species)) + 
  geom_point(size     = 2.5,
             alpha = 0.5,
             shape    = 21,
             position = position_jitter(
               width = 0.01 * diff(range(iris$Sepal.Length)),
               height = 0.01 * diff(range(iris$Sepal.Width)),
               seed = 3942))
  
p


# Custom color palette

p <- p + 
  scale_fill_manual(values = my_col,
                    breaks = breaks,
                    labels = labels,
                    name = NULL) 

p

#covered at 3:29pm

# Custom axes

p <- p +
  scale_x_continuous(limits = c(3.95, 8.2), 
                     expand = c(0, 0),
                     labels = c("4.0", "5.0", "6.0", "7.0", "8.0"),
                     name = "Sepal length") +
  scale_y_continuous(limits = c(1.9, 4.6), 
                     expand = c(0, 0),
                     name = "Sepal width")


    # What does expand(0,0) do?

p

# Changing the theme

  # ggplot2 themes, https://ggplot2.tidyverse.org/reference/ggtheme.html
  # ggthemes, https://yutannihilation.github.io/allYourFigureAreBelongToUs/ggthemes/
  # https://github.com/SimonCoulombe/pkgsimon

devtools::install_github("SimonCoulombe/pkgsimon")
library(pkgsimon)

p + theme_minimal()

p + theme_bw()

p + theme_wsj()

p + theme_dviz_grid()

p + theme_tufte()

p + theme_economist()


p <- p +
  theme_dviz_grid()

p

# Changing theme options

p <- p + theme(legend.title.align = 0.5,
               legend.text = element_text(face = "italic"),
               legend.spacing.y = unit(3.5, "pt"),
               plot.margin = margin(7, 7, 3, 1.5))

p

cvd_grid(p)


# Try again with the viridis package scales
# https://cran.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html


p <- p + 
  scale_fill_viridis(option="magma",
                            discrete=TRUE)

p

cvd_grid(p)

################################################################################
################################################################################

tech_stocks <- as.data.frame(rio::import(here("data", './tech_stocks.rda')))

price <- ggplot(tech_stocks,
                aes(x = date,
                    y = price_indexed, color = ticker))+
  geom_line(size = 0.6) 

# Add Custom colors

price <- price +
  scale_color_manual(
    values = c("#000000", "#E69F00", "#56B4E9", "#009E73"),
    name = "",
    breaks = c("FB", "GOOG", "MSFT", "AAPL"),
    labels = c("Facebook", "Alphabet", "Microsoft", "Apple")) 

price

# Customize the axes

price <- price +
  scale_x_date(
    name = "year",
    limits = c(ymd("2012-06-01"), ymd("2017-05-31")),
    expand = c(0,0)
  ) + 
  scale_y_continuous(
    name = "stock price, indexed",
    limits = c(0, 560),
    expand = c(0,0)
  )

price

# Customize the theme

price <- price + theme_dviz_hgrid() + 
  theme(plot.margin = margin(18, 1, 1, 1))

price

# Remove legend and use direct labeling

# The highest vaues on the price

  tech_stocks[which(tech_stocks$date=="2017-06-02"),]

yann <- axis_canvas(
  plot = price, 
  axis = "y") +
  geom_text(aes(y = c(342,194,554,252), 
                label = paste0(" ",c('Alphabet','Apple','Facebook','Google'))),
            x = 0, 
            hjust = 0, 
            size = 12/.pt)

price <- insert_yaxis_grob(
  plot  = price + theme(legend.position='none'),
  grob  = yann,
  width = grid::unit(0.3,'null')
  )


ggdraw(price)
