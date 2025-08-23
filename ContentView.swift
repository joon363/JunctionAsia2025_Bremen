//  ContentView.swift
//  withdesign
//
//  Created by 임유리 on 8/23/25.
//
//
//

import SwiftUI

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
    Post(author: "Reddit", pages: [
            Page(title: "Why did the CEO gave me a deck of cards to organize during the interview?", body: ""),
            Page(title: "", body: "I’m just here to learn something. I’ve never seen this tactic before and cannot find anything about it online."),
            Page(title: "", body: "What was the point of me organizing the deck of cards other that to just see if I could? There was a 6 missing also. ")
        ]),
        Post(author: "Reddit", pages: [
            Page(title: "How hard would it likely be for alien to figure out how to play it?", body: ""),
            Page(title: "", body: "i guess i’m wondering how obvious the design of a dvd player could be from just having a DVD itself to work off of")
        ]),
        Post(author: "Reddit", pages: [
            Page(title: "Is my husband using drugs?", body: ""),
            Page(title: "", body: "I found empty cigarette packs with used rubber gloves crumpled up inside. Some of the gloves look like they have blood inside. I've never seen any track marks on him and I've never known him to do this, but as we all know, every one has their secrets."),
            Page(title: "", body: "Each empty pack has one or two gloves inside. They are all different colours. He doesn't use rubber gloves for work or at home. Does any one know if this is for drug use?"),
            
        ]),
    Post(author: "Reddit", pages: [
        Page(title: "Why do people get prenups?", body: ""),
        Page(title: "", body: "So I've been seeing posts about prenups and I'm confused. Isn't it weird to plan for divorce before marriage?"),
        Page(title: "", body: "I get it's for protecting assets, inheritance, or a business, but can't you just not put your spouse's name on things?"),
        Page(title: "", body: "Also, how do you bring it up without killing the vibe? Is this mostly for rich people, or do regular folks do it too? "),
        Page(title: "", body: "I've heard it can make divorce easier, but shouldn't the focus be on not getting divorced? Not judging, just trying to understand. ELI5 please."),
    ]),
    Post(author: "Reddit", pages: [
        Page(title: "I’ve read that if you hit a parked car you should leave a note on the windshield.", body: ""),
        Page(title: "", body: "What if the note blows away in the wind before the owner of the hit car returns? Can you get in trouble then?")
    ]),
    Post(author: "Reddit", pages: [
        Page(title: "Are hotel room cleaners happy when they see a “Do not disturb” sign?", body: ""),
        Page(title: "", body: "I never care about getting my hotel room cleaned if I’m just there for a night or two. I don’t need new towels or my bed made. How can I make the lives of the cleaning staff easier?")
    ]),
        Post(author: "Reddit", pages: [
            Page(title: "How do guys with butt chins shave the crack?", body: ""),
            Page(title: "", body: "Do they have to pull the skin out or smth?")
        ]),
        Post(author: "Reddit", pages: [
            Page(title: "Do new iPhones actually have worse batteries or am I just overthinking it?", body: ""),
            Page(title: "", body: "Every time I get the newest iPhone the battery seems to die faster than my old one did when it was new. Within a few months I'm charging way more often."),
            Page(title: "", body: "Do newer iPhones actually have worse batteries or could it be that phones are doing more in the background now maybe the brighter screens and heavier apps drain battery quicker even though the capacity is better"),
            Page(title: "", body: "it feels like each upgrade comes with a battery downgrade. Has anyone else noticed this?")
        ]),
        Post(author: "Reddit", pages: [
            Page(title: "Why don't they make weed-eaters with steel cable instead of plastic string?", body: ""),
            Page(title: "", body: "Super dangerous, metal is both more likely to tear up flesh, but also more likely to break into dangerous splinters of metal as opposed to less harmful plastic. so people dont get maimed")
        ])
]





// MARK: - 스터디 피드 뷰 (Corrected)

struct StudyFeedView: View {
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                ForEach(demoPosts) { post in
                    
                    PostFullScreenCard(post: post)
                        .containerRelativeFrame(.vertical) // Makes each card fill the viewport height
                        .id(post.id)
                }
                //퀴즈뷰 추가
                QuizView()
                    .containerRelativeFrame(.vertical)
                //최종 화면 추가
                EndView()
                    .containerRelativeFrame(.vertical)
            }
        }
        .scrollIndicators(.hidden)
        .scrollTargetLayout()
        .scrollTargetBehavior(.paging)
        .ignoresSafeArea() // Ignore safe area at the top level
        .background(Color("Ivory"))
    }
}

// MARK: - 마지막 화면에 쓸 데이터와 뷰
struct EndPage: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let text: String
    let iconName: String
}

// MARK: - 초록색 퀴즈뷰 화면에 쓸 데이터와 뷰
struct QuizPage: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let text: String
}

