import feedparser
import re

# Replace with your RSS feed URL
feed_url = "https://feeds.feedburner.com/TheHackersNews"
feed = feedparser.parse(feed_url)

# Initialize list to store news items without URLs
news_items = []

# Loop through the entries in the feed
for entry in feed.entries:
    # Remove the URL part from the title using a regular expression
    title = entry.title
    
    # Optional: You can also add a check to exclude any URL inside the title itself
    title_without_url = re.sub(r'http[s]?://\S+', '', title)
    
    # Append the cleaned title to the list
    news_items.append(title_without_url)

# Join the news items into a single string separated by " | "
news_text = " | ".join(news_items)

# Output the cleaned news text
print(news_text)

