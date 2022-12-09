#' Draw loadings plot for first 2 PCs from PCA model
#' @importFrom tibble rownames_to_column
#' @import dplyr
#' @import ggplot2
#' @param pca the PCA model to extract information from
#' @return an object of class \code{ggplot2}
#' @author Trent Henderson
#'

plot_loadings <- function(pca){

  # Get loadings for PC1 and PC2

  pc1 <- data.frame(pca$rotation[, 1]) %>%
    rownames_to_column(var = "names") %>%
    rename(loading = 2) %>%
    mutate(pc = "PC1")

  pc2 <- data.frame(pca$rotation[, 2]) %>%
    rownames_to_column(var = "names") %>%
    rename(loading = 2) %>%
    mutate(pc = "PC2")

  pcs <- bind_rows(pc1, pc2) %>%
    mutate(flag = ifelse(loading < 0, "Negative", "Positive"))

  # Draw plot

  p <- pcs %>%
    ggplot(aes(x = names, y = loading, fill = flag)) +
    geom_bar(stat = "identity", alpha = 0.9) +
    labs(x = "Feature",
         y = "PC loading") +
    scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
    theme_bw() +
    theme(panel.grid.minor = element_blank(),
          legend.position = "none",
          axis.text.x = element_text(angle = 90),
          strip.background = element_blank()) +
    facet_wrap(~pc, ncol = 1, nrow = 2)

  return(p)
}