// 마지막 화면에 표시할 페이지 데이터
let endOfFeedPages: [EndPage] = [
    EndPage(title: "오늘의 학습 완료!", text: "오늘 학습할 콘텐츠를 완벽하게 학습하셨습니다.", iconName: "checkmark.circle.fill"),
    EndPage(title: "다음 학습은?", text: "단어장을 복습하거나 통계 화면으로 이동해 보세요.", iconName: "arrow.forward.circle.fill"),
    EndPage(title: "새로운 콘텐츠", text: "새로운 학습 콘텐츠는 매일 업데이트 됩니다.", iconName: "sparkles")
]

// 초록색 퀴즈뷰에 표시할 페이지 데이터
let quizOfFeedPages: [QuizPage] = [
    QuizPage(title: "reminiscence", text: ""),
    QuizPage(title: "", text: "추억, 회상"),
    QuizPage(title: "obvious", text: ""),
    QuizPage(title: "", text: "분명한, 확실한, 너무 뻔한"),

]

// 마지막 화면의 콘텐츠 뷰 (페이지별)
struct EndPageView: View {
    let page: EndPage
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: page.iconName)
                .font(.system(size: 80))
                .foregroundStyle(Color.orange.opacity(0.8))
            Text(page.title)
                .font(.system(size: 32, weight: .bold, design: .serif))
            Text(page.text)
                .font(.system(size: 20))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(.bottom,100)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


// 마지막 화면의 전체 컨테이너 뷰 (가로 스와이프 기능 포함)
struct EndView: View {
    @State private var selectedPage: Int = 0
    private let pages = endOfFeedPages

