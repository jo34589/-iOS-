//
//  NavigationBarWithButton.swift
//  MyAssets
//
//  Created by 엔나루 on 2022/04/27.
//

import SwiftUI

struct NavigationBarWithButton: ViewModifier {
    
    var title: String = ""
    
    func body(content: Content) -> some View {
        return content
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Text(title)
                        .font(.system(size: 24, weight: .bold))
                    .padding()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("자산 추가 버튼 Tapped")
                    }, label: {
                        Image(systemName: "plus")
                        Text("자산 추가")
                            .font(.system(size: 18))
                            .padding(.trailing, 8)
                    })
                        .tint(.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.black)
                        )
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: {
                let appearance = UINavigationBarAppearance()
                appearance
                    .configureWithTransparentBackground()
                appearance.backgroundColor = UIColor(white: 1, alpha: 0.5)
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().compactAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
            })
    }
    
}

extension View {
    func navigationBarWithButtonStyle(_ title: String) -> some View {
        return self.modifier(NavigationBarWithButton(title: title))
    }
}

struct NavigationBarWithButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Color.gray.edgesIgnoringSafeArea(.all)
                .navigationBarWithButtonStyle("내 자산")
        }
.previewInterfaceOrientation(.portraitUpsideDown)
    }
}
