#' Produce a correlation matrix plot showing pairwise correlations of time series based on feature vectors with automatic hierarchical clustering
#' @importFrom rlang .data
#' @import dplyr
#' @import ggplot2
#' @importFrom tidyr pivot_wider
#' @importFrom reshape2 melt
#' @importFrom stats hclust
#' @importFrom stats dist
#' @importFrom stats cor
#' @param data a dataframewith at least 2 columns for \code{"id"} and \code{"values"} variables
#' @param clust_method the hierarchical clustering method to use for the pairwise correlation plot. Defaults to \code{"average"}
#' @param cor_method the correlation method to use. Defaults to \code{"pearson"}
#' @return an object of class \code{ggplot}
#' @author Trent Henderson
#'

plot_vector_corrs <- function(data, clust_method = c("average", "ward.D", "ward.D2", "single", "complete", "mcquitty", "median", "centroid"),
                              cor_method = c("pearson", "spearman")){

  #------------- Data reshaping -------------

  cor_dat <- data %>%
    tidyr::pivot_wider(id_cols = "names", names_from = "id", values_from = "values") %>%
    dplyr::select(-c(.data$names)) %>%
    tidyr::drop_na()

  #--------- Correlation ----------

  # Calculate correlations and take absolute

  result <- abs(stats::cor(cor_dat, method = cor_method))

  #--------- Clustering -----------

  # Wrangle into tidy format

  melted <- reshape2::melt(result)

  # Perform clustering

  row.order <- stats::hclust(stats::dist(result, method = "euclidean"), method = clust_method)$order # Hierarchical cluster on rows
  col.order <- stats::hclust(stats::dist(t(result), method = "euclidean"), method = clust_method)$order # Hierarchical cluster on columns
  dat_new <- result[row.order, col.order] # Re-order matrix by cluster outputs
  cluster_out <- reshape2::melt(as.matrix(dat_new)) # Turn into dataframe

  #--------- Graphic --------------

  # Define a nice colour palette consistent with RColorBrewer in other functions

  mypalette <- c("#B2182B", "#D6604D", "#F4A582", "#FDDBC7", "#D1E5F0", "#92C5DE", "#4393C3", "#2166AC")

  p <- cluster_out %>%
    ggplot2::ggplot(ggplot2::aes(x = .data$Var1, y = .data$Var2)) +
    ggplot2::geom_raster(ggplot2::aes(fill = .data$value)) +
    ggplot2::labs(x = "Time series",
                  y = "Time series",
                  fill = "Absolute correlation coefficient") +
    ggplot2::scale_fill_stepsn(n.breaks = 6, colours = rev(mypalette),
                               show.limits = TRUE) +
    ggplot2::theme_bw() +
    ggplot2::theme(panel.grid = ggplot2::element_blank(),
                   legend.position = "bottom") +
      ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))

  return(p)
}
