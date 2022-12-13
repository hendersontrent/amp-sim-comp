#------------------------------------------
# This script sets out to produce a simple
# spectral-based analysis of amplifiers
#
# NOTE: This script requires setup.R to
# have been run first
#------------------------------------------

#------------------------------------------
# Author: Trent Henderson, 13 December 2022
#------------------------------------------

# Load data

load("data/raw-signals-numeric/amplifiers.Rda")

# Get IDs to map over later

ids <- unique(amplifiers$id)

# Convert to data.table for efficiency

amplifiers <- data.table(amplifiers)
setkey(amplifiers, id)

#------------------- Calculate spectral density curves -------------------

#' Function to map over amplifiers and calculate spectral density
#' @param data the \code{data.table} of amplifier data
#' @param amp \code{string} specifying the amplifier id
#' @return \code{vector} object of class \code{numeric}
#' @author Trent Henderson
#'

calculate_spec_density <- function(data, amp){
  message(paste0("Calculating spectral density for: ", amp))
  tmp <- data[.(amp)]
  tmp <- tmp[order(timepoint)]
  tmp <- tmp[[1]]
  outs <- spectrum(tmp)
  outs <- data.frame(t(outs$spec))
  rownames(outs) <- amp
  return(outs)
}

# Run function for all amplifiers

spec_dens <- ids %>%
  purrr::map_dfr(~ calculate_spec_density(data = amplifiers, amp = .x))

#------------------- Calculate distance matrix -------------------

d <- dist(spec_dens, method = "euclidean")

#------------------- Project into lower 2-D space -------------------

# Classical metric MDS

fit <- cmdscale(d, eig = FALSE, k = 2)

# Draw plot

p <- as.data.frame(fit) %>%
  rownames_to_column(var = "id") %>%
  inner_join(metadata, by = c("id" = "id")) %>%
  mutate(keepers = case_when(
          id == "Neural DSP Tim Henson 1"            ~ id,
          id == "Neural DSP Tim Henson 2"            ~ id,
          id == "Neural DSP Petrucci 1"              ~ id,
          id == "Neural DSP Abasi 1"                 ~ id,
          id == "Neural DSP Plini 1"                 ~ id,
          id == "Neural DSP Gojira 3"                ~ id,
          id == "Neural DSP Rabea 1"                 ~ id,
          id == "Neural DSP Rabea 2_EL34"            ~ id,
          id == "Neural DSP Rabea 2_6L6"             ~ id,
          id == "Neural DSP Fortin Cali Clean"       ~ id,
          id == "STL Tonality Andy James 3_Lo"       ~ id,
          id == "STL Tonality Andy James 3_Hi"       ~ id,
          id == "STL Tonality Lasse Lammert 3"       ~ id,
          id == "STL Tonality Lasse Lammert 2"       ~ id,
          id == "STL Tonality Howard benson 2_Clean" ~ id,
          id == "STL Tonality Howard benson 2_Lead"  ~ id,
          TRUE                                       ~ "")) %>% # Visual inspection revealed these as outlying cases
  ggplot(aes(x = V1, y = V2)) +
  geom_point(aes(colour = plugin), size = 2.5) +
  geom_text_repel(aes(label = keepers, colour = plugin), size = 2.5, fontface = "bold", max.overlaps = Inf) +
  labs(x = "Coordinate 1",
       y = "Coordinate 2",
       colour = NULL) +
  theme_bw() +
  theme(legend.position = "bottom")

print(p)
ggsave("output/mds-spectral.png", p, units = "in", height = 11, width = 11)
ggsave("report/mds-spectral.pdf", p, units = "in", height = 11, width = 11)
