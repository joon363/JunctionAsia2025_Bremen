//
//  ContentView.swift
//  withdesign
//
//  Created by 임유리 on 8/23/25.
//
//

import SwiftUI

struct PostContentView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 50, height: 50)
                Text("NameNameName")
                    .font(.headline)
                Spacer()
            }
            .padding(.horizontal)
            
            Text("Lord is simply dummy text of the printing and typesetting industry. Island has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type.")
                .font(.body)
                .padding(.horizontal)
            Spacer()
        }
        .padding(.vertical, 20)
        .background(Color(red: 255/255, green: 245/255, blue: 220/255))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct PostCardView: View {
    @State private var pageIndex = 0
    
    private let topBarHeight: CGFloat = 56
    private let tabBarHeight: CGFloat = 49
    
    var body: some View {
        GeometryReader { proxy in
            let topPadding = proxy.safeAreaInsets.top + topBarHeight
            let bottomPadding = proxy.safeAreaInsets.bottom + tabBarHeight
            
            ZStack(alignment: .bottom) {
                TabView(selection: $pageIndex) {
                    VStack {
                        Spacer(minLength: 0)
                        Text("This is an\ninteresting title.")
                            .font(.system(size: 36, weight: .semibold))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                        Spacer(minLength: 0)
                    }
                    .background(bgColor)
                    .tag(0)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 36, height: 36)
                            Text("NameNameName")
                                .font(.headline)
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        Divider().padding(.horizontal)
                        
                        Text("""
                            Lord is simply dummy text of the printing and typesetting industry. Island has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type.
                            """)
                        .font(.body)
                        .padding(.horizontal)
                        
                        Spacer(minLength: 0)
                    }
                    .padding(.vertical, 20)
                    .background(bgColor)
                    .tag(1)
                    
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .automatic))
                
                HStack(spacing: 6) {
                    Circle().fill(pageIndex == 0 ? Color.primary : Color.primary.opacity(0.25))
                        .frame(width: 6, height: 6)
                    Circle().fill(pageIndex == 1 ? Color.primary : Color.primary.opacity(0.25))
                        .frame(width: 6, height: 6)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(.ultraThinMaterial, in: Capsule())
                .padding(.bottom, bottomPadding + 8) // Use the calculated bottom padding
            }
            // Use the parent's frame directly to fill the space
            .frame(width: proxy.size.width, height: proxy.size.height)
            .padding(.top, topPadding) // Apply the calculated top padding
            .padding(.bottom, bottomPadding) // Apply the calculated bottom padding
        }
    }
    
    private var bgColor: Color {
        Color(red: 1, green: 245/255, blue: 220/255)
    }
}

//struct PageDots: View {
//    let count: Int
//    let index: Int
//
//    var body: some View {
//        HStack(spacing: 6) {
//            ForEach(0..<count, id: \.self) { i in
//                Circle()
//                    .fill(i == index ? Color.green : Color.green.opacity(0.25))
//                    .frame(width: 6, height: 6)
//            }
//        }
//        .padding(.horizontal, 10)
//        .padding(.vertical, 6)
//        .background(.ultraThinMaterial, in: Capsule())
//    }
//}


struct StudyTabView: View {
    private let postCount = 5
    @State private var currentIndex: Int? = 0
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                ForEach(0..<postCount, id: \.self) { _ in
                    PostCardView()
                        .containerRelativeFrame(.vertical) // 한 화면씩 딱
                }
            }
            .scrollTargetLayout()
        }
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $currentIndex)
        .onAppear { currentIndex = 0 }
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
                    
                    StudyTabView()
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
