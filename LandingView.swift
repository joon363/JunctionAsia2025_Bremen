//
//  LandingView.swift
//  junction2025
//
//  Created by minn on 2025/8/23.
//

import SwiftUI
import Flow

@main
struct MyApp: App {
   var body: some Scene {
      WindowGroup {
         FirstView()
      }
   }
}

struct FirstView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Image("logo")
                    .resizable()
                    .frame(width: 360, height: 360)
                    .padding(.top, 50)
                Text("Enjoy every fandom,\nnow in English.")
                    .padding(.top, -50)
                    .font(.system(size: 26))
                    .fontWeight(.medium)
                    .foregroundColor(Color("Navy"))
                    .multilineTextAlignment(.center)
                Divider().opacity(0).frame(height: 24)
                NavigationLink(destination: SecondView()) {
                    Text("시작하기")
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                        .padding(.horizontal, 24)
                        .background(Color("CustomOrange"))
                        .cornerRadius(20)
                }
                .padding(.bottom, 12)
                .padding()
                Spacer()
            }
        }
    }
}

struct Interest: Identifiable {
    let id = UUID()
    let name: String
    var isSelected: Bool = false // Tracks if the user has tapped it
}

struct SecondView: View {
    @State private var selectedButton: Int? = nil
    @Environment(\.dismiss) var dismiss
    var interestNames = [
        "Travel", "Photos", "Health", "Movies", "Art",
        "Gaming", "Music", "Cooking", "Reading", "Hiking", "Humor",
        "K-Pop", "Racing", "Animations", "Drama", "Beauty",
        "Technology", "Finance", "Cryptocurrency", "MBTI",
        "Sports", "AI", "Pet", "Science", "Politics", "Art",
        "Cat", "Baseball", "Programming", "Psychology", "Astronomy", 
        "Movie", "NFT", "Studying"
    ]
    @State private var interests: [Interest]
    init() {
        interestNames.shuffle()
        _interests = State(initialValue: interestNames.map { Interest(name: $0) })
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(spacing: 5) {
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: 120, height: 6)
                        .foregroundColor(Color("CustomOrange"))
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: 120, height: 6)
                        .foregroundColor(Color("Ivory"))
                }
                .padding(.top, 6)
                .padding(.bottom, 12)
                HStack{
                    Text("1")
                        .font(.system(size: 16))
                        .fontWeight(.black)
                        .foregroundColor(.white)
                        .background(
                            Circle()
                                .foregroundColor(Color("CustomOrange"))
                                .frame(width: 28, height: 28)
                        )
                        .padding(.trailing, 12)
                    Text("관심사 선택")
                        .font(.system(size: 20))
                        .bold()
                }
                Divider().padding(.bottom, 12)
                
                ScrollView {
                    Text("관심사에 맞는 포스트를 보여드릴게요.")
                        .font(.system(size: 16))
                    Divider().padding(.vertical, 12)
                    
                    HFlow(alignment: .center, itemSpacing: 10, rowSpacing: 10) {
                        ForEach(interests.indices, id: \.self) { index in
                            Text(interests[index].name)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20) // Padding now defines the size around the text
                            // REMOVED: .frame(maxWidth: .infinity)
                                .background {
                                    if interests[index].isSelected {
                                        Capsule().fill(Color("CustomOrange"))
                                    } else {
                                        Capsule().stroke(Color("Navy"), lineWidth: 1)
                                    }
                                }
                                .foregroundStyle(interests[index].isSelected ? .white : Color("Navy"))
                                .onTapGesture {
                                    interests[index].isSelected.toggle()
                                }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                }
                
                Spacer()
                
                NavigationLink(destination: ThirdView()) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("CustomOrange")) // Color("CustomOrange") 대신 사용
                        .frame(height: 60) // 버튼 높이 설정
                        .overlay(
                            Text("다음")
                                .bold()
                                .foregroundColor(.white)
                        )
                        .frame(maxWidth: .infinity) // 버튼의 너비를 가능한 한 최대화
                        .padding(.horizontal) // 좌우 여백 추가
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 12)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Welcome!")
                    .font(.system(size: 20))
                    .bold()
                    .foregroundColor(Color("CustomOrange"))
