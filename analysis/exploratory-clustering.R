#-----------------------------------------
# This script sets out to produce an
# exploratory cluster analysis of the
# amplifiers based on their feature values
#
# NOTE: This script requires setup.R and
# analysis/catch22.R to have been run
# first
#-----------------------------------------

#-----------------------------------------
# Author: Trent Henderson, 7 December 2022
#-----------------------------------------

# Load feature matrix

load("data/features/feat_mat.Rda")

# Make dataframe into wide numerical matrix

wide_data <- feat_mat %>%
  dplyr::select(c(id, names, values)) %>%
  pivot_wider(id_cols = "id", names_from = "names", values_from = "values") %>%
  column_to_rownames(var = "id")

#------------- k-means modelling --------------

# Fit k-means models over the range of 1 <= k <= 9

kclusts <-
  tibble(k = 1:9) %>%
  mutate(
    kclust = map(k, ~ kmeans(wide_data, .x)),
    tidied = map(kclust, tidy),
    glanced = map(kclust, glance),
    augmented = map(kclust, augment, wide_data)
  )

#------------- Extracting results --------------

# Extract separate results using tidy approach presented in https://www.tidymodels.org/learn/statistics/k-means/

clusters <- kclusts %>%
  unnest(cols = c(tidied))

assignments <- kclusts %>%
  unnest(cols = c(augmented))

clusterings <- kclusts %>%
  unnest(cols = c(glanced))

# Use elbow method over total within sums of squares (i.e., variance within clusters) to determine optimal k

p <- clusterings %>%
  ggplot(aes(x = k, y = tot.withinss)) +
  geom_line(size = 0.8) +
  geom_point(size = 2) +
  labs(x = "k",
       y = "Total within sums-of-squares") +
  scale_x_continuous(limits = c(1, 9),
                     breaks = seq(from = 1, to = 9, by = 1),
                     labels = seq(from = 1, to = 9, by = 1)) +
  theme_bw() +
  theme(panel.grid.minor = element_blank())

print(p)

#------------- Determining cluster membership --------------

# k-means finds k = 2 as the best in terms of total within sums of squares, so we can apply labels to original data

k_labels <- assignments %>%
  filter(k == 2) %>%
  mutate(id = rownames(wide_data)) %>%
  mutate(group = ifelse(grepl("Neural", id), "Neural DSP", "STL Tonality")) %>%
  dplyr::select(c(id, group, .cluster))
