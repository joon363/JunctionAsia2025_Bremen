import snscrape.modules.twitter as sntwitter
import json

query = "wildfire since:2025-01-01 until:2025-08-01 lang:en"
tweets = []

for i, tweet in enumerate(sntwitter.TwitterSearchScraper(query).get_items()):
    if i > 50:  # 50개만 가져오기
        break
    tweets.append({
        "date": str(tweet.date),
        "user": tweet.user.username,
        "content": tweet.content,
        "url": tweet.url
    })

# JSON 파일로 저장
with open("tweets.json", "w", encoding="utf-8") as f:
    json.dump(tweets, f, ensure_ascii=False, indent=2)

print("✅ tweets.json 저장 완료")
