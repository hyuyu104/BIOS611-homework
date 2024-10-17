require(dplyr)

kkmeans <- function(data, k) {
  cluster_labels <- sample(1:k, nrow(data), replace = T)
  old_centroids <- NULL
  data <- as.data.frame(data)
  repeat {
    centroids <- data %>% 
      mutate(label = cluster_labels) %>%
      group_by(label) %>% arrange(label) %>%
      summarise_all(mean) %>%
      select(!label)
    if (!is.null(old_centroids)) {
      centroid_diff <- old_centroids - centroids
      cendiff <- mean(rowSums(centroid_diff*centroid_diff))
      if (cendiff < 1e-6) break;
    }
    old_centroids <- centroids
    dist_to_center <- function(i) {
      rr <- centroids %>% slice(i)
      df <- data %>% mutate(across(everything(), ~ (. - rr[[cur_column()]])^2))
      sqrt(rowSums(df))
    }
    min_dist <- cbind(sapply(1:k, dist_to_center)) %>% 
      as.data.frame() %>%
      rowwise() %>%
      mutate(label = which.min(c_across(everything())))
    cluster_labels <- min_dist$label
  }
  cluster_labels
}

n <- 100
centers <- tibble(C1 = c(5,0,0,0,0), C2 = c(-5,0,0,0,0), C3 = c(0,0,0,3,0), 
                  C4 = c(0,0,0,-2,0), C5 = c(4,0,0,-3,0))
true_label <- as.vector(t(replicate(n, 1:5)))
data_ls <- lapply(centers, function(y) sapply(y, function(x) rnorm(n, x)))
data <- as.data.frame(do.call(rbind, data_ls))
labels <- kkmeans(data, 5)


shannon <- function(sequence){
  tbl <- (table(sequence)/length(sequence)) %>% as.numeric();
  -sum(tbl*log2(tbl))
}

mutinf <- function(a,b){
  sa <- shannon(a);
  sb <- shannon(b);
  sab <- shannon(sprintf("%d:%d", a, b));
  sa + sb - sab;
}

normalized_mutinf <- function(a,b){
  2*mutinf(a,b)/(shannon(a)+shannon(b));
}

normalized_mutinf(labels, true_label)

require(ggplot2)
X <- data %>% as.matrix()
eigv <- eigen(t(X) %*% X, symmetric = T)$vectors[1:k,1:2]
X %*% eigv %>% as.data.frame() %>% rename(PC1 = V1, PC2 = V2) %>%
  mutate(label = as.character(labels)) %>%
  ggplot(aes(x = PC1, y = PC2, color = label)) + geom_point()

library(cluster)
for (r in seq(0, 2, length.out = 4)) {
  data_ls <- lapply(centers, function(y) sapply(y, function(x) rnorm(n, x*r)))
  data <- as.data.frame(do.call(rbind, data_ls))
  r <- clusGap(data %>% as.matrix(), function(data, k){
    kmeans(data, k)
  }, K.max = 10)
}
