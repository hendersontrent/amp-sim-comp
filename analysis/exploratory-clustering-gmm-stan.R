#-----------------------------------------
# This script sets out to produce a
# probabilistic clustering model of the
# amplifiers based on the feature matrix
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

X <- feat_mat %>%
  dplyr::select(c(id, names, values)) %>%
  pivot_wider(id_cols = "id", names_from = "names", values_from = "values") %>%
  column_to_rownames(var = "id")

# Convert to matrix and scale values for numerical stability in Stan

X <- as.matrix(X)
X <- scale(X, center = TRUE, scale = TRUE)

#------------------ Gaussian mixture modelling ----------------

gmm_models <- list()

# Use parallel processing

options(mc.cores = parallel::detectCores())

# Fit models for 1 <= k <= 5 as we are unsure what the "right" k is

for(i in 1:5){

  # Set up data for Stan

  stan_data <- list(N = nrow(X),
                    D = ncol(X),
                    K = i,
                    y = array(as.vector(X), dim = c(nrow(X), ncol(X))))

  # Run model

  fit <- rstan::stan(data = stan_data,
                     file = "stan/gmm.stan",
                     iter = 15000,
                     chains = 4,
                     seed = 123,
                     control = list(max_treedepth = 15))

  gmm_models[[i]] <- fit
}

# Save models so we don't have to re-fit each time we do analysis as they take a long time

save(gmm_models, file = "data/models/gmm_models.Rda")

#------------------ Output checks and results ----------------

#------------------
# Model comparisons
#------------------

# Choose the model with the smallest Deviance Information Criterion (DIC) --- -2 * mean(log predictive density) + 2 * var(log predictive density)

dic <- c()

for(i in 1:length(gmm_models)){
  lpd <- extract(gmm_models[[i]])$log_predictive_density # Extract log predictive density
  mean_lpd <- mean(lpd1) # Compute mean of LPD
  var_lpd <- var(lpd1) # Compute variance of LPD
  dic1 <- -2 * mean_lpd + 2 * var_lpd # Compute DIC
  dic <- append(dic, dic1)
}

# Find the model with the highest mean LOO log predictive density to determine optimal k

best_model <- which.max(dic)

# Check output of best model

print(gmm_models[[best_model]])

#-------------------------------------------
# Predicted cluster membership of best model
#-------------------------------------------

preds <- extract(gmm_models[[best_model]])$y_pred
colnames(preds) <- rownames(X)

preds <- as.data.frame(preds) %>%
  mutate(iteration = row_number()) %>%
  pivot_longer(cols = !iteration, names_to = "id", values_to = "cluster")
