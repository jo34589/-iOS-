//
//  AssetBannerview.swift
//  MyAssets
//
//  Created by 엔나루 on 2022/04/28.
//

import SwiftUI

struct AssetBannerView: View {
    
    let bannerList: [AssetBanner] = [
        AssetBanner(title: "공지사항", description: "공지사항을 확인해 주세요", backgroundColor: .red),
        AssetBanner(title: "이벤트", description: "주말 특가 이벤트를 놓치지 마세요", backgroundColor: .yellow),
        AssetBanner(title: "깜짝 할인", description: "쿠폰도 드려요", backgroundColor: .blue),
        AssetBanner(title: "가을 프로모션", description: "새로운 카드 상품이 있어요", backgroundColor: .magenta),
    ]
    
    @State private var currentPage = 0
    
    var body: some View {
        let bannerCards = bannerList.map {
            BannerCard(banner: $0)
        }
        ZStack(alignment: .bottomTrailing) {
            PageViewController(pages: bannerCards, currentPage: $currentPage)
            PageControl(numberOfPages: bannerCards.count, currentPage: $currentPage)
                .frame(width: CGFloat(bannerCards.count)*18)
        }
    }
}

struct AssetBannerView_Previews: PreviewProvider {
    static var previews: some View {
        AssetBannerView()
            .aspectRatio(2.5, contentMode: .fit)
    }
}
