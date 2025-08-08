# 🎯 Reddit Sentiment Analysis Project

<div align="center">

![R](https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white)
![Reddit](https://img.shields.io/badge/Reddit-FF4500?style=for-the-badge&logo=reddit&logoColor=white)
![Data Science](https://img.shields.io/badge/Data_Science-FF6B6B?style=for-the-badge&logo=datascience&logoColor=white)
![Sentiment Analysis](https://img.shields.io/badge/Sentiment_Analysis-00D4AA?style=for-the-badge&logo=python&logoColor=white)

**Advanced sentiment analysis tool for Reddit data using R**  
*Extract, analyze, and visualize public sentiment from Reddit comments and posts*

[![GitHub stars](https://img.shields.io/github/stars/Basanth08/Sentimental_Analysis?style=social)](https://github.com/Basanth08/Sentimental_Analysis)
[![GitHub forks](https://img.shields.io/github/forks/Basanth08/Sentimental_Analysis?style=social)](https://github.com/Basanth08/Sentimental_Analysis)
[![GitHub issues](https://img.shields.io/github/issues/Basanth08/Sentimental_Analysis)](https://github.com/Basanth08/Sentimental_Analysis/issues)
[![GitHub license](https://img.shields.io/github/license/Basanth08/Sentimental_Analysis)](https://github.com/Basanth08/Sentimental_Analysis/blob/main/LICENSE)

</div>

---

## 📋 Table of Contents

1. [Project Overview](#-project-overview)
2. [Architecture & Components](#-architecture--components)
3. [Installation & Setup](#️-installation--setup)
4. [Quick Start Guide](#-quick-start-guide)
5. [Data Pipeline](#-data-pipeline)
6. [Sentiment Analysis Algorithms](#-sentiment-analysis-algorithms)
7. [Visualization Methods](#-visualization-methods)
8. [Performance & Scalability](#-performance--scalability)
9. [Use Cases & Applications](#-use-cases--applications)
10. [Data Schema](#-data-schema)
11. [Troubleshooting](#-troubleshooting)
12. [Contributing](#-contributing)
13. [Contact & Support](#-contact--support)

---

## 📊 Project Overview

This project performs **comprehensive sentiment analysis** on Reddit data to understand public opinion and emotional responses. It collects data from Reddit threads, processes the text using advanced NLP techniques, and provides detailed sentiment analysis using multiple algorithms.

### 🎯 Key Features

- 🔍 **Automated Reddit Data Collection** - Extract posts and comments based on keywords
- 📈 **Multi-Algorithm Sentiment Analysis** - syuzhet, AFINN, and Bing methods
- 🎨 **Advanced Visualizations** - Word clouds, sentiment distributions, emotion analysis
- 📊 **Comprehensive Analytics** - Detailed statistics and insights
- 🚀 **Modular Design** - Easy customization and extension
- ⚡ **Scalable Processing** - Handle large datasets efficiently

## 🏗️ Architecture & Components

The project follows a modular architecture with distinct phases:

```
Data Collection → Text Processing → Sentiment Analysis → Visualization → Reporting
```

### Core Components

1. **Data Collection Module** (`collect_reddit_data`)
   - Reddit API integration via RedditExtractoR
   - Keyword-based search functionality
   - Configurable time periods and post limits

2. **Text Processing Module** (`perform_text_mining`)
   - Text cleaning and normalization
   - Stop word removal
   - Document-term matrix creation

3. **Sentiment Analysis Module** (`analyze_sentiment`)
   - Multi-algorithm sentiment scoring
   - Emotion classification
   - Aggregated sentiment metrics

4. **Visualization Module** (`create_visualizations`)
   - Word cloud generation
   - Sentiment distribution plots
   - Emotion analysis charts

## 📁 Project Structure

```
Sentimental_Analysis/
├── 📄 SentimentalAnalysis.R          # Main analysis script
├── 📊 apple_analyzed_data.csv        # Analyzed Reddit data (27,200+ comments)
├── 📋 README.md                      # Project documentation
└── 📄 Sentimental_Analysis_bv8946.pdf # Project report
```

## 🛠️ Installation & Setup

### Prerequisites

- **R** (version 3.6 or higher)
- **RStudio** (recommended for better experience)

### Required R Packages

```r
# Core packages for sentiment analysis
install.packages("RedditExtractoR")  # Reddit data extraction
install.packages("syuzhet")          # Sentiment analysis
install.packages("tm")               # Text mining
install.packages("wordcloud")        # Word cloud visualization

# Data manipulation and visualization
install.packages("ggplot2")          # Advanced plotting
install.packages("dplyr")            # Data manipulation
install.packages("gridExtra")        # Plot arrangement
install.packages("tidyr")            # Data tidying
install.packages("RColorBrewer")     # Color palettes
```

## 🚀 Quick Start Guide

### 1. Clone the Repository

```bash
git clone https://github.com/Basanth08/Sentimental_Analysis.git
cd Sentimental_Analysis
```

### 2. Load the Script

```r
# Source the main analysis script
source("SentimentalAnalysis.R")
```

### 3. Run a Quick Test

```r
# Test the Reddit data collection
test_results <- test_reddit()
```

### 4. Analyze Company Sentiment

```r
# Analyze sentiment for a specific company (e.g., Apple)
results <- run_social_media_analysis("apple", 100)
```

## 🔄 Data Pipeline

### Phase 1: Data Collection

```r
collect_reddit_data <- function(company_name, num_posts = 1000) {
  # 1. Search for relevant threads
  urls <- find_thread_urls(keywords = company_name, period = "month")
  
  # 2. Extract content from threads
  content <- get_thread_content(urls$url[1:post_count])
  
  # 3. Process and structure data
  comments_df <- content$comments
  comments_df$company <- company_name
  
  return(comments_df)
}
```

**Key Features:**
- Configurable search parameters
- Automatic pagination handling
- Error handling for API limits

### Phase 2: Text Processing

```r
perform_text_mining <- function(data) {
  # 1. Create corpus
  corpus <- Corpus(VectorSource(data$comment))
  
  # 2. Text cleaning pipeline
  corpus <- tm_map(corpus, content_transformer(tolower))
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, removeNumbers)
  corpus <- tm_map(corpus, removeWords, stopwords("english"))
  corpus <- tm_map(corpus, stripWhitespace)
  
  # 3. Create document-term matrix
  dtm <- DocumentTermMatrix(corpus)
  
  return(list(corpus = corpus, dtm = dtm, word_freq = freq))
}
```

**Processing Steps:**
1. **Lowercase conversion** - Standardize text case
2. **Punctuation removal** - Clean special characters
3. **Number removal** - Focus on textual content
4. **Stop word removal** - Remove common words
5. **Whitespace normalization** - Clean spacing

## 📊 Sentiment Analysis Algorithms

### 1. Syuzhet Method

**Algorithm:** Lexicon-based sentiment analysis using the syuzhet lexicon
**Score Range:** Continuous values (typically -1 to 1)
**Advantages:** Context-aware, handles negation

```r
data$syuzhet_sent <- get_sentiment(data$comment, method = "syuzhet")
```

### 2. AFINN Method

**Algorithm:** Finnish sentiment lexicon approach
**Score Range:** -5 to +5
**Advantages:** Fine-grained scoring, well-validated

```r
data$afinn_sent <- get_sentiment(data$comment, method = "afinn")
```

### 3. Bing Method

**Algorithm:** Binary sentiment classification
**Score Range:** -1, 0, +1
**Advantages:** Simple, fast, clear classification

```r
data$bing_sent <- get_sentiment(data$comment, method = "bing")
```

### 4. NRC Emotion Lexicon

**Algorithm:** 8-category emotion classification
**Categories:** anger, anticipation, disgust, fear, joy, sadness, surprise, trust
**Output:** Binary scores for each emotion

```r
emotions <- get_nrc_sentiment(data$comment)
data <- cbind(data, emotions)
```

## 🎨 Visualization Methods

### Word Cloud Generation

```r
wordcloud(words = names(text_results$word_freq),
          freq = text_results$word_freq,
          max.words = 100,
          colors = brewer.pal(8, "Dark2"))
```

**Parameters:**
- `max.words`: Maximum number of words to display
- `colors`: Color palette for visualization
- `freq`: Word frequency data

### Sentiment Distribution

```r
sent_dist <- ggplot(sentiment_data, aes(x = avg_sentiment)) +
  geom_histogram(fill = "skyblue", bins = 30) +
  theme_minimal() +
  labs(title = paste("Sentiment Distribution for", company_name),
       x = "Sentiment Score",
       y = "Count")
```

### Emotion Analysis

```r
emotion_data <- sentiment_data %>%
  select(anger:trust) %>%
  summarise(across(everything(), mean)) %>%
  pivot_longer(everything(), names_to = "emotion", values_to = "value")

emotion_plot <- ggplot(emotion_data, 
                       aes(x = reorder(emotion, -value), y = value)) +
  geom_bar(stat = "identity", fill = "lightgreen") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
```

## ⚡ Performance & Scalability

### Memory Management

1. **Corpus Size Limits**
   - Monitor memory usage for large datasets
   - Consider batch processing for very large collections

2. **Text Processing Optimization**
   - Use efficient text cleaning pipelines
   - Implement caching for repeated operations

### Processing Time

**Typical Performance Metrics:**
- **Data Collection:** 1-5 minutes per 1000 posts
- **Text Processing:** 30-60 seconds per 1000 comments
- **Sentiment Analysis:** 1-2 minutes per 1000 comments
- **Visualization:** 10-30 seconds per plot

### Scalability

**Recommended Limits:**
- **Single Analysis:** Up to 10,000 comments
- **Batch Processing:** Up to 50,000 comments
- **Memory Usage:** 2-4 GB RAM for large datasets

## 📈 Sample Results

### Sentiment Distribution
The analysis provides comprehensive sentiment scores across multiple dimensions:

| Metric | Value |
|--------|-------|
| Total Comments | 27,200+ |
| Average Sentiment | Calculated per analysis |
| Positive Comments | Percentage breakdown |
| Negative Comments | Percentage breakdown |
| Dominant Emotion | Most common emotion |

### Key Insights
- **Real-time Analysis** - Current public sentiment trends
- **Emotional Mapping** - 8 emotion categories (anger, joy, trust, etc.)
- **Word Frequency** - Most discussed topics and terms
- **Sentiment Trends** - Temporal sentiment patterns

## 🎯 Use Cases & Applications

### Business Intelligence
- **Brand Monitoring** - Track public sentiment about companies
- **Product Feedback** - Analyze user opinions and reviews
- **Market Research** - Understand consumer preferences

### Research Applications
- **Social Media Analysis** - Study online discourse patterns
- **Public Opinion Research** - Gauge public sentiment on topics
- **Academic Research** - Data for social science studies

## 📊 Data Schema

The analyzed data includes:

| Column | Description |
|--------|-------------|
| `url` | Reddit post URL |
| `author` | Comment author |
| `date` | Comment date |
| `comment` | Comment text |
| `syuzhet_sent` | Syuzhet sentiment score |
| `afinn_sent` | AFINN sentiment score |
| `bing_sent` | Bing sentiment score |
| `anger` to `trust` | Emotion scores |
| `avg_sentiment` | Average sentiment score |

## 🔧 Troubleshooting

### Common Issues

#### 1. Reddit API Limits

**Problem:** Rate limiting or API errors
**Solution:**
```r
# Add delays between requests
Sys.sleep(2)  # Wait 2 seconds between requests
```

#### 2. Memory Issues

**Problem:** Out of memory errors with large datasets
**Solution:**
```r
# Process in batches
batch_size <- 1000
for(i in seq(1, nrow(data), batch_size)) {
  batch <- data[i:(i+batch_size-1), ]
  # Process batch
}
```

#### 3. Text Processing Errors

**Problem:** Encoding issues or malformed text
**Solution:**
```r
# Clean text before processing
clean_text <- function(text) {
  text <- iconv(text, "UTF-8", "ASCII", sub = "")
  text <- gsub("[^[:alnum:][:space:]]", "", text)
  return(text)
}
```

### Error Handling

```r
# Robust data collection with error handling
collect_reddit_data_safe <- function(company_name, num_posts = 1000) {
  tryCatch({
    urls <- find_thread_urls(keywords = company_name, period = "month")
    if(nrow(urls) == 0) {
      warning("No URLs found for keyword: ", company_name)
      return(NULL)
    }
    # Continue with processing
  }, error = function(e) {
    message("Error in data collection: ", e$message)
    return(NULL)
  })
}
```

## 🔧 Customization

### Modify Analysis Parameters

```r
# Customize data collection
collect_reddit_data(company_name = "your_company", num_posts = 500)

# Adjust sentiment analysis
analyze_sentiment(data, method = "syuzhet")

# Customize visualizations
create_visualizations(text_results, sentiment_data, "custom_name")
```

## 🙏 Acknowledgments

- **RedditExtractoR** - For Reddit data extraction capabilities
- **syuzhet** - For advanced sentiment analysis algorithms
- **R Community** - For excellent documentation and support
- **Reddit** - For providing the data source

---

<div align="center">

**⭐ Star this repository if you found it helpful! ⭐**

*Built with ❤️ using R and Reddit data*

[![GitHub stars](https://img.shields.io/github/stars/Basanth08/Sentimental_Analysis?style=social)](https://github.com/Basanth08/Sentimental_Analysis)
[![GitHub forks](https://img.shields.io/github/forks/Basanth08/Sentimental_Analysis?style=social)](https://github.com/Basanth08/Sentimental_Analysis)

**Ready to analyze sentiment? Start exploring public opinion with Reddit data today! 🚀**

</div>

