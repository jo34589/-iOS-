//
//  UNNotificationCenter.swift
//  DrinkWater
//
//  Created by 엔나루 on 2022/04/17.
//

import Foundation
import UserNotifications

extension UNUserNotificationCenter {
    //알림을 추가하는 함수
    func addNotificationRequest(by alert: Alert) {
        //알림의 내용을 설정
        let content = UNMutableNotificationContent()
        content.title = "물 마실 시간이에요"
        content.body = "세계 보건 기구(WHO) 에서 권장하는 하루 물 섭취량은 1.5L 에서 2L 입니다."
        content.sound = .default
        content.badge = 1
        
        let dateComponent = Calendar.current.dateComponents([.hour, .minute], from: alert.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: alert.isON)
        
        
        let request = UNNotificationRequest(identifier: alert.id, content: content, trigger: trigger)
        
        self.add(request, withCompletionHandler: nil)
    }
}
