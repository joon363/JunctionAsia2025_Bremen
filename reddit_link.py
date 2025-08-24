import praw
import json
import os

# Reddit API 인증
reddit = praw.Reddit(
    client_id="v709z7WT1Rxv5kDsHfN1eQ",
    client_secret="q1WjnthWNOCJ9xSZXbA-kKfC8ASzhw",
    user_agent="bremen"
)

# 수집할 Reddit 링크 리스트
post_urls = [
    "https://www.reddit.com/r/cartoons/comments/1mlov35/kpop_demon_hunters_is_just_everything_disney/",
    "https://www.reddit.com/r/netflix/comments/1mhzsi2/k_pop_demon_hunters_is_incredible/",
    "https://www.reddit.com/r/Music/comments/m4ura1/the_kpop_industry_is_disturbing_and_has_a_dark/",
    "https://www.reddit.com/r/kpoprants/comments/1mfkpxw/why_do_many_kpop_fans_lack_personal_hygiene/"
]


all_posts = []

for url in post_urls:
    submission = reddit.submission(url=url)

    # 텍스트형 글만 수집 (이미지/링크형 제외하려면 조건)
    if not submission.is_self:
        continue

    # 상위 댓글 3개
    submission.comments.replace_more(limit=0)
    top_comments = [comment.body for comment in submission.comments[:3]]

    post_data = {
        "subreddit": submission.subreddit.display_name,
        "title": submission.title,
        "body": submission.selftext,
        "comments": top_comments,
        "url": submission.url,
        "tag": ""
    }
    all_posts.append(post_data)

# JSON 파일로 저장
os.makedirs("reddit_posts", exist_ok=True)
with open("reddit_posts/manual_posts.json", "w", encoding="utf-8") as f:
    json.dump(all_posts, f, ensure_ascii=False, indent=4)

print(f"{len(all_posts)} posts saved.")
