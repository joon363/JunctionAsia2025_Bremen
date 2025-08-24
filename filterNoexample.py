import json

# 원본 파일 로드
with open("original/voca_10000.json", "r", encoding="utf-8") as f:
    data = json.load(f)

# 필터링 및 필드 제거
processed_data = []
for item in data:
    # example_eng가 빈 문자열이면 제외
    if item.get("example", {}).get("example_eng", "") == "":
        continue
    
    # 제거할 필드 제외
    filtered_item = {k: v for k, v in item.items() if k not in ["seq", "search_word", "etc", "level"]}
    processed_data.append(filtered_item)

# 저장
with open("voca_processed.json", "w", encoding="utf-8") as f:
    json.dump(processed_data, f, ensure_ascii=False, indent=2)

print(f"총 {len(processed_data)}개의 항목이 voca_processed.json에 저장되었습니다.")
