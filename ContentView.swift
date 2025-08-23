//  ContentView.swift
//  withdesign
//
//  Created by 임유리 on 8/23/25.
//
//

import SwiftUI

//MARK: 프로필 뷰
struct ProfileView: View {
    var body: some View {
        VStack {
            Text("Profile View")
                .font(.largeTitle)
                .fontWeight(.bold)
            Image(systemName: "person.circle.fill")
                .font(.system(size: 100))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.1))
    }
}

//MARK: 알람 뷰
struct NotificationsView: View {
    var body: some View {
        VStack {
            Text("Notifications View")
                .font(.largeTitle)
                .fontWeight(.bold)
            Image(systemName: "bell.fill")
                .font(.system(size: 100))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.1))
    }
}
//바 관련 enum
enum TopBarView {
    case study
    case profile
    case notifications
}


enum Tab {
    case stats
    case study
    case wordbook
}


//MARK: 컨텐츠뷰 루트
struct ContentView: View {
    
    @State private var selectedTopView: TopBarView = .study
    @State private var selectedTab: Tab = .study
    
    var selectedTabTitle: String {
        switch selectedTab {
        case .stats:
            return "Statistics"
        case .study:
            return "Study"
        case .wordbook:
            return "Wordbook"
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: 맨 위 네비게이션
            HStack {
                Button(action: {
                    self.selectedTopView = .profile
                }) {
                    Image(systemName: "gear")
                        //.font(.title)
                        .font(.system(size: 20))
                        .foregroundColor(selectedTopView == .profile ? .blue : .primary)
                }
                
                Spacer()
                
                Button(action: {
                    self.selectedTopView = .study
                }) {

                    Text(selectedTabTitle)
                        //.font(.headline)
                        .font(.system(size: 20))
                        .bold()
                        .foregroundColor(Color.orange)

                }
                
                Spacer()
                
                Button(action: {
                    self.selectedTopView = .notifications
                }) {
                    Image(systemName: "bell")
                        .font(.title2)
                        .foregroundColor(.white) // hide icon
                        //.foregroundColor(selectedTopView == .notifications ? .blue : .primary)
                }
            }
            .padding()
            Divider()
            
            switch selectedTopView {
            case .study:
                // MARK: 탭뷰
                TabView(selection: $selectedTab) {
                    StaticsView()
                        .tabItem {
                            Image(systemName: "chart.bar")
                            Text("Statistics")
                        }.tag(Tab.stats)
                    
                    StudyFeedView()
                        .tabItem {
                            Image(systemName: "highlighter")
                            Text("Study")
                        }.tag(Tab.study)
                    
                    WordbookView()
                        .tabItem {
                            Image(systemName: "book")
                            Text("Wordbook")
                        }.tag(Tab.wordbook)
                }.tint(.orange)

                
            case .profile:
                ProfileView()
                
            case .notifications:
                NotificationsView()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}



// MARK: - Models
struct Page: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let body: String
}

struct Post: Identifiable, Hashable {
    let id = UUID()
    let author: String
    let pages: [Page]
}

//MARK: 데이터 더 추가하기
let demoPosts: [Post] = [
    Post(author: "NameNameName", pages: [
        Page(title: "This is an interesting title.", body: ""),
        Page(title: "", body: "Lord is simply dummy text of the printing and typesetting industry Lord is simply dummy text of the printing and typesetting industry. Lord is simply dummy text of the printing and typesetting industry Lord is simply dummy text of the printing and typesetting industry."),
        Page(title: "", body: "there are many apples.  Lord is simply dummy text of the printing and typesetting industry Lord is simply dummy text of the printing and typesetting industry. Lord is simply dummy text of the printing and typesetting industry Lord is simply dummy text of the printing and typesetting industry.")
    ]),
    Post(author: "NameNameName", pages: [
        Page(title: "Title 2-1", body: ""),
        Page(title: "", body: "Another page content for the same post. Lord is simply dummy text of the printing and typesetting industry Lord is simply dummy text of the printing and typesetting industry. Lord is simply dummy text of the printing and typesetting industry Lord is simply dummy text of the printing and typesetting industry.")
    ]),
    Post(author: "NameNameName", pages: [
        Page(title: "Title 3-1", body: ""),
        Page(title: "", body: "Lord is simply dummy text of the printing and typesetting industry Lord is simply dummy text of the printing and typesetting industry. Lord is simply dummy text of the printing and typesetting industry Lord is simply dummy text of the printing and typesetting industry. Swipe vertically for next post."),
        Page(title: "", body: "Swipe horizontally for parts.Lord is simply dummy text of the printing and typesetting industry Lord is simply dummy text of the printing and typesetting industry. Lord is simply dummy text of the printing and typesetting industry Lord is simply dummy text of the printing and typesetting industry."),
        Page(title: "", body: "Lord is simply dummy text of the printing and typesetting industry Lord is simply dummy text of the printing and typesetting industry. Lord is simply dummy text of the printing and typesetting industry Lord is simply dummy text of the printing and typesetting industry.Swipe horizontally for parts.")
    ])
]

// MARK: - 스터디 피드 뷰 Root
struct StudyFeedView: View {
    @State private var currentPostIndex: Int = 0

    var body: some View {
        GeometryReader { geo in
            //MARK: 세로 넘어가기
            ScrollView(.vertical) {
                LazyVStack(spacing: 0) {
                    ForEach(Array(demoPosts.enumerated()), id: \.offset) { idx, post in
                        PostFullScreenCard(post: post, screenSize: geo.size)
                            .frame(width: geo.size.width, height: geo.size.height) // 한 화면
                            .background(Color("Ivory"))
                            .ignoresSafeArea()
                            .id(idx) // 위치 식별
                    }
                }
            }
            .scrollIndicators(.hidden)
            .scrollTargetLayout()
            .scrollTargetBehavior(.paging) // 세로 페이징
        }
    }
}

//수정용으로
struct PostFullScreenCard: View {
    let post: Post
    let screenSize: CGSize

    @State private var selectedPage: Int = 0
    @State private var headerHeight: CGFloat = 0   //  헤더 실제 높이 저장

    var body: some View {
        ZStack(alignment: .top) {
            // 탭뷰 사용해서 넘기기
            TabView(selection: $selectedPage) {
                ForEach(Array(post.pages.enumerated()), id: \.element.id) { idx, page in

                    PageCell(page: page, topInset: headerHeight + CGFloat(50))
                        .tag(idx)
                        .frame(width: screenSize.width, height: screenSize.height)
                        .contentShape(Rectangle())
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()

            //MARK: 상단 작성자 영역

            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    Circle().fill(Color.gray.opacity(0.4)).frame(width: 26, height: 26)
                    Text(post.author)
                        .foregroundStyle(.black.opacity(0.8))
                        .font(.system(size: 20))
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)
                Divider()
                    .padding(.top, 20)
                //Spacer()  //뭔가 이거 진짜 제거라는데
            }
           // 헤더 VStack의 실제 높이 측정
//            .background(
//                GeometryReader { proxy in
//                    Color.clear
//                        .onAppear { headerHeight = proxy.size.height }
//                        .onChange(of: proxy.size.height) { new in headerHeight = new }
//                }
//            )
            // 헤더 컨테이너만 높이 측정
                       .background(
                           GeometryReader { proxy in
                               Color.clear
                                  .onAppear { headerHeight = proxy.size.height }
                                   .onChange(of: proxy.size.height) { new in headerHeight = new }
                           }
                       )

            // 인디케이터
            VStack {
                Spacer()
                PageDots(count: post.pages.count, index: selectedPage)
                    .padding(.bottom, 44)
            }
        }
    }
}


// MARK: - 줄바꿈 레이아웃
struct WrappingHStack: Layout {
    var hSpacing: CGFloat = 4
    var vSpacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxW = proposal.width ?? .infinity
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowH: CGFloat = 0

        for sub in subviews {
            let s = sub.sizeThatFits(.unspecified)
            if x + s.width > maxW {
                x = 0
                y += rowH + vSpacing
                rowH = 0
            }
            rowH = max(rowH, s.height)
            x += s.width + hSpacing
        }
        return CGSize(width: proposal.width ?? x, height: y + rowH)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let maxW = bounds.width
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowH: CGFloat = 0

        for sub in subviews {
            let s = sub.sizeThatFits(.unspecified)
            if x + s.width > maxW {
                x = 0
                y += rowH + vSpacing
                rowH = 0
            }
            sub.place(
                at: CGPoint(x: bounds.minX + x, y: bounds.minY + y),
                proposal: ProposedViewSize(width: s.width, height: s.height)
            )
            x += s.width + hSpacing
            rowH = max(rowH, s.height)
        }
    }
}


// MARK: - single 수평 페이지

struct PageCell: View {
    let page: Page
    var topInset: CGFloat = 0
    @State private var highlightedWords: Set<String> = []

