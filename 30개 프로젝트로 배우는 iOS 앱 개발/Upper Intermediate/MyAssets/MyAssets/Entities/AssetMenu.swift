//
//  AssetMenu.swift
//  MyAssets
//
//  Created by 엔나루 on 2022/04/27.
//

import Foundation

enum AssetMenu: String, Identifiable, Decodable {
    case creditScore
    case bankAccount
    case investment
    case loan
    case insurance
    case creditCard
    case cash
    case realEstate
    
    var id: String {
        return self.rawValue
    }
    
    var systemImageName: String {
        switch self {
        case .creditScore:
            return "number.circle"
        case .bankAccount:
            return "banknote"
        case .investment:
            return "bitcoinsign.circle"
        case .loan:
            return "hands.sparkles"
        case .insurance:
            return "lock.shield"
        case .creditCard:
            return "creditcard"
        case .cash:
            return "dollarsign.circle"
        case .realEstate:
            return "house.fill"
        }
    }
    
    var title: String {
        switch self {
        case .creditScore:
            return "신용 점수"
        case .bankAccount:
            return "계좌"
        case .investment:
            return "투자"
        case .loan:
            return "대출"
        case .insurance:
            return "보험"
        case .creditCard:
            return "신용카드"
        case .cash:
            return "현금"
        case .realEstate:
            return "부동산"
        }
    }
}
