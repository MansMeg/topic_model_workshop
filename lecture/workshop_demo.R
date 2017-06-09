## The multinomial distribution

p <- c(0.3, 0.1, 0.2, 0.4)
n <- 5
rmultinom(n = 1, size = n, prob = p)


## The Dirichlet distribution
# install.packages("MCMCpack")
library(MCMCpack)
library(ggplot2)

alpha <- 1 * c(3,5,2)
prob <- rdirichlet(1, alpha)
prob
ggplot(data = data.frame(prob=t(prob), category = 1:ncol(prob)), 
       aes(x = category, y = prob)) + geom_bar(stat = "identity")




## The Multinomial-Dirichlet distribution
# install.packages("MCMCpack")
library(MCMCpack)
library(ggplot2)

alpha <- 1 * c(1,1,1)
prob <- rdirichlet(1, alpha)
prob
rmultinom(n = 1, size = 1, prob = prob)



# The LDA model
vocabulary <- c("generation", "race", "Democratic", "nomination", "wide", "presidential", "buzz", "baron")
V <- length(vocabulary)
K <- 3
n_d <- c(13, 19, 5, 9)
D <- length(n_d)


Phi <- matrix(nrow = K, ncol = V)
colnames(Phi) <- vocabulary

beta <- rep(0.2, V)

# Step 1: Generate topics
for (k in 1:K){
  Phi[k,] <- rdirichlet(n = 1, alpha = beta)
}

# Lets look at the topics
k <- 3
ggplot(data = data.frame(prob=Phi[k,], category = colnames(Phi)), aes(x = category, y = prob)) + geom_bar(stat = "identity")


Theta <- matrix(nrow = D, ncol = K)
w <- list()
z <- list()

alpha <- rep(0.2, K)

# Step 2: Generate a document 
for (d in 1:D){
  w[[d]] <- character(n_d[d]); z[[d]] <- integer(n_d[d])
  Theta[d,] <- rdirichlet(n = 1, alpha = alpha)
  for(i in 1:n_d[d]){
    z[[d]][i] <- sample(x = 1:K, size = 1, prob = Theta[d,])
    w[[d]][i] <- sample(x = vocabulary, size = 1, prob = Phi[z[[d]][[i]],])
  }
}


