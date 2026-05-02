
# Get the top stories from Hacker News


news(){
local top_stories=$(curl -s https://hacker-news.firebaseio.com/v0/topstories.json | jq '.[:5]') # Get the first 5 stories
for story_id in $(echo "$top_stories" | jq -r '.[]'); do
    # Fetch details of each story
    story=$(curl -s "https://hacker-news.firebaseio.com/v0/item/${story_id}.json")
    
    # Parse and display story title and URL
    title=$(echo "$story" | jq -r '.title')
    url=$(echo "$story" | jq -r '.url')
    
    echo "Title: $title"
    echo "URL: ${url:-No URL provided}"
    echo "--------------------------------"
done
}