    var body: some View {
        VStack(spacing: 16) {
            // safe area 고려해서 (상단 inset)
            Color.clear.frame(height: topInset)

            // 제목 (세로 중앙 배치)
            Spacer()
            Text(page.title)
                .font(.system(size: 48, weight: .bold, design: .serif))
                .foregroundStyle(.black)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            Spacer()

            // 본문 (조금 더 위쪽에서 시작)
            VStack {
                let tokens = page.body
                    .components(separatedBy: .whitespacesAndNewlines)
                    .filter { !$0.isEmpty }

                WrappingHStack(hSpacing: 6, vSpacing: 10) {
                    ForEach(tokens, id: \.self) { word in
                        let cleaned = word.trimmingCharacters(in: .punctuationCharacters)
                        WordTokenView(
                            originalWord: word,
                            cleaned: cleaned,
                            highlighted: $highlightedWords
                        )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 5)
                .frame(maxWidth: .infinity, alignment: .leading)

            }
            .padding(.top, -150) // ← 제목과 너무 멀면 위로

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("red: 0.98, green: 0.98, blue: 0.94"))
    }
    private func toggleHighlight(for word: String) {
        let cleanedWord = word.trimmingCharacters(in: .punctuationCharacters)
        guard !cleanedWord.isEmpty else { return }
        if highlightedWords.contains(cleanedWord) {
            highlightedWords.remove(cleanedWord)
        } else {
            highlightedWords.insert(cleanedWord)
        }
    }
}

//MARK: 인디케이터 점 구현 관련
struct PageDots: View {
    let count: Int
    let index: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<count, id: \.self) { i in
                Circle()
                    .frame(width: 6, height: 6)
                    .opacity(i == index ? 1.0 : 0.35)
            }
        }
        .foregroundStyle(Color.gray)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(.thinMaterial, in: Capsule())
    }
}


