# First, clear the work space and reset R
rm(list = ls())

# Install packages first (run these one at a time)

# Reddit Extractor: Package for collecting data from Reddit
# Used for accessing Reddit's API and downloading posts and comments
install.packages("RedditExtractoR")

# syuzhet: Package for sentiment analysis
# Implements multiple sentiment analysis methods including syuzhet, bing, afinn, and nrc
# Used to determine emotional content and sentiment scores of text
install.packages("syuzhet")

# tm (Text Mining): Core package for text mining operations
# Provides functions for text preprocessing, cleaning, and analysis
# Includes tools for creating document term matrices and corpus management
install.packages("tm")

# wordcloud: Package for creating word cloud visualizations
# Generates visual representations of word frequencies in the data
# Helps identify most common terms and themes
install.packages("wordcloud")

# ggplot2: Advanced data visualization package
# Part of the tidyverse, used for creating professional plots and graphs
# Will be used for sentiment distribution and trend visualizations
install.packages("ggplot2")

# dplyr: Data manipulation package
# Provides functions for data transformation and summarization
# Used for filtering, sorting, and aggregating our analysis results
install.packages("dplyr")

# gridExtra: Extension for ggplot2
# Allows arrangement of multiple plots in a grid layout
# Useful for creating combined visualization panels
install.packages("gridExtra")

# tidyr: Data tidying package
# Helps in restructuring and cleaning data
# Used for reshaping data between wide and long formats
install.packages("tidyr")

# RColorBrewer: Color palette package
# Provides color schemes for data visualization
# Used to enhance the visual appeal of plots and graphs
install.packages("RColorBrewer")

# Load all required libraries
library(RedditExtractoR)
library(syuzhet)
library(tm)
library(wordcloud)
library(ggplot2)
library(dplyr)
library(gridExtra)
library(tidyr)
library(RColorBrewer)

# Test function - Run this first to verify everything works
test_reddit <- function() {
  urls <- find_thread_urls(keywords = "netflix", period = "month")
  print(paste("Found", nrow(urls), "URLs"))
  return(urls)
}

# Run test
test_results <- test_reddit()

#================ 1. DATA COLLECTION ================
collect_reddit_data <- function(company_name, num_posts = 1000) {
  urls <- find_thread_urls(keywords = company_name, period = "month")
  print(paste("Found", nrow(urls), "URLs"))
  
  post_count <- min(num_posts, nrow(urls))
  content <- get_thread_content(urls$url[1:post_count])
  
  comments_df <- content$comments
  comments_df$company <- company_name
  
  return(comments_df)
}

#================ 2. TEXT MINING ================
perform_text_mining <- function(data) {
  corpus <- Corpus(VectorSource(data$comment))
  corpus <- tm_map(corpus, content_transformer(tolower))
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, removeNumbers)
  corpus <- tm_map(corpus, removeWords, stopwords("english"))
  corpus <- tm_map(corpus, stripWhitespace)
  
  dtm <- DocumentTermMatrix(corpus)
  freq <- colSums(as.matrix(dtm))
  freq <- sort(freq, decreasing = TRUE)
  
  associations <- findAssocs(dtm, terms = names(freq)[1:5], corlimit = 0.2)
  
  return(list(corpus = corpus,
              dtm = dtm,
              word_freq = freq,
              associations = associations))
}

#================ 3. SENTIMENT ANALYSIS ================
analyze_sentiment <- function(data) {
  data$syuzhet_sent <- get_sentiment(data$comment, method = "syuzhet")
  data$afinn_sent <- get_sentiment(data$comment, method = "afinn")
  data$bing_sent <- get_sentiment(data$comment, method = "bing")
  
  emotions <- get_nrc_sentiment(data$comment)
  data <- cbind(data, emotions)
  
  data$avg_sentiment <- rowMeans(data[, c("syuzhet_sent", "afinn_sent", "bing_sent")])
  
  return(data)
}

