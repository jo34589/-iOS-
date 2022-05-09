//
//  Asset.swift
//  MyAssets
//
//  Created by 엔나루 on 2022/04/28.
//

import Foundation
import SwiftUI

class Asset: Identifiable, Decodable, ObservableObject {
    let id: Int
    let type: AssetMenu
    let data: [AssetData]
    
    
    init(id: Int, type: AssetMenu, data: [AssetData]) {
        self.id = id
        self.type = type
        self.data = data
        
    }
}

class AssetData: Identifiable, Decodable, ObservableObject {
    let id: Int
    let title: String
    let amount: String
    let creditCardAmounts: [CreditCardAmounts]?
    
    init(id: Int, title: String, amount: String, creditCardAmounts: [CreditCardAmounts]? = nil) {
        self.id = id
        self.title = title
        self.amount = amount
        self.creditCardAmounts = creditCardAmounts
    }
}

//값을 가지는 enum 을 Identifiable, Decodable 할 수 있게 만들고 싶은 몸부림.
enum CreditCardAmounts: Identifiable, Decodable {
    case previousMonth(amont: String)
    case currentMonth(amount: String)
    case nextMonth(amount: String)
    
    //좋은 방법은 아니라고 하셨음.
    var id: Int {
        switch self {
        case .previousMonth:
            return 0
        case .currentMonth:
            return 1
        case .nextMonth:
            return 2
        }
    }
    
    var amount: String {
        switch self {
        case .previousMonth(let amount),
             .currentMonth(let amount),
             .nextMonth(let amount):
            return amount
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case previousMonth
        case currentMonth
        case nextMonth
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy:  CodingKeys.self)
        
        if let value = try? values.decode(String.self, forKey: .previousMonth) {
            self = .previousMonth(amont: value)
            return
        }
        
        if let value = try? values.decode(String.self, forKey: .currentMonth) {
            self = .currentMonth(amount: value)
            return
        }
        
        if let value = try? values.decode(String.self, forKey: .nextMonth) {
            self = .nextMonth(amount: value)
            return
        }
        
        throw fatalError("ERROR: CreditCardAmounts JSON decoding error")
    }
    
}