//                    .shadow(color: ColorColor("CustomOrange").opacity(0.5), radius: 15, x: 0, y: 0)
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(Color("CustomOrange"))
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct InlineHighlightView: View {
    @State private var selectedIndices: Set<Int> = []
    let wordItems: [WordItem]

    struct WordItem: Identifiable {
        let id = UUID()
        let token: String   // now every chunk (word or punctuation) is a token
    }

    var body: some View {
        ScrollView {
            HFlow(alignment: .center, itemSpacing: -5, rowSpacing: 8) {
                ForEach(Array(wordItems.enumerated()), id: \.1.id) { idx, item in
                    Text(item.token)
                        .font(.system(size: 18))
                        .background(selectedIndices.contains(idx) ? Color.yellow.opacity(0.5) : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .cornerRadius(4)
                        .onTapGesture {
                            if selectedIndices.contains(idx) {
                                selectedIndices.remove(idx)
                            } else {
                                selectedIndices.insert(idx)
                            }
                        }
                }
            }
            .padding()
        }
    }
}

// Tokenizer: just split into tokens, every non-whitespace substring is a highlightable chunk.
func tokenizeSimple(_ text: String) -> [InlineHighlightView.WordItem] {
    let pattern = #"\S+"#   // matches any non-whitespace sequence
    let regex = try! NSRegularExpression(pattern: pattern)
    let nsString = text as NSString
    let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
    return results.map {
        let token = nsString.substring(with: $0.range)
        return InlineHighlightView.WordItem(token: token)
    }
}


struct ThirdView: View {
    @State private var selectedButton: Int? = nil
    @Environment(\.dismiss) var dismiss
    var paragraph: String = "Education plays a vital role in the development of any nation. It not only equips individuals with knowledge and skills but also fosters critical thinking and innovation. A well-educated population contributes to economic growth, social stability, and better health outcomes. However, access to quality education remains a challenge in many parts of the world due to financial, geographical, and social barriers. Governments and communities must work together to ensure that education opportunities are inclusive and equitable for all."
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(spacing: 5) {
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: 120, height: 6)
                        .foregroundColor(Color("CustomOrange"))
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: 120, height: 6)
                        .foregroundColor(Color("CustomOrange"))
                }
                .padding(.top, 6)
                .padding(.bottom, 12)
                HStack{
                    Text("2")
                        .font(.system(size: 16))
                        .fontWeight(.black)
                        .foregroundColor(.white)
                        .background(
                            Circle()
                                .foregroundColor(Color("CustomOrange"))
                                .frame(width: 28, height: 28)
                        )
                        .padding(.trailing, 12)
                    Text("레벨 테스트")
                        .font(.system(size: 20))
                        .bold()
                }
                Divider().padding(.bottom, 12)
                
                ScrollView {
                    Text("모르는 단어를 탭해서 체크해주세요.")
                        .font(.system(size: 16))
                    Divider().padding(.vertical, 12)
                        
                    InlineHighlightView(wordItems: tokenizeSimple(paragraph))
                }
                
                Spacer()
                
                NavigationLink(destination: FourthView()) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("CustomOrange"))
                        .frame(height: 60) // 버튼 높이 설정
                        .overlay(
                            Text("제출하기")
                                .bold()
                                .foregroundColor(.white)
                        )
                        .frame(maxWidth: .infinity) // 버튼의 너비를 가능한 한 최대화
                        .padding(.horizontal) // 좌우 여백 추가
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 12)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Welcome!")
                    .font(.system(size: 20))
                    .bold()
                    .foregroundColor(Color("CustomOrange"))
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(Color("CustomOrange"))
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct FourthView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Image("logo")
                    .resizable()
                    .frame(width: 360, height: 360)
                    .padding(.top, 50)
                Text("Let's start learning now!")
                    .padding(.top, -50)
                    .font(.system(size: 24))
                    .fontWeight(.medium)
                    .foregroundColor(Color("Navy"))
                    .multilineTextAlignment(.center)
                Divider().opacity(0).frame(height: 24)
                NavigationLink(destination: ContentView()) {
                    Text("시작하기")
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                        .padding(.horizontal, 24)
                        .background(Color("CustomOrange"))
                        .cornerRadius(20)
                }
                .padding(.bottom, 12)
                .padding()
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    FirstView()
}