//MARK: 툴팁, 팝업 파트

struct WordInfo: Identifiable, Equatable {
    let id = UUID()
    let word: String
    let meanings: [String]
    let examples: [String]
}

func lookupWord(_ w: String) -> WordInfo {
    // 샘플: 몇 개만 임시 등록
    let dict: [String: WordInfo] = [
        "swipe": .init(
            word: "swipe",
            meanings: ["비판", "훔치다"],
            examples: [
                "He used the interview to take a swipe at his critics."
            ]
        ),
        "word": .init(
            word: "word",
            meanings: ["단어", "말을 쓰다", "이야기"],
            examples: [
                "Do not write more than 200 words.",
                "Have a word with Pat and see what she thinks."
            ]
        ),
        "typesetting": .init(
            word: "typesetting",
            meanings: ["식자", "조판", "타이프세팅"],
            examples: [
                "Digital typesetting changed publishing forever."
            ]
        )
    ]
    if let found = dict[w.lowercased().trimmingCharacters(in: .punctuationCharacters)] {
        return found
    } else {
        return .init(word: w, meanings: ["준비 중"], examples: [])
    }
}

//MARK: 툴팁과 + 버튼 달린 토큰 뷰
struct WordTokenView: View {
    let originalWord: String
    let cleaned: String //점 제거
    @Binding var highlighted: Set<String>

