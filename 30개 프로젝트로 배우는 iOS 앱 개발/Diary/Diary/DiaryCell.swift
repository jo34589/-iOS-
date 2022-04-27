//
//  DiaryCell.swift
//  Diary
//
//  Created by 엔나루 on 2022/03/13.
//

import UIKit

class DiaryCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    //테두리 만들기
    //UIView가 XIB나 Storyboard 에서 생성이 될 때
    //이용되는 생성자.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.contentView.layer.cornerRadius = 3.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.black.cgColor
    }
    
}
