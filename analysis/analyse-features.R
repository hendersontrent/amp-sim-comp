#-----------------------------------------
# This script sets out to analyse the time
# series features
#-----------------------------------------

#-----------------------------------------
# Author: Trent Henderson, 16 January 2026
#-----------------------------------------

# Load features

load("data/features/features.Rda")

# Filter to good features

data_id <- features
feature_list <- unique(data_id$names)

ids_to_keep <- data_id %>%
  reframe(counter = dplyr::n(), .by = "id") %>%
  filter(counter == length(feature_list))

ids_to_keep <- ids_to_keep$id

cor_dat <- data_id %>%
  filter(id %in% ids_to_keep) %>%
  pivot_wider(id_cols = "id", names_from = "names", values_from = "values") %>%
  dplyr::select(-c(id))

cor_dat <- Filter(function(x) sd(x, na.rm = TRUE) != 0, cor_dat)
good_features <- colnames(cor_dat)

features2 <- features %>%
  filter(names %in% good_features)

rm(data_id, ids_to_keep, cor_dat)

#------------------ Correlations ----------------

p <- plot(features2, type = "matrix", norm_method = "Sigmoid", unit_int = TRUE, clust_method = "average") +
  theme(axis.text.y = element_text(size = 6)) +
  labs(title = "Time series by feature matrix for a sample of guitar VSTs",
       y = "Amplifier",
       caption = "Feature values normalised using sigmoid transformation. Hierarchical clustering was used to structure rows and columns, with average clustering selected as the method.")

ggsave("output/feature-matrix.svg", p, units = "in", width = 11, height = 11)

#------------------ Low-dimensional projections ----------------

ld <- project(features,
              norm_method = "RobustSigmoid",
              unit_int = TRUE,
              low_dim_method = "PCA",
              seed = 123)

plot(ld)
