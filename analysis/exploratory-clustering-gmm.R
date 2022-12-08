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

storage <- list()

# Use parallel processing

options(mc.cores = parallel::detectCores())

# Fit models for 1 <= k <= 9 as we are unsure what the "right" k is

for(i in 1:9){

  # Set up data for Stan

  stan_data <- list(N = nrow(X),
                    D = ncol(X),
                    K = i,
                    y = array(as.vector(X), dim = c(nrow(X), ncol(X))))

  # Run model

  fit <- rstan::stan(data = stan_data,
                     file = "stan/gmm.stan",
                     iter = 3000,
                     chains = 4,
                     seed = 123)

  storage[[i]] <- fit
}

#------------------ Output checks and results ----------------

# Compare models using log marginal likelihood to determine optimal k

lml1 <- rstan::extract(storage[[1]])$lml
lml2 <- rstan::extract(storage[[2]])$lml
lml3 <- rstan::extract(storage[[3]])$lml
lml4 <- rstan::extract(storage[[4]])$lml
lml5 <- rstan::extract(storage[[5]])$lml
lml6 <- rstan::extract(storage[[6]])$lml
lml7 <- rstan::extract(storage[[7]])$lml
lml8 <- rstan::extract(storage[[8]])$lml
lml9 <- rstan::extract(storage[[9]])$lml

# Find the model with the highest log marginal likelihood

best_model <- which.max(c(lml1, lml2, lml3, lml4, lml5, lml6, lml7, lml8, lml9))
