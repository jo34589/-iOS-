//
//  Content.swift
//  NetflixStSample
//
//  Created by 엔나루 on 2022/04/25.
//

import UIKit
//콜렉션 뷰 구조를 plist 로 관리하는 경우.
struct Content: Decodable {
    let sectionType: SectionType
    let sectionName: String
    let contentItem: [Item]
    
    
    enum SectionType: String, Decodable {
        case basic
        case main
        case large
        case rank
    }
}

struct Item: Decodable {
    let description: String
    let imageName: String
    
    var image: UIImage {
        return UIImage(named: imageName) ??  UIImage()
    }
}
