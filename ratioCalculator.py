import json

# 파일 로드
with open("user_knows_voca.json", "r", encoding="utf-8") as f:
    merged = json.load(f)
merged_words = set(item["word"] for item in merged)

with open("Highschool.json", "r", encoding="utf-8") as f:
    high = json.load(f)
high_words = set(item["word"] for item in high)

with open("TOEFL.json", "r", encoding="utf-8") as f:
    toefl = json.load(f)
toefl_words = set(item["word"] for item in toefl)

with open("GRE_verbal_test.json", "r", encoding="utf-8") as f:
    gre = json.load(f)
gre_words = set(item["word"] for item in gre)

# 포함된 단어 수 계산
high_included = len(high_words & merged_words)
toefl_included = len(toefl_words & merged_words)
gre_included = len(gre_words & merged_words)

# 비율 계산
print(f"Highschool: {high_included} / {len(high_words)} ≈ {high_included / len(high_words) * 100:.2f}%")
print(f"TOEFL: {toefl_included} / {len(toefl_words)} ≈ {toefl_included / len(toefl_words) * 100:.2f}%")
print(f"GRE: {gre_included} / {len(gre_words)} ≈ {gre_included / len(gre_words) * 100:.2f}%")
