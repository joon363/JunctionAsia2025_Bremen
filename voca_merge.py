import json

# 파일 리스트
files = ["basic_200_voca.json", "voca_all.json"]

merged_dict = {}

# 각 파일 로드 후 병합
for file in files:
    with open(file, "r", encoding="utf-8") as f:
        data = json.load(f)
        for item in data:
            merged_dict[item["word"]] = item  # 중복 시 마지막 파일 데이터가 우선

# 알파벳 순 정렬
merged_list = sorted(merged_dict.values(), key=lambda x: x["word"].lower())

# 저장
with open("merged_basic_voca.json", "w", encoding="utf-8") as f:
    json.dump(merged_list, f, ensure_ascii=False, indent=2)

print(f"총 {len(merged_list)}개의 단어가 merged_basic_voca.json에 저장되었습니다.")
