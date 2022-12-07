#----------------------------------------
# This script sets out to produce a high
# level visualisation of the time series
# of all amplifiers
#
# NOTE: This script requires setup.R to
# have been run first
#----------------------------------------

#----------------------------------------
# Author: Trent Henderson, 24 August 2021
#----------------------------------------

# Load data

load("data/raw-signals-numeric/amplifiers.Rda")

#------------- Draw plots -------------

#' Draw time series plots for each plugin
#' @param data the dataframe of time series values
#' @param t1 the first timepoint to plot from
#' @param t2 the last timepoint to plot to
#' @return an object of class \code{ggplot2}
#' @author Trent Henderson
#'

plot_time_series <- function(data, t1, t2){

  p <- amplifiers %>%
    filter(timepoint %in% seq(from = t1, to = t2, by = 1)) %>%
    ggplot(aes(x = timepoint, y = amplitude, colour = id)) +
    geom_line() +
    labs(x = "Time",
         y = "Amplitude",
         colour = NULL) +
    theme_bw() +
    theme(legend.position = "none",
          panel.grid.minor = element_blank(),
          strip.background = element_blank(),
          strip.text = element_text(face = "bold"),
          axis.text.x = element_text(angle = 90)) +
    facet_wrap(~id, ncol = 3, scales = "free_y")

  return(p)
}

# Render them

p <- plot_time_series(data = amplifiers, t1 = 1, t2 = 1000)
p1 <- plot_time_series(data = amplifiers, t1 = 400000, t2 = 400050)
p2 <- plot_time_series(data = amplifiers, t1 = max(amplifiers$timepoint) - 1000, t2 = max(amplifiers$timepoint))

# Save plots

ggsave("output/time-series.png", p, units = "in", height = 8, width = 8)
ggsave("report/time-series.pdf", p, units = "in", height = 8, width = 8)
ggsave("output/time-series2.png", p1, units = "in", height = 8, width = 8)
ggsave("report/time-series2.pdf", p1, units = "in", height = 8, width = 8)
ggsave("output/time-series3.png", p2, units = "in", height = 8, width = 8)
ggsave("report/time-series3.pdf", p2, units = "in", height = 8, width = 8)