    @State private var showPopover = false
    @State private var showDetail = false
    private var info: WordInfo { lookupWord(cleaned) }

    var isHighlighted: Bool { highlighted.contains(cleaned) }

    var body: some View {
        Text(originalWord)
            .font(.system(size: 24))
            .padding(3)
            .background(isHighlighted ? Color.yellow.opacity(0.5) : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .contentShape(Rectangle())
            .onTapGesture {
                // 형광펜 토글 + 툴팁 열기
                if isHighlighted { highlighted.remove(cleaned) } else { highlighted.insert(cleaned) }
                showPopover = true
            }
            .popover(isPresented: $showPopover,
                     attachmentAnchor: .rect(.bounds),
                     arrowEdge: .top) {
                // 작은 툴팁 컨텐츠
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(info.word)
                            .font(.system(size: 20, weight: .bold))
                        Spacer()
                        Button {
                            showDetail = true
                        } label: {
                            Image(systemName: "plus.circle")
                                .font(.system(size: 18, weight: .semibold))
                        }
                        .buttonStyle(.plain)
                    }

                    if let first = info.meanings.first {
                        Text(first)
                            .font(.system(size: 16))
                    } else {
                        Text("뜻 없음")
                            .font(.system(size: 16))
                    }
                }
                .padding(14)
                .frame(maxWidth: 260, alignment: .leading)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                .presentationCompactAdaptation(.popover)
            }
            .sheet(isPresented: $showDetail) {
                WordDetailSheet(info: info)
                    .presentationDetents([.medium, .large])
            }
    }
}
//MARK: 큰 팝업 파트
struct WordDetailSheet: View {
    let info: WordInfo
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.black.opacity(0.05).ignoresSafeArea()

            VStack {
                Spacer(minLength: 12)

                VStack(alignment: .leading, spacing: 16) {
                    // 제목
                    Text(info.word)
                        .font(.system(size: 28, weight: .heavy))

                    // 1) 의미 리스트
                    if !info.meanings.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(Array(info.meanings.enumerated()), id: \.offset) { i, m in
                                HStack(alignment: .firstTextBaseline, spacing: 8) {
                                    Text("\(i+1).")
                                        .font(.system(size: 18, weight: .semibold))
                                    Text(m)
                                        .font(.system(size: 18))
                                }
                            }
                        }
                    }

                    // 2) 예문
                    if !info.examples.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("예문")
                                .font(.system(size: 16, weight: .semibold))
                                .padding(.top, 4)

                            VStack(alignment: .leading, spacing: 6) {
                                ForEach(info.examples, id: \.self) { ex in
                                    HStack(alignment: .top, spacing: 8) {
                                        Text("•")
                                        Text(ex)
                                    }
                                }
                            }
                        }
                    }

                    Divider().padding(.vertical, 6)

                    // OK 버튼
                    Button {
                        dismiss()
                    } label: {
                        Text("OK")
                            .font(.system(size: 20, weight: .semibold))
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                    .padding(.bottom, 6)
                }
                .padding(22)
                .background(
                    RoundedRectangle(cornerRadius: 26)
                        .fill(Color(red: 1.0, green: 0.98, blue: 0.88)) // 아이보리 톤
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 26)
                        .stroke(Color("CustomOrange"), lineWidth: 3)
                )
                .padding(.horizontal, 24)

                Spacer(minLength: 32)
            }
        }
    }
}

struct StudyFeedView_Previews: PreviewProvider {
    static var previews: some View {
        StudyFeedView()
            .preferredColorScheme(.light)
    }
}
