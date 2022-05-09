//
//  TabMenuView.swift
//  MyAssets
//
//  Created by 엔나루 on 2022/05/09.
//

import SwiftUI

struct TabMenuView: View {
    
    var tabs: [String]
    @Binding var selectedTab: Int
    @Binding var updated: CreditCardAmounts?
    
    var body: some View {
        HStack {
            ForEach(0 ..< tabs.count, id: \.self) { row in
                Button(action:{
                    selectedTab = row
                    UserDefaults.standard.set(true, forKey: "creditCardUpdateChecked")
                }, label: {
                    VStack(spacing: 0) {
                        HStack {
                            //원
                            if updated?.id == row {
                                let checked = UserDefaults.standard.bool(forKey: "creditCardUpdateChecked")
                                Circle()
                                    .fill(
                                        !checked
                                        ?
                                        Color.red : Color.clear
                                    )
                                    .frame(width: 6, height: 6)
                                    .offset(x: 2, y: -8)
                            } else {
                                Circle()
                                    .fill(Color.clear)
                                    .frame(width: 6, height: 6)
                                    .offset(x: 2, y: -8)
                            }
                            //타이틀
                            Text(tabs[row])
                                .font(.system(.headline))
                                .foregroundColor(
                                    selectedTab == row
                                    ? .accentColor
                                    : .gray
                                )
                                .offset(x: -4, y: 0)
                        }
                        .frame(height: 52)
                        Rectangle()
                            .fill(selectedTab == row
                                  ? Color.secondary
                                  : Color.clear
                            )
                            .frame(height: 3)
                            .offset(x: 4, y: 0)
                        
                        
                    }
                })
                    .buttonStyle(PlainButtonStyle())
            }
        }
        .frame(height: 52)
    }
}

struct TabMenuView_Previews: PreviewProvider {
    static var previews: some View {
        TabMenuView(tabs: ["지난달 결제", "이번달 결제", "다음달 결제"], selectedTab: .constant(1), updated: .constant(.currentMonth(amount: "1만원")))
    }
}
