import json
import random
from datetime import datetime, timedelta

# JSON 파일 불러오기 (Map 형태)
with open("app_data/voca_all.json", "r", encoding="utf-8") as f:
    data = json.load(f)  # dict 형태

# 최근 3개월(90일) 내 랜덤 날짜 생성 함수
def random_date_within_last_3_months():
    now = datetime.now()
    start = now - timedelta(days=90)
    random_seconds = random.randint(0, int((now - start).total_seconds()))
    random_date = start + timedelta(seconds=random_seconds)
    return random_date.isoformat()

# 각 단어(value)에 랜덤 last_view_timestamp 추가
for word, info in data.items():
    info["last_view_timestamp"] = random_date_within_last_3_months()

# 수정된 데이터를 새 파일로 저장
with open("voca_all.json", "w", encoding="utf-8") as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

print("최근 3개월 랜덤 last_view_timestamp가 추가된 JSON 저장 완료!")
