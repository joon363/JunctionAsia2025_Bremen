import json
import os

# 원본 파일 로드
with open("voca_10000.json", "r", encoding="utf-8") as f:
    data = json.load(f)

# 레벨별 데이터 저장용 딕셔너리
level_dict = {}

for item in data:
    # level 필드 처리
    levels = [lvl.strip() for lvl in item["level"].split(",") if lvl.strip()]
    # level 필드 제거
    item_no_level = {k: v for k, v in item.items() if (k != "level" and k != "seq" and k != "search_word"and k != "etc")}
    for lvl in levels:
        if lvl not in level_dict:
            level_dict[lvl] = []
        level_dict[lvl].append(item_no_level)

# 결과 저장 폴더 생성
output_dir = "levels"
os.makedirs(output_dir, exist_ok=True)

# 레벨별 파일 저장
for lvl, items in level_dict.items():
    # 파일 이름 안전하게 처리 (공백 제거, 특수문자 대체)
    safe_lvl = lvl.replace(" ", "_").replace("/", "_")
    filename = os.path.join(output_dir, f"{safe_lvl}.json")
    with open(filename, "w", encoding="utf-8") as f:
        json.dump(items, f, ensure_ascii=False, indent=2)

print("레벨별 JSON 파일 저장 완료! (level 필드 제거됨)")
