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

# Produce graphic

p <- amplifiers %>%
  ggplot(aes(x = timepoint, y = amplitude, colour = group)) +
  geom_line() +
  labs(title = "Time Series of Amplitude by Amplifier",
       x = "Time",
       y = "Amplitude",
       colour = NULL) +
  scale_colour_brewer(palette = "Dark2") +
  theme(legend.position = "none",
        axis.text.x = element_blank()) +
  facet_wrap(~id)

print(p)

# Produce graphic for random 1000 timepoints

p1 <- amplifiers %>%
  filter(timepoint >= 10000 & timepoint <= 11000) %>%
  ggplot(aes(x = timepoint, y = amplitude, colour = group)) +
  geom_line() +
  labs(title = "Time Series of Amplitude by Amplifier",
       x = "Time",
       y = "Amplitude",
       colour = NULL) +
  scale_colour_brewer(palette = "Dark2") +
  theme(legend.position = "none",
        axis.text.x = element_blank()) +
  facet_wrap(~id)

print(p1)

# Save plots

ggsave("output/time-series.png", p)
ggsave("output/time-series-random-1000.png", p1)
