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
                Text("  ")
                Text("  ")
                
                Image("Grace")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
}
