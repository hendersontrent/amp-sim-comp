//
// This script defines a Stan program to compute a Gaussian mixture model with class predictions
// and log marginal likelihood for model comparisons
//

//
// Author: Trent Henderson, 8 December 2022 with strong guidance from
// https://maggielieu.com/2017/03/21/multivariate-gaussian-mixture-model-done-properly/
//

data {
 int D; // Number of dimensions/variables
 int K; // Number of Gaussians/classes
 int N; // Number of datapoints
 vector[D] y[N]; // Data matrix
}

parameters {
 simplex[K] theta; // Mixing proportions
 ordered[D] mu[K]; // Mixture component means
 cholesky_factor_corr[D] L[K]; // Cholesky factor of covariance
}

model {
 real ps[K];

 for(k in 1:K){
   mu[k] ~ normal(0,3);
   L[k] ~ lkj_corr_cholesky(4);
 }

 for (n in 1:N){
   for (k in 1:K){
     ps[k] = log(theta[k]) + multi_normal_cholesky_lpdf(y[n] | mu[k], L[k]); // Increment log probability of the gaussian
   }
   target += log_sum_exp(ps);
 }
}

generated quantities {

  // Sample from the posterior distribution of mixture component assignments for each data point

  int<lower=1,upper=K> z[N];
  for (n in 1:N) {
    z[n] = categorical_rng(theta);
  }

  // Compute predicted classes for each data point

  int<lower=1,upper=K> y_pred[N];
  for (n in 1:N) {
    y_pred[n] = z[n];
  }
}
