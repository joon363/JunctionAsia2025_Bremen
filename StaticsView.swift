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
                Text("1.43개")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding()
                    .bold()
                    .foregroundStyle(Color("Orange"))
                    .font(.system(size: 32))
                Image("Graph")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 12)
                Text("  ")
                Text("  ")
                HStack {
                    Text("학습 단어 수")
                        .font(.system(size: 24))
                        .bold()
                    Spacer()
                    Text("187개")
                        .bold()
                        .foregroundStyle(Color("Orange"))
                        .font(.system(size: 32))
                    
                }.padding(.horizontal, 12)


                Text("(상위 3.7%)")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal, 12)

                Text("  ")
                Text("  ")
                HStack{
                    Text("읽은 포스트 수")
                        .font(.system(size: 24))
                        .bold()

                    Spacer()
                    Text("213개")
                        .bold()
                        .foregroundStyle(Color("Orange"))
                        .font(.system(size: 32))


                }.font(.system(size: 24))
                .padding(.horizontal, 12)


                Text("(상위 5.3%)")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal, 12)
                
                Text("  ")

                Image("Grace")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 12)
                Text("  ")
                Text("토익 RC Score 420점의 수준이예요")
            }
        }
    }
}
struct StaticsView_Previews: PreviewProvider {
    static var previews: some View {
        StaticsView()
    }
}
