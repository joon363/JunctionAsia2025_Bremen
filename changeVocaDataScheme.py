import json

with open("app_data/voca_all.json", "r", encoding="utf-8") as f:
    data = json.load(f)

# word 제외하고 map 만들기
word_map = {item["word"]: {k: v for k, v in item.items() if k != "word"} for item in data}

with open("voca_all_mapped.json", "w", encoding="utf-8") as f:
    json.dump(word_map, f, ensure_ascii=False, indent=2)
