#----------------------------------------
# This script sets out to produce a
# correlation matrix plot of the feature
# vectors
#
# NOTE: This script requires setup.R and
# analysis/catch22.R to have been run first
#----------------------------------------

#----------------------------------------
# Author: Trent Henderson, 27 August 2021
#----------------------------------------

# Load feature matrix

load("data/features/featMat_catch22.Rda")

# Draw plot

p <- plot_connectivity_matrix(featMat_catch22,
                         is_normalised = FALSE,
                         id_var = "id",
                         names_var = "names",
                         values_var = "values",
                         method = "z-score",
                         interactive = FALSE) +
  labs(title = "Pairwise correlation matrix of feature vectors") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        axis.text.y = element_text())

print(p)

# Save plot

ggsave("output/correlation-matrix.png", p, units = "in", height = 11, width = 11)
