import json

# 파일 로드
with open("user_voca.json", "r", encoding="utf-8") as f:
    user_data = json.load(f)

with open("all_voca.json", "r", encoding="utf-8") as f:
    all_data = json.load(f)

# 합치기: 먼저 user_voca 넣고, all_voca로 덮어쓰기
merged_dict = {item["word"]: item for item in user_data}
for item in all_data:
    merged_dict[item["word"]] = item  # all_voca 우선

# 알파벳순 정렬
merged_list = sorted(merged_dict.values(), key=lambda x: x["word"].lower())

# 저장
with open("merged_voca.json", "w", encoding="utf-8") as f:
    json.dump(merged_list, f, ensure_ascii=False, indent=2)

print(f"총 {len(merged_list)}개의 항목이 merged_voca.json에 저장되었습니다. (all_voca 우선)")
