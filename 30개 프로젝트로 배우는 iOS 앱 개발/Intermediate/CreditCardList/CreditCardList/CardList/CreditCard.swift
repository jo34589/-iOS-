//
//  CreditCard.swift
//  CreditCardList
//
//  Created by 엔나루 on 2022/04/11.
//

import Foundation

struct CreditCard: Codable {
    let id: Int
    let rank: Int
    let name: String
    let cardImageURL: String
    let promotionDetail: PromotionDetail
    let isSelected: Bool?
}

struct PromotionDetail: Codable {
    let companyName: String
    let amount: Int
    let period: String
    let condition: String
    let benefitDate: String
    let benefitDetail: String
    let benefitCondition: String
}
