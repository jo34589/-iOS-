//
//  Alert.swift
//  DrinkWater
//
//  Created by 엔나루 on 2022/04/16.
//

import Foundation

struct Alert: Codable {
    var id: String = UUID().uuidString
    let date: Date
    var isOn: Bool
    
    var time: String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm"
        return timeFormatter.string(from: date)
    }
    
    var meridian: String {
        let meridianFormatter = DateFormatter()
        meridianFormatter.dateFormat = "a"
        meridianFormatter.locale = Locale(identifier: "ko")
        return meridianFormatter.string(from: date)
        
    }
}
