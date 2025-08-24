import json

# JSON 파일 경로
file_path = "voca_user.json"

# JSON 파일 불러오기
with open(file_path, "r", encoding="utf-8") as f:
    data = json.load(f)

# 원소 개수 세기
print(f"총 원소 개수: {len(data)}")
