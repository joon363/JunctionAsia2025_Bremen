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
    .init(text: "typography",
          meaning: "활자체 디자인, 조판",
          partOfSpeech: "noun",
          pronunciation: "ty·POG·ra·phy",
          examples: [
            "Good typography improves readability.",
            "She studied typography in art school."
          ],
          synonyms: ["typesetting", "printing"]),
    .init(text: "concise",
          meaning: "간결한",
          partOfSpeech: "adjective",
          pronunciation: "con·CISE",
          examples: [
            "Please write concise explanations.",
            "A concise email is easier to read."
          ],
          synonyms: ["brief", "succinct", "terse"]),
    .init(text: "concise",
          meaning: "간결한",
          partOfSpeech: "adjective",
          pronunciation: "con·CISE",
          examples: [
            "Please write concise explanations.",
            "A concise email is easier to read."
          ],
          synonyms: ["brief", "succinct", "terse"]),
    .init(text: "concise",
          meaning: "간결한",
          partOfSpeech: "adjective",
          pronunciation: "con·CISE",
          examples: [
            "Please write concise explanations.",
            "A concise email is easier to read."
          ],
          synonyms: ["brief", "succinct", "terse"]),
    .init(text: "concise",
          meaning: "간결한",
          partOfSpeech: "adjective",
          pronunciation: "con·CISE",
          examples: [
            "Please write concise explanations.",
            "A concise email is easier to read."
          ],
          synonyms: ["brief", "succinct", "terse"]),
    .init(text: "concise",
          meaning: "간결한",
          partOfSpeech: "adjective",
          pronunciation: "con·CISE",
          examples: [
            "Please write concise explanations.",
            "A concise email is easier to read."
          ],
          synonyms: ["brief", "succinct", "terse"]),
    .init(text: "concise",
          meaning: "간결한",
          partOfSpeech: "adjective",
          pronunciation: "con·CISE",
          examples: [
            "Please write concise explanations.",
            "A concise email is easier to read."
          ],
          synonyms: ["brief", "succinct", "terse"]),
    .init(text: "concise",
          meaning: "간결한",
          partOfSpeech: "adjective",
          pronunciation: "con·CISE",
          examples: [
            "Please write concise explanations.",
            "A concise email is easier to read."
          ],
          synonyms: ["brief", "succinct", "terse"]),
    .init(text: "concise",
          meaning: "간결한",
          partOfSpeech: "adjective",
          pronunciation: "con·CISE",
          examples: [
            "Please write concise explanations.",
            "A concise email is easier to read."
          ],
          synonyms: ["brief", "succinct", "terse"]),
    .init(text: "concise",
          meaning: "간결한",
          partOfSpeech: "adjective",
          pronunciation: "con·CISE",
          examples: [
            "Please write concise explanations.",
            "A concise email is easier to read."
          ],
          synonyms: ["brief", "succinct", "terse"]),
    .init(text: "concise",
          meaning: "간결한",
          partOfSpeech: "adjective",
          pronunciation: "con·CISE",
          examples: [
            "Please write concise explanations.",
            "A concise email is easier to read."
          ],
          synonyms: ["brief", "succinct", "terse"])
]

// MARK: - Root 여기가 루트
struct WordbookView: View {
    @State private var words: [Word] = sampleWords

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(words) { w in
                    WordRow(word: w)
                        .padding(.horizontal, 16)
                }
            }
            .padding(.vertical, 16)
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
                if let pos = word.partOfSpeech, !pos.isEmpty {
                    Text("· \(pos)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            //발음은 빼기
//            if let pr = word.pronunciation, !pr.isEmpty {
//                Text("/ \(pr) /")
//                    .font(.footnote)
//                    .foregroundStyle(.secondary)
//            }
            Text(word.meaning)
                .font(.body)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(WordbookColors.card)
                .strokeBorder(WordbookColors.stroke, lineWidth: 0.6)
        )
        .contentShape(Rectangle()) // 전체 영역 탭 가능
        .onTapGesture { showPopover = true }
        .popover(isPresented: $showPopover, attachmentAnchor: .rect(.bounds), arrowEdge: .top) {
            WordDetailCard(word: word)
                .presentationCompactAdaptation(.popover) // iPhone에서도 팝오버 유지
        }
    }
}

// MARK: - Popover Content 이거는 팝오버 내용만!!
struct WordDetailCard: View {
    let word: Word

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                Text(word.text).font(.title3.bold())
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
                Text("Meaning").font(.subheadline.weight(.semibold))
                Text(word.meaning)
            }

            if !word.examples.isEmpty {
                Divider()
                VStack(alignment: .leading, spacing: 6) {
                    Text("Examples").font(.subheadline.weight(.semibold))
                    ForEach(word.examples, id: \.self) { ex in
                        Text("• \(ex)")
                    }
                }
            }

            if !word.synonyms.isEmpty {
                Divider()
                VStack(alignment: .leading, spacing: 6) {
                    Text("Synonyms").font(.subheadline.weight(.semibold))
                    Text(word.synonyms.joined(separator: ", "))
                }
            }
        }
        .padding(12)
        .frame(maxWidth: 360)
        .background(
            //RoundedRectangle(cornerRadius: 16)
                //.fill(WordbookColors.card)
                //.shadow(color: .black.opacity(0.1), radius: 10, y: 6)
        )
        .padding(8)
    }
}

// MARK: - Color Theme 컬러 세팅
enum WordbookColors {
    static let paper = Color(red: 1.0, green: 245/255, blue: 220/255)
    static let card  = Color(red: 1.0, green: 249/255, blue: 235/255)
    static let stroke = Color.black.opacity(0.1)
}

struct WordbookView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            WordbookView()
        }
    }
}
