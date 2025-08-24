import json

# 세 파일 로드
with open("final/Highschool.json", "r", encoding="utf-8") as f1, \
     open("final/TOEFL.json", "r", encoding="utf-8") as f2, \
     open("final/GRE_verbal_test.json", "r", encoding="utf-8") as f3:
    high_data = json.load(f1)
    toefl_data = json.load(f2)
    gre_data = json.load(f3)

# 우선순위: Highschool > TOEFL > GRE
# 먼저 GRE로 채운 뒤, TOEFL이 있으면 덮어쓰고, 마지막에 Highschool로 덮어씀
merged_dict = {item["word"]: item for item in gre_data}

for item in toefl_data:
    if item["word"] not in merged_dict:  # GRE에 없는 경우만 추가
        merged_dict[item["word"]] = item

for item in high_data:
    if item["word"] not in merged_dict:  # TOEFL, GRE 둘 다 없는 경우만 추가
        merged_dict[item["word"]] = item

# 알파벳순 정렬
merged_list = sorted(merged_dict.values(), key=lambda x: x["word"].lower())

# 저장
with open("voca_all.json", "w", encoding="utf-8") as f:
    json.dump(merged_list, f, ensure_ascii=False, indent=2)

print(f"총 {len(merged_list)}개의 항목이 merged_voca.json에 저장되었습니다. (Highschool > TOEFL > GRE 우선순위 적용)")
