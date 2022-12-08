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
                     iter = 11000,
                     chains = 4,
                     warmup = 1000,
                     seed = 123)

  gmm_models[[i]] <- fit
}

# Save models so we don't have to re-fit each time we do analysis as they take a long time

save(gmm_models, "data/models/gmm_models.Rda")

#------------------ Output checks and results ----------------

#------------------
# Model comparisons
#------------------

# Grab log probabilities of each model

lps <- c()

for(i in 1:length(gmm_models)){
  lps <- append(lps, unique(extract(gmm_models[[i]])$lp__))
}

# Find the model with the highest log marginal likelihood to determine optimal k

best_model <- which.max(lps)

#--------------------
# Parameter estimates
#--------------------

# Density plots of the marginalised posteriors of the Gaussian mixture means

params <- extract(gmm_models[[3]]) # Substitute for correct k once we know it

#-----------------------------
# Predicted cluster membership
#-----------------------------

#
