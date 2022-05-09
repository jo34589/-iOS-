//
//  AssetMenuButtonStyle.swift
//  MyAssets
//
//  Created by 엔나루 on 2022/04/27.
//

import SwiftUI

struct AssetMenuButtonStyle: ButtonStyle {
    
    let menu: AssetMenu
    
    func makeBody(configuration: Configuration) -> some View {
        return VStack {
            Image(systemName: menu.systemImageName)
                .resizable()
                .frame(width: 30, height: 30)
                .padding([.leading, .trailing], 10)
            Text(menu.title)
                .font(.system(size: 12, weight: .bold))
                
            
        }
        .padding()
        .foregroundColor(.blue)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

struct AssetMenuButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Button("") {
                print("")
            }
            .buttonStyle(AssetMenuButtonStyle(menu: AssetMenu.creditCard))
            Button("") {
                print("")
            }
            .buttonStyle(AssetMenuButtonStyle(menu: AssetMenu.insurance))
        }
        .background(Color.gray)
    }
}
