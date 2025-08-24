//
//  WordbookView.swift
//  withdesign
//
//  Created by 임유리 on 8/23/25.
//

import SwiftUI

// MARK: - Model
struct Word: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let meaning: String
    let partOfSpeech: String?
    let pronunciation: String?
    let examples: [String]
    let synonyms: [String]
}

// MARK: 데이터 더 넣기
let sampleWords: [Word] = [
    .init(text: "obvious",
          meaning: "분명한, 확실한, 너무 뻔한",
          partOfSpeech: "adjective",
          pronunciation: "taɪ|pɑːɡrəfi",
          examples: [
            "It was obvious to everyone that the child had been badly treated."
          ],
          synonyms: ["natural", "logical"]),
    .init(text: "typography",
          meaning: "활자체 디자인, 조판",
          partOfSpeech: "noun",
          pronunciation: "taɪ|pɑːɡrəfi",
          examples: [
            "Good typography improves readability.",
            "She studied typography in art school."
          ],
          synonyms: ["typesetting", "printing"]),
    .init(text: "concise",
          meaning: "간결한",
          partOfSpeech: "adjective",
          pronunciation: "kənˈsaɪs",
          examples: [
            "Please write concise explanations.",
            "A concise email is easier to read."
          ],
          synonyms: ["brief", "succinct", "terse"]),
    .init(text: "abase",
          meaning: "낮추다",
          partOfSpeech: "verb",
          pronunciation: "əˈbeɪs",
          examples: [
            "The president is not willing to abase himself before the nation, and admit that he made a mistake"
          ],
          synonyms: ["humble", "belittle", "lower"]),
    .init(text: "abbreviate",
          meaning: "생략하다",
          partOfSpeech: "verb",
          pronunciation: "əˈbriːvieɪt",
          examples: [
            "You are to abbreviate “Avenue” as “Ave.”"
          ],
          synonyms: ["shorten", "reduce", "cut"]),
    .init(text: "baker",
          meaning: "빵 제조 판매인",
          partOfSpeech: "noun",
          pronunciation: "ˈbeɪkə(r)",
          examples: [
            "The baker gets up early every morning to make fresh bread"
          ],
          synonyms: []),
    .init(text: "cacophony",
          meaning: "불협화음",
          partOfSpeech: "noun",
          pronunciation: "kə|kɑːfəni",
          examples: [
            "We can't stand the cacophony anymore."
          ],
          synonyms: ["din", "noise"]),
    .init(text: "dainty",
          meaning: "맛 좋은",
          partOfSpeech: "adjective",
          pronunciation: "ˈdeɪnti",
          examples: [
            "We were given tea, and some dainty little cakes"
          ],
          synonyms: ["tasty", "delicious"]),
    .init(text: "easygoing",
          meaning: "태평한",
          partOfSpeech: "adjective",
          pronunciation: "í:ziɡóuiŋ",
          examples: [
            "The people were so friendly and easygoing there.",
            "Our manager's an easygoing person."
          ],
          synonyms: []),
    .init(text: "ecclesiastic",
          meaning: "성직자",
          partOfSpeech: "noun",
          pronunciation: "ɪˌkliːziˈæstɪk",
          examples: [
            "The ecclesiastic meets a member of his church."
          ],
          synonyms: ["clergyman", "priest"]),
    .init(text: "eclecticism",
          meaning: "절충주의",
          partOfSpeech: "noun",
          pronunciation: "ɪˈklektɪk",
          examples: [
            "He adopted this policy by a wise eclecticism."
          ],
          synonyms: ["selecting"]),
    .init(text: "gallant",
          meaning: "용감한",
          partOfSpeech: "adjective",
          pronunciation: "ˈɡælənt",
          examples: [
            "She made a gallant attempt to hide her tears."
          ],
          synonyms: ["brave", "courageous"])
]

// MARK: - Root 여기가 루트
struct WordbookView: View {
    @State private var words: [Word] = sampleWords

    var body: some View {
        ScrollView {
            Text("단어 수: 187개")
                .font(.system(size: 20))
                .padding(.top, 12)
            Divider()
            
            LazyVStack(spacing: 12) {
                ForEach(words) { w in
                    WordRow(word: w)
                        .padding(.horizontal, 16)
                }
            }
            .padding(.vertical, 12)
        }
        //.background(WordbookColors.paper.ignoresSafeArea(edges:.top))
        .navigationTitle("Wordbook")
    }
}

// MARK: - Row + Popover 팝오버 사용
struct WordRow: View {
    let word: Word
    @State private var showPopover = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline) {
                Text(word.text)
                    .font(.title3.weight(.semibold))
                Spacer()
                if let pos = word.partOfSpeech, !pos.isEmpty {
                    Text("\(pos)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            //발음은 빼기
//            if let pr = word.pronunciation, !pr.isEmpty {
//                Text("/ \(pr) /")
//                    .font(.footnote)
//                    .foregroundStyle(.secondary)
//            }
            HStack(alignment: .firstTextBaseline) {
                Text(word.meaning)
                    .font(.body)
                Spacer()
                if word.text == "obvious" {
                    Text("NEW!")
                        .font(.subheadline)
                        .foregroundStyle(.black)
                        .italic()
                }
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(word.text == "obvious" ? Color(red: 202/255, green: 207/255, blue: 230/255) : WordbookColors.card)
                .strokeBorder(WordbookColors.stroke, lineWidth: 0.6)
        )
        .contentShape(Rectangle()) // 전체 영역 탭 가능
        .onTapGesture { showPopover = true }
        .popover(isPresented: $showPopover, attachmentAnchor: .rect(.bounds), arrowEdge: nil) {
            WordDetailCard(word: word)
                .presentationCompactAdaptation(.popover) // iPhone에서도 팝오버 유지
        }
    }
}

// MARK: - Popover Content 이거는 팝오버 내용만!!
struct WordDetailCard: View {
    let word: Word

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .firstTextBaseline) {
                    Text(word.text).font(.title3.weight(.bold))
                    if let pos = word.partOfSpeech, !pos.isEmpty {
                        Text("(\(pos))").foregroundStyle(.secondary)
                    }
                    Spacer()
                }

                if let pr = word.pronunciation, !pr.isEmpty {
                    Label(pr, systemImage: "speaker.wave.2.fill")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Divider()

                VStack(alignment: .leading, spacing: 6) {
                    Text("뜻").font(.subheadline.weight(.semibold))
                    Text(word.meaning)
                }

                if !word.examples.isEmpty {
                    Divider()
                    VStack(alignment: .leading, spacing: 6) {
                        Text("예문").font(.subheadline.weight(.semibold))
                        ForEach(word.examples, id: \.self) { ex in
                            Text("• \(ex)")
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }

                if !word.synonyms.isEmpty {
                    Divider()
                    VStack(alignment: .leading, spacing: 6) {
                        Text("유의어").font(.subheadline.weight(.semibold))
                        Text(word.synonyms.joined(separator: ", "))
                    }
                }
            }
            .frame(maxWidth: 360)
            .background(
                //RoundedRectangle(cornerRadius: 16)
                    //.fill(WordbookColors.card)
                    //.shadow(color: .black.opacity(0.1), radius: 10, y: 6)
            )
            .padding(12)
        }
        .padding(8)
    }
}

// MARK: - Color Theme 컬러 세팅
enum WordbookColors {
    static let paper = Color(red: 1.0, green: 245/255, blue: 220/255)
    static let card  = Color(red: 229/255, green: 231/255, blue: 243/255)
    static let stroke = Color.black.opacity(0.1)
}

struct WordbookView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            WordbookView()
        }
    }
}
