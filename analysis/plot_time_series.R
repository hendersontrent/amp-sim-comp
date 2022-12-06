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

# Draw plot for first 1000 time points

p <- amplifiers %>%
  filter(timepoint <= 1000) %>%
  ggplot(aes(x = timepoint, y = amplitude, colour = id)) +
  geom_line() +
  labs(x = "Time",
       y = "Amplitude",
       colour = NULL) +
  theme_bw() +
  theme(legend.position = "none",
        panel.grid.minor = element_blank(),
        strip.background = element_blank(),
        strip.text = element_text(face = "bold")) +
  facet_wrap(~id, ncol = 3, scales = "free_y")

print(p)

# Save plots

ggsave("output/time-series.png", p, units = "in", height = 8, width = 7)
ggsave("report/time-series.png", p, units = "in", height = 8, width = 7)
