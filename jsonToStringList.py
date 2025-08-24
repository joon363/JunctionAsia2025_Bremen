import json

# JSON 파일 열기
with open("app_data/voca_user.json", "r", encoding="utf-8") as f:
    data = json.load(f)

# word만 뽑아서 리스트 생성
words_list = [item["word"] for item in data]

# 다른 파일에 저장
with open("words_list.json", "w", encoding="utf-8") as f:
    json.dump(words_list, f, ensure_ascii=False, indent=2)

print("words_list.json 파일로 저장 완료!")