#================ 4. VISUALIZATION ================
create_visualizations <- function(text_results, sentiment_data, company_name) {
  # Word Cloud
  png(paste0(company_name, "_wordcloud.png"), width = 800, height = 600)
  wordcloud(words = names(text_results$word_freq),
            freq = text_results$word_freq,
            max.words = 100,
            colors = brewer.pal(8, "Dark2"))
  dev.off()
  
  # Sentiment Distribution
  sent_dist <- ggplot(sentiment_data, aes(x = avg_sentiment)) +
    geom_histogram(fill = "skyblue", bins = 30) +
    theme_minimal() +
    labs(title = paste("Sentiment Distribution for", company_name),
         x = "Sentiment Score",
         y = "Count")
  ggsave(paste0(company_name, "_sentiment_dist.png"), sent_dist)
  
  # Emotion Distribution
  # Modified this part to use pivot_longer instead of gather
  emotion_data <- sentiment_data %>%
    select(anger:trust) %>%
    summarise(across(everything(), mean)) %>%
    pivot_longer(everything(), names_to = "emotion", values_to = "value")
  
  emotion_plot <- ggplot(emotion_data, 
                         aes(x = reorder(emotion, -value), y = value)) +
    geom_bar(stat = "identity", fill = "lightgreen") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    labs(title = paste("Emotional Content in", company_name, "Comments"),
         x = "Emotion",
         y = "Average Score")
  ggsave(paste0(company_name, "_emotions.png"), emotion_plot)
  
  return(list(sentiment_dist = sent_dist,
              emotion_plot = emotion_plot))
}

#================ 5. ANALYSIS SUMMARY ================
generate_summary <- function(data, text_results) {
  summary_stats <- list(
    total_comments = nrow(data),
    avg_sentiment = mean(data$avg_sentiment),
    positive_percent = mean(data$avg_sentiment > 0) * 100,
    negative_percent = mean(data$avg_sentiment < 0) * 100,
    neutral_percent = mean(data$avg_sentiment == 0) * 100,
    top_words = head(text_results$word_freq, 10),
    dominant_emotion = names(which.max(colMeans(data[, c("anger", "anticipation", 
                                                         "disgust", "fear", "joy",
                                                         "sadness", "surprise", 
                                                         "trust")])))
  )
  return(summary_stats)
}

#================ 6. MAIN ANALYSIS FUNCTION ================
run_social_media_analysis <- function(company_name, num_posts = 1000) {
  print("Starting analysis...")
  
  data <- collect_reddit_data(company_name, num_posts)
  print(paste("Collected", nrow(data), "comments"))
  
  text_results <- perform_text_mining(data)
  print("Text mining complete")
  
  sentiment_data <- analyze_sentiment(data)
  print("Sentiment analysis complete")
  
  visualizations <- create_visualizations(text_results, sentiment_data, company_name)
  print("Visualizations created")
  
  summary <- generate_summary(sentiment_data, text_results)
  print("Summary generated")
  
  write.csv(sentiment_data, 
            paste0(company_name, "_analyzed_data.csv"), 
            row.names = FALSE)
  
  return(list(raw_data = sentiment_data,
              text_analysis = text_results,
              summary = summary,
              visualizations = visualizations))
}

# Run the analysis (start with a small number first to test)
results <- run_social_media_analysis("apple", 100)

# Print summary
print("=== Analysis Summary ===")
print(paste("Total Comments:", results$summary$total_comments))
print(paste("Average Sentiment:", round(results$summary$avg_sentiment, 3)))
print(paste("Positive Comments:", round(results$summary$positive_percent, 1), "%"))
print(paste("Negative Comments:", round(results$summary$negative_percent, 1), "%"))
print(paste("Dominant Emotion:", results$summary$dominant_emotion))
print("\nTop 10 Most Frequent Words:")
print(results$summary$top_words)