    var body: some View {
        ZStack {
            TabView(selection: $selectedPage) {
                ForEach(Array(pages.enumerated()), id: \.element.id) { idx, page in
                    EndPageView(page: page)
                        .tag(idx)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            // 페이지 인디케이터 (점)
            VStack {
                Spacer()
                if pages.count > 1 {
                    PageDots(count: pages.count, index: selectedPage)
                        .padding(.bottom, 90)
                }
            }
        }
    }
}



// 퀴즈뷰 화면의 콘텐츠 뷰 (페이지별)
struct QuizPageView: View {
    let page: QuizPage
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: !page.title.isEmpty ? "questionmark.app" : "exclamationmark.square")
                .font(.system(size: 80))
                .foregroundStyle(Color("Ivory"))
            if !page.title.isEmpty {
                Text(page.title)
                    .font(.system(size: 40, weight: .bold, design: .serif))
                    .foregroundStyle(Color("Ivory"))
                    //.padding(.bottom, 100)
                Text("넘겨서 뜻 보기")
                    .font(.system(size: 20))
                    .foregroundStyle(Color("Ivory"))
            }
            if !page.text.isEmpty {
                Text(page.text)
                    .font(.system(size: 40, weight: .bold, design:.serif))
                    .foregroundStyle(Color("Ivory"))
                    //.multilineTextAlignment(.center)
                    //.padding(.horizontal)
                Text("넘겨서 뜻 보기")
                    .font(.system(size: 20))
                    .foregroundStyle(Color("Lightgr"))
            }
            Divider().opacity(0).padding(.vertical, 12)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


// 퀴즈 화면의 전체 컨테이너 뷰 (가로 스와이프 기능 포함)
struct QuizView: View {
    @State private var selectedPage: Int = 0
    private let pages = quizOfFeedPages

    var body: some View {
        ZStack {
            TabView(selection: $selectedPage) {
                ForEach(Array(pages.enumerated()), id: \.element.id) { idx, page in
                    QuizPageView(page: page)
                        .tag(idx)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            // 페이지 인디케이터 (점)
            VStack {
                Spacer()
                if pages.count > 1 {
                    PageDots(count: pages.count, index: selectedPage)
                        .padding(.bottom, 90)
                }
            }
        }
        .background(Color("Lightgr"))

    }
}

// MARK: - Post Card (Corrected)
struct PostFullScreenCard: View {
    let post: Post
    @State private var selectedPage: Int = 0

    var body: some View {
        ZStack {
            TabView(selection: $selectedPage) {
                ForEach(Array(post.pages.enumerated()), id: \.element.id) { idx, page in
                   
                    PageCell(page: page)
                        .tag(idx)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            VStack {
                Spacer()
                if post.pages.count > 1 {
                    PageDots(count: post.pages.count, index: selectedPage)
                        .padding(.bottom, 90)
                }
            }
        }

        .safeAreaInset(edge: .top) {
            PostHeader(author: post.author)
        }
    }
}


// MARK: - 줄바꿈 레이아웃
struct WrappingHStack: Layout {
    var hSpacing: CGFloat = 4
    var vSpacing: CGFloat = 4

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


// MARK: - Page Cell
struct PageCell: View {
    let page: Page
    @State private var highlightedWords: Set<String> = []

    var body: some View {
        VStack(spacing: 16) {

            if !page.title.isEmpty {
                Spacer()
                Text(page.title)
                    .font(.system(size: 36, weight: .bold, design: .serif))
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                Spacer()
            }

            if !page.body.isEmpty {
                let tokens = page.body
                    .components(separatedBy: .whitespacesAndNewlines)
                    .filter { !$0.isEmpty }
                Spacer()
                WrappingHStack(hSpacing: 6, vSpacing: 0) {
                    ForEach(tokens, id: \.self) { word in
                        let cleaned = word.trimmingCharacters(in: .punctuationCharacters)
                        WordTokenView(originalWord: word, cleaned: cleaned, highlighted: $highlightedWords)
                    }
                }
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
            }

            if !page.title.isEmpty || !page.body.isEmpty {
                 Spacer(minLength: 0)
            }
           
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
    let synonyms: [String]
}

func lookupWord(_ w: String) -> WordInfo {
    // 샘플: 몇 개만 임시 등록
    let dict: [String: WordInfo] = [
        "swipe": .init(
            word: "swipe",
            meanings: ["비판", "훔치다"],
            examples: [
                "He used the interview to take a swipe at his critics."
            ],
            synonyms: [
                "steal", "strike"
            ]
        ),
        "word": .init(
            word: "word",
            meanings: ["단어", "말을 쓰다", "이야기"],
            examples: [
                "Do not write more than 200 words.",
                "Have a word with Pat and see what she thinks."
            ],
            synonyms: [
                "term", "phrase"
            ]
        ),
        "tactic": .init(
            word: "tactic",
            meanings: ["전략", "기술"],
            examples: [
                "They tried all kinds of tactics to get us to go.",
                "Confrontation is not always the best tactic."
            ],
            synonyms: [
                "device"
            ]
        ),
        "obvious": .init(
            word: "obvious",
            meanings: ["분명한", "확실한", "너무 뻔한"],
            examples: [
                "It was obvious to everyone that the child had been badly treated."
            ],
            synonyms: [
                "natural", "logical"
            ]
        ),
        "rubber": .init(
            word: "rubber",
            meanings: ["고무", "지우개"],
            examples: [
                "Rubber clay. Right, rubber clay."
            ],
            synonyms: []
        )
    ]
    if let found = dict[w.lowercased().trimmingCharacters(in: .punctuationCharacters)] {
        return found
    } else {
        return .init(word: w, meanings: ["뜻"], examples: [], synonyms: [])
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

    var isHighlighted: Bool { ["tactic", "rubber"].contains(cleaned) || highlighted.contains(cleaned) }
//    func insertPreSelectedWords() {
//        if ["tactic", "rubber"].contains(cleaned) {
//            highlighted.insert(cleaned)
//        }
//    }

    var body: some View {
        Text(originalWord)
//            .onAppear {
//                insertPreSelectedWords()
//            }
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

//MARK: 작성자
private struct PostHeader: View {
    let author: String
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
//               대신 레딧 붙이기 완료 Circle().fill(Color.gray.opacity(0.4)).frame(width: 26, height: 26)
                Image("Reddit")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 26, height: 26)
                    .clipShape(Circle())
                
                Text(author)
                    .foregroundStyle(.black.opacity(0.8))
                    .font(.system(size: 20))
                    .bold()
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 60) // Padding for the status bar area

            Divider().padding(.top, 20)
        }
        // The header itself needs a background to overlay correctly
        .background(Color("Ivory"))
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
                //Spacer(minLength: 12)

                VStack(alignment: .leading, spacing: 16) {
                    // 제목
                    Text(info.word)
                        .font(.system(size: 28, weight: .heavy))

                    // 1) 의미 리스트
                    if !info.meanings.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("뜻")
                                .font(.system(size: 16, weight: .semibold))
                                .padding(.top, 4)
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
                        Divider()
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
                    // 3) 유의어
                    if !info.synonyms.isEmpty {
                        Divider()
                        VStack(alignment: .leading, spacing: 6) {
                            Text("유의어")
                                .font(.system(size: 16, weight: .semibold))
                                .padding(.top, 4)
                            Text(info.synonyms.joined(separator: ", "))
                        }
                    }
                    
                    Divider().padding(.vertical, 6)

                    // OK 버튼
//                    Button {
//                        dismiss()
//                    } label: {
//                        Text("OK")
//                            .font(.system(size: 20, weight: .semibold))
//                            .frame(maxWidth: .infinity)
//                    }
//                    .buttonStyle(.plain)
//                    .padding(.bottom, 6)
                }
                .padding(22)
//                .background(
//                    RoundedRectangle(cornerRadius: 26)
//                        .fill(Color(red: 1.0, green: 0.98, blue: 0.88)) // 아이보리 톤
//                )
//                .overlay(
//                    RoundedRectangle(cornerRadius: 26)
//                        .stroke(Color("CustomOrange"), lineWidth: 3)
//                )
                .padding(.horizontal, 12)

                Spacer()
            }
        }
    }
}

//struct StudyFeedView_Previews: PreviewProvider {
//    static var previews: some View {
//        StudyFeedView()
//            .preferredColorScheme(.light)
//    }
//}

#Preview {
    ContentView()
}
