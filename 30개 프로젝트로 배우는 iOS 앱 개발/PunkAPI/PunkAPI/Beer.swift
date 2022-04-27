//
//  Beer.swift
//  PunkAPI
//
//  Created by 엔나루 on 2022/04/26.
//

import Foundation

//read only
//optional property인 이유는 맥주에 따라 못 받을 수도 있기 때문
struct Beer: Decodable {
    let id: Int?
    let name, taglineString, description, brewersTips, imageURL: String?
    let foodPairing: [String]?
    
    //taglineString 을 정말 해시태그처럼 바꿔줄 것
    var tagline: String {
        let tag = taglineString?.components(separatedBy: ". ")
        let hashtag = tag?.map {
            "#" + $0.replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: ".", with: "")
                .replacingOccurrences(of: ",", with: " #")
            
        }
        return hashtag?.joined(separator: " ") ?? ""
        // #tag #good #spicy
    }
    
    //api 의 파라미터 값과 구조체의 프로퍼티 이름이 다른 경우가 존재하므로
    enum CodingKeys: String, CodingKey {
        case id, name, description
        case taglineString = "tagline"
        case imageURL = "image_url"
        case brewersTips = "brewers_tips"
        case foodPairing = "food_pairing"
    }
}
