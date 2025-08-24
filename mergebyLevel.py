import json

# 두 파일 로드
with open("levels/high.json", "r", encoding="utf-8") as f1, open("high_empty.json", "r", encoding="utf-8") as f2:
    data1 = json.load(f1)
    data2 = json.load(f2)

# 합치기: 먼저 file1 데이터를 넣고, 이후 file2 데이터로 덮어쓰기
merged_dict = {item["word"]: item for item in data1}
for item in data2:
    merged_dict[item["word"]] = item  # file2 데이터가 우선

# 정렬 (word 기준 알파벳 순)
merged_list = sorted(merged_dict.values(), key=lambda x: x["word"].lower())

# 저장
with open("high_merged.json", "w", encoding="utf-8") as f:
    json.dump(merged_list, f, ensure_ascii=False, indent=2)

print(f"총 {len(merged_list)}개의 항목이 merged.json에 저장되었습니다. (file2 데이터 우선)")
