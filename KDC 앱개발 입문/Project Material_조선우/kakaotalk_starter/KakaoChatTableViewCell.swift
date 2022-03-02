//
//  KakaoChatTableViewCell.swift
//  Twitter_starter
//
//  Created by James Kim on 7/27/20.
//  Copyright © 2020 James Kim. All rights reserved.
//

import UIKit

class KakaoChatTableViewCell: UITableViewCell {
    /*
     TODO: senderImageView, nameLabel, lastMessageLabel, lastSentDateLabel를 만들어서 outlet으로 추가해주세요.
     */
    
    @IBOutlet weak var senderImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastMessagelabel: UILabel!
    @IBOutlet weak var lastSentDateLabel: UILabel!
    
    
    func configure(message: Message) {
        /*
         TODO: Cell이 생성되는 시점에서 메세지를 불러 렌더링해주세요
         
         예를들어..
         senderImageView.image = message.senderImage
         */
        self.senderImageView.layer.cornerRadius = 10
        self.senderImageView.layer.masksToBounds = true
        self.senderImageView.image = message.senderImage
        self.nameLabel.text = message.senderName
        self.lastMessagelabel.text = message.lastMessage
        self.lastSentDateLabel.text = message.lastSentDate
        
    }
}
