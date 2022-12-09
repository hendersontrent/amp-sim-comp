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

# Convert to matrix and scale values for numerical stability

wide_data <- as.matrix(wide_data)
wide_data <- scale(wide_data, center = TRUE, scale = TRUE)

#------------- Fit k-means models --------------

# Fit k-means models over the range of 1 <= k <= 9 as we are unsure what the "right" k is

kclusts <-
  tibble(k = 1:9) %>%
  mutate(
    kclust = map(k, ~ kmeans(wide_data, .x)),
    tidied = map(kclust, tidy),
    glanced = map(kclust, glance),
    augmented = map(kclust, augment, wide_data)
  )

#------------- Extract results --------------

# Extract separate results using tidy approach presented in https://www.tidymodels.org/learn/statistics/k-means/

clusters <- kclusts %>%
  unnest(cols = c(tidied))

assignments <- kclusts %>%
  unnest(cols = c(augmented))

clusterings <- kclusts %>%
  unnest(cols = c(glanced))

# Use elbow method over total within sums of squares (i.e., variance within clusters) to determine optimal k

p <- clusterings %>%
  mutate(props = betweenss / totss) %>%
  ggplot(aes(x = k, y = props)) +
  geom_line(size = 0.8) +
  geom_point(size = 2) +
  labs(x = "k",
       y = "Proportion of total SS explained by between cluster SS") +
  scale_x_continuous(limits = c(1, 9),
                     breaks = seq(from = 1, to = 9, by = 1),
                     labels = seq(from = 1, to = 9, by = 1)) +
  theme_bw() +
  theme(panel.grid.minor = element_blank())

print(p)
ggsave("output/k-elbow.png", p, units = "in", width = 6, height = 6)
ggsave("report/k-elbow.pdf", p, units = "in", width = 6, height = 6)

#------------- Determine cluster membership --------------

# k-means finds k = 6 as the best in terms of total within sums of squares, so we can apply labels to original data

k_labels <- assignments %>%
  filter(k == 6) %>%
  mutate(id = rownames(wide_data)) %>%
  inner_join(metadata, by = c("id" = "id"))

#------------- Produce summary graphics/numbers --------------

# Summary table of amplifiers

amp_list <- k_labels %>%
  dplyr::select(c(id, plugin, .cluster, amp_type)) %>%
  arrange(.cluster) %>%
  rename(`Amplifier Name` = id,
         Plugin = plugin,
         Cluster = .cluster,
         `Gain Structure` = amp_type)

xtable::xtable(amp_list) # For LaTeX report

# Low gain vs high gain per cluster

p1 <- k_labels %>%
  group_by(.cluster, amp_type) %>%
  summarise(num_amps = n()) %>%
  mutate(.cluster = paste0("Cluster ", .cluster)) %>%
  group_by(.cluster) %>%
  mutate(props = num_amps / sum(num_amps)) %>%
  ungroup() %>%
  ggplot(aes(x = amp_type, y = num_amps)) +
  geom_bar(stat = "identity") +
  labs(x = "Amplifier type",
       y = "Number of amplifiers") +
  theme_bw() +
  theme(panel.grid.minor = element_blank(),
        axis.text.x = element_text(angle = 90),
        strip.background = element_blank()) +
  facet_wrap(~ .cluster, ncol = 3, nrow = 2)

print(p1)
ggsave("output/k-gain.png", p1, units = "in", width = 6, height = 6)
ggsave("report/k-gain.pdf", p1, units = "in", width = 6, height = 6)

# Brand per cluster

brand <- k_labels %>%
  group_by(.cluster, brand) %>%
  summarise(num_amps = n()) %>%
  mutate(.cluster = paste0("Cluster ", .cluster)) %>%
  group_by(.cluster) %>%
  mutate(props = num_amps / sum(num_amps)) %>%
  ungroup()
