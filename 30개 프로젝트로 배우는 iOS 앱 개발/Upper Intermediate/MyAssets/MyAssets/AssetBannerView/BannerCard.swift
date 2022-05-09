//
//  BannerCard.swift
//  MyAssets
//
//  Created by 엔나루 on 2022/04/27.
//

import SwiftUI

struct BannerCard: View {
    
    let banner: AssetBanner
    
    var body: some View {
        Color(banner.backgroundColor)
            .overlay(content: {
                VStack {
                    Text(banner.title)
                        .font(.title)
                    Text(banner.description)
                        .font(.subheadline)
                }
            })
    }
}

struct BannerCard_Previews: PreviewProvider {
    static var previews: some View {
        let banner0 = AssetBanner(title: "타이틀", description: "설명입니다", backgroundColor: UIColor.magenta)
        BannerCard(banner: banner0)
    }
}
