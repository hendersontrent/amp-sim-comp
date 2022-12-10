#------------------------------------------
# This script sets out to calculate time
# series features
#
# NOTE: This script requires setup.R to
# have been run first
#------------------------------------------

#------------------------------------------
# Author: Trent Henderson, 10 December 2022
#------------------------------------------

# Load data

load("data/raw-signals-numeric/amplifiers.Rda")

# Get IDs to map over later

ids <- unique(amplifiers$id)

# Convert to data.table for efficiency

amplifiers <- data.table(amplifiers)
setkey(amplifiers, id)

#---------------- Feature calculations ---------------

#' Function to map over amplifiers and calculate catch22 features
#' @param data the \code{data.table} of amplifier data
#' @param amp \code{string} specifying the amplifier id
#' @return object of class \code{data.frame}
#' @author Trent Henderson
#'

calculate_amp_features <- function(data, amp){

  message(paste0("Calculating features for: ", amp))

  # Filter data.table to amp of interest

  tmp <- data[.(amp)]

  # Arrange in time order and calculate features

  tmp <- tmp[order(timepoint)]
  tmp <- tmp[[1]]
  outs <- Rcatch22::catch22_all(tmp, catch24 = TRUE)

  outs <- outs %>%
    mutate(id = amp)

  return(outs)
}

# Run function for all amplifiers

feat_mat <- ids %>%
  purrr::map_dfr(~ calculate_amp_features(data = amplifiers, amp = .x))

# Join in metadata

feat_mat <- feat_mat %>%
  inner_join(metadata, by = c("id" = "id"))

# Save output

save(feat_mat, file = "data/features/feat_mat.Rda")
