//
//  StaticsView.swift
//  withdesign
//
//  Created by 임유리 on 8/23/25.
//

import SwiftUI

// MARK: 맨 왼쪽 뷰 - 통계 관련 뷰
struct StaticsView: View {
    var body: some View {
        ScrollView{
            VStack{
                Text(" ")
                
                HStack(alignment: .center) {
                    Text("한 문장 속 모르는 단어 수")
                        .font(.system(size: 20))
                        .bold()
                        .lineLimit(1)
                    Spacer()
                    Text("1.43개")
                        //.frame(maxWidth: .infinity, alignment: .trailing)
                        .fontWeight(.black)
                        .foregroundStyle(Color("Orange"))
                        .font(.system(size: 28))
                }.padding(.horizontal, 12)
                Image("Graph")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 12)
                
                Divider().padding(.vertical, 6)
                
                HStack(alignment: .center) {
                    Text("학습 단어 수")
                        .font(.system(size: 20))
                        .bold()
                    Spacer()
                    Text("187개")
                        .fontWeight(.black)
                        .foregroundStyle(Color("Orange"))
                        .font(.system(size: 28))
                }.padding(.horizontal, 12)
                    .padding(.bottom, 0.2)
                Text("(상위 3.7%)")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal, 12)
                    .font(.system(size: 14))

                Divider().padding(.vertical, 6)
                
                HStack(alignment: .center) {
                    Text("읽은 포스트 수")
                        .font(.system(size: 20))
                        .bold()
                    Spacer()
                    Text("213개")
                        .fontWeight(.black)
                        .foregroundStyle(Color("Orange"))
                        .font(.system(size: 28))
                }.padding(.horizontal, 12)
                    .padding(.bottom, 0.2)
                Text("(상위 5.3%)")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal, 12)
                    .font(.system(size: 14))
                
                Divider().padding(.vertical, 6)
                
                HStack(alignment: .center) {
                    Text("학습 기록")
                        .font(.system(size: 20))
                        .bold()
                    Spacer()
                    Text("87일차")
                        .fontWeight(.black)
                        .foregroundStyle(Color("Orange"))
                        .font(.system(size: 28))
                }.padding(.horizontal, 12)
                Image("Grace")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 12)
                
                //Divider().padding(.vertical, 6)
                //Text("토익 RC Score 420점의 수준이예요")
            }
            .padding(.horizontal, 12)
        }
    }
}

struct StaticsView_Previews: PreviewProvider {
    static var previews: some View {
        StaticsView()
    }
}
