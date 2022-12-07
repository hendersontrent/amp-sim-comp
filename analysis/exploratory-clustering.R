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
ggsave("output/k-elbow.png", p, units = "in", width = 6, height = 6)
ggsave("report/k-elbow.pdf", p, units = "in", width = 6, height = 6)

#------------- Determine cluster membership --------------

# k-means finds k = 2 as the best in terms of total within sums of squares, so we can apply labels to original data

k_labels <- assignments %>%
  filter(k == 2) %>%
  mutate(id = rownames(wide_data)) %>%
  mutate(group = ifelse(grepl("Neural", id), "Neural DSP", "STL Tonality")) %>%
  dplyr::select(c(id, group, .cluster))

# Add in some qualitative labels of amplifier type
# NOTE: We are using the following system of labelling:
#    - Acoustic/Other
#    - Clean
#    - Low Gain
#    - Mid Gain
#    - High Gain

k_labels <- k_labels %>%
  mutate(amp_type = case_when(
          id == "Neural DSP CoryWong 1"      ~ "Acoustic/Other",
          id == "Neural DSP CoryWong 2"      ~ "Clean",
          id == "Neural DSP CoryWong 3"      ~ "Low Gain",
          id == "Neural DSP Fortin Nameless" ~ "High Gain",
          id == "Neural DSP Gojira 1"        ~ "Clean",
          id == "Neural DSP Gojira 2"        ~ "High Gain",
          id == "Neural DSP Gojira 3"        ~ "High Gain",
          id == "Neural DSP Nolly 1"         ~ "Clean", # Crunch
          id == "Neural DSP Nolly 2"         ~ "Mid Gain", # Crunch
          id == "Neural DSP Nolly 3"         ~ "High Gain", # Rhythm
          id == "Neural DSP Nolly 4"         ~ "High Gain", # Lead
          id == "Neural DSP Plini 1"         ~ "Clean",
          id == "Neural DSP Plini 2"         ~ "Mid Gain",
          id == "Neural DSP Plini 3"         ~ "High Gain",
          id == "Neural DSP TimHenson 1"     ~ "Acoustic/Other",
          id == "Neural DSP TimHenson 2"     ~ "Low Gain",
          id == "Neural DSP TimHenson 3"     ~ "Mid Gain",
          id == "STL Tonality 1_6L6"         ~ "High Gain",
          id == "STL Tonality 1_EL34"        ~ "High Gain",
          id == "STL Tonality 1_KT88"        ~ "High Gain",
          id == "STL Tonality 2_6L6"         ~ "High Gain",
          id == "STL Tonality 2_EL34"        ~ "High Gain",
          id == "STL Tonality 2_KT88"        ~ "High Gain",
          id == "STL Tonality 3_6L6"         ~ "High Gain",
          id == "STL Tonality 3_EL34"        ~ "High Gain",
          id == "STL Tonality 3_KT88"        ~ "High Gain",
          id == "STL Tonality 4_6L6"         ~ "High Gain",
          id == "STL Tonality 4_EL34"        ~ "Mid Gain",
          id == "STL Tonality 4_KT77"        ~ "Mid Gain",
          id == "STL Tonality 4_KT88"        ~ "Mid Gain"))

#------------- Produce summary graphics/numbers --------------

# Low gain vs high gain per cluster

p1 <- k_labels %>%
  group_by(.cluster, amp_type) %>%
  summarise(num_amps = n()) %>%
  mutate(.cluster = ifelse(.cluster == 1, "Cluster 1", "Cluster 2")) %>%
  group_by(.cluster) %>%
  mutate(props = num_amps / sum(num_amps)) %>%
  ungroup() %>%
  ggplot(aes(x = amp_type, y = num_amps)) +
  geom_bar(stat = "identity") +
  labs(x = "Amplifier Type",
       y = "Number of Amplifiers") +
  theme_bw() +
  theme(panel.grid.minor = element_blank(),
        axis.text.x = element_text(angle = 90),
        strip.background = element_blank()) +
  facet_wrap(~ .cluster, ncol = 2, nrow = 1)

print(p1)
ggsave("output/k-gain.png", p1, units = "in", width = 6, height = 6)
ggsave("report/k-gain.pdf", p1, units = "in", width = 6, height = 6)

# Brand per cluster

brand <- k_labels %>%
  group_by(.cluster, group) %>%
  summarise(num_amps = n()) %>%
  mutate(.cluster = ifelse(.cluster == 1, "Cluster 1", "Cluster 2")) %>%
  group_by(.cluster) %>%
  mutate(props = num_amps / sum(num_amps)) %>%
  ungroup()
