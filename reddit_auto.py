import praw
import json
import os

# Reddit API 인증
reddit = praw.Reddit(
    client_id="v709z7WT1Rxv5kDsHfN1eQ",
    client_secret="q1WjnthWNOCJ9xSZXbA-kKfC8ASzhw",
    user_agent="bremen"
)

# 여러 서브레딧 목록
subreddits = ["Kpop"]

all_posts = []

for sub in subreddits:
    subreddit = reddit.subreddit(sub)
    posts = subreddit.hot(limit=50)
    num=0
    for post in posts:
        if not post.is_self:
            continue
        num=num+1
        if num>5:
            break
        post.comments.replace_more(limit=0)
        top_comments = [comment.body for comment in post.comments[:3]]

        post_data = {
            "subreddit": sub,        # 서브레딧 정보 추가
            "title": post.title,
            "body": post.selftext,
            "comments": top_comments,
            "url": post.url,
            "tag":""
        }
        all_posts.append(post_data)

# JSON 파일로 저장
os.makedirs("reddit_posts", exist_ok=True)
with open("reddit_posts/kpop.json", "w", encoding="utf-8") as f:
    json.dump(all_posts, f, ensure_ascii=False, indent=4)
