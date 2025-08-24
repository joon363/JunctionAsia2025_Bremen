import json
import random

# 파일 로드
with open("final/Highschool.json", "r", encoding="utf-8") as f:
    high_data = json.load(f)

with open("final/TOEFL.json", "r", encoding="utf-8") as f:
    toefl_data = json.load(f)

with open("final/GRE_verbal_test.json", "r", encoding="utf-8") as f:
    gre_data = json.load(f)

# 비율 적용
high_sample = random.sample(high_data, int(len(high_data) * 0.83))
toefl_sample = random.sample(toefl_data, int(len(toefl_data) * 0.62))
gre_sample = random.sample(gre_data, int(len(gre_data) * 0.41))

# 우선순위: Highschool > TOEFL > GRE
merged_dict = {item["word"]: item for item in gre_sample}  # GRE 먼저
for item in toefl_sample:
    if item["word"] not in merged_dict:
        merged_dict[item["word"]] = item
for item in high_sample:
    if item["word"] not in merged_dict:
        merged_dict[item["word"]] = item

# 알파벳 순 정렬
merged_list = sorted(merged_dict.values(), key=lambda x: x["word"].lower())

# 저장
with open("user_knows_voca.json", "w", encoding="utf-8") as f:
    json.dump(merged_list, f, ensure_ascii=False, indent=2)

print(f"샘플 데이터셋 저장 완료! 총 {len(merged_list)}개 단어")
