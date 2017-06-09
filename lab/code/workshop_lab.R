
# Installera de paket som behövs i R för att analysera
install.packages("devtools")
install.packages("tidytext")
install.packages("dplyr")
install.packages("stringr")
devtools::install_github("MansMeg/RMallet")

# Läsa in paket
library(dplyr)
library(stringr)
library(tidytext)

# Läsa in data
crps <- read.csv("lab/data/pld20102016.csv", stringsAsFactors = FALSE)
crps <- as_data_frame(crps)
crps

stops <- read.csv("lab/data/stoppord.csv", stringsAsFactors = FALSE, fileEncoding = "UTF-8", encoding = "UTF-8")
# Encodingen är viktig för att matcha textsträngar längre ned.
stops <- as_data_frame(stops)
stops

# Titta på data
View(crps)

# Bearbeta data

## Använder REGEXP för att städa lite
## Gör om allt till gemener
crps$text <- tolower(crps$text)
## Ersätt \n (ny rad) med mellanslag
crps$text <- str_replace_all(crps$text, "\n", " ") 
## Ersätt \n (ny rad) med mellanslag
crps$text <- str_replace_all(crps$text, "\n", " ")   
## Ersätt punkter med mellanslag
crps$text <- str_replace_all(crps$text, "[:punct:]", " ")
## Ta bort onödiga mellanslag
crps$text <- str_replace_all(crps$text, " +", " ")
crps$text <- str_trim(crps$text)

# Använda tidy text för att skapa ett tidy corpus med dplyr
tidy_crps <- crps %>% 
  unnest_tokens(token, text) %>%
  mutate(pos = row_number())
nrow(tidy_crps)

# Stoppord
tidy_crps <- tidy_crps %>% anti_join(stops)
nrow(tidy_crps)

# Ovanliga ord
word_freq <- tidy_crps %>% count(token, sort = TRUE)
nrow(word_freq)

word_freq_rare <- word_freq %>% filter(n <= 5)
nrow(word_freq_rare)

tidy_crps <- tidy_crps %>% anti_join(word_freq_rare)
nrow(tidy_crps)

# Ta bort konstigheter
tidy_crps <- tidy_crps %>% anti_join(data_frame(token = "p"))
nrow(tidy_crps)


# Återställa texten (men hamnar i oordning)
crps_clean <- tidy_crps %>%
  arrange(pos) %>%
  group_by(anforande_id) %>% 
  summarise(clean_text = paste0(token, collapse = " ")) %>%
  left_join(crps)

# Använda Mallet för att skatta modellen
library(mallet)

# Skapa vår modell
topic_model <- MalletLDA(num.topics=20, alpha.sum = 2, beta = 0.1)

# Lägg till data till modellen
mallet_data <- 
  mallet.import(id.array = crps_clean$anforande_id, 
                text.array = crps_clean$text, 
                token.regexp = "[\\p{L}0-9]+") # Definition av en token.

topic_model$loadDocuments(mallet_data)

# Träna en model med 500 MCMC-iterationer
topic_model$train(500)


# Analysera resultatet
# Analysera topics
Phi <- mallet.topic.words(topic_model, smoothed=TRUE, normalized=TRUE)
dim(Phi)

# Topic att analysera/titta på top p(w|k)
k <- 6
mallet.top.words(topic_model, word.weights = phi[k,], num.top.words = 20)

# Analysera dokument
Theta <- mallet.doc.topics(topic_model, smoothed=TRUE, normalized=TRUE)
dim(Theta)

# Visualisera hur ofta ett topic används
hist(theta[, k])
doc_idx <- which(theta[, k] > 0.2)

# Låt oss titta på dessa dokument
crps_clean[doc_idx[1],]$text
crps_clean[doc_idx[2],]$text

# Analysera detta topic efter andra variabler
topic_indicators_by_doc <- 
  mallet.doc.topics(topic_model, smoothed=FALSE, normalized=FALSE)

crps_clean$topic_counts <- topic_indicators_by_doc[,k]

# Aggregera upp antalet ord i topic k efter olika variabler
by_time <- crps_clean %>% group_by(dok_rm) %>% summarise(n = sum(topic_counts))

by_party <- crps_clean %>% group_by(parti) %>% summarise(n = sum(topic_counts))

by_talare <- crps_clean %>% group_by(talare) %>% summarise(n = sum(topic_counts)) %>% arrange(desc(n))

