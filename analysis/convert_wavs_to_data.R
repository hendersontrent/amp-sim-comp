#----------------------------------------
# This script sets out to load all the
# waveforms for each amplifier in and
# convert to a time-amplitude matrix
#
# NOTE: This script requires setup.R to
# have been run first
#----------------------------------------

#----------------------------------------
# Author: Trent Henderson, 24 August 2021
#----------------------------------------

# Run function and join metadata

amplifiers <- get_waveforms() %>%
  inner_join(metadata, by = c("id" = "id"))

save(amplifiers, file = "data/raw-signals-numeric/amplifiers.Rda")
