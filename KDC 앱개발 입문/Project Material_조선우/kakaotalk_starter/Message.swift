//
//  Message.swift
//  Twitter_starter
//
//  Created by James Kim on 7/27/20.
//  Copyright © 2020 James Kim. All rights reserved.
//

import UIKit

struct Message {
    let senderName: String
    let lastMessage: String
    let senderImageName: String
    let lastSentDate: String
    
    var senderImage: UIImage? {
        // TODO: Image를 주어진 senderImageName가지고 생성해주세요.
        return UIImage(named: senderImageName)
    }
    
    static var dummyList: [Message] {
        return [
            Message(senderName: "James", lastMessage: "어제 잘들어갔음???", senderImageName: "p2", lastSentDate: "2020/08/20"),
            Message(senderName: "김은지", lastMessage: "아니 도대체 무슨일이야 연락도 안되고... ", senderImageName: "p1", lastSentDate: "2020/08/20"),
            Message(senderName: "토니", lastMessage: "어제 집에가는데 사람을 만났어. 근데 그사람들이 너무 이상한거야.. 무슨말이냐면 말이지 나도 모르겠어", senderImageName: "p3", lastSentDate: "2020/07/19"),
            Message(senderName: "GOT7", lastMessage: "새로 나온 앨범이 너무 잘된다! 대박나자", senderImageName: "p4", lastSentDate: "2020/07/18"),
            Message(senderName: "Allen", lastMessage: "요새 iOS공부한다면서? 잘되고 있어??", senderImageName: "p5", lastSentDate: "2020/07/15"),
            Message(senderName: "유명배우", lastMessage: "iOS 개발자 사람 너무 없어 요새ㅠㅠ 개발자만 되도 취직 보장이다 무조건..", senderImageName: "p6", lastSentDate: "2020/07/10"),
            Message(senderName: "중국에서유명함", lastMessage: "공부만 너무 열심히 하는거 아니야? 나랑 대화좀 하자..", senderImageName: "p7", lastSentDate: "2020/07/08"),
            Message(senderName: "Christina", lastMessage: "실력이 너무 좋으셔서, 해외지사로 이직을 권해드리고 싶어요.", senderImageName: "p1", lastSentDate: "2020/06/10"),
            Message(senderName: "잘생긴친구", lastMessage: "주변얘 주식 대박났데.. 10억을 벌었다던데", senderImageName: "p3", lastSentDate: "2020/06/08"),
            Message(senderName: "주식하지마라", lastMessage: "주식하다가 골로간다..", senderImageName: "p4", lastSentDate: "2020/06/06"),

        ]
    }
}


