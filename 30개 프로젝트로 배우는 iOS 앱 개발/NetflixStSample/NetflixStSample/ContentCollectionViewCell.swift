//
//  ContentCollectionViewCell.swift
//  NetflixStSample
//
//  Created by 엔나루 on 2022/04/25.
//

import UIKit
import SnapKit

class ContentCollectionViewCell: UICollectionViewCell {
    let imageView = UIImageView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //갑자기 contentView가 어디서 나왔는가.
        //self.backgroundColor 를 써도 표시되지 않는다.
        //Cell < contentView < Subview 로 구조화 되어 있음
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        
        contentView.addSubview(imageView)
        
        //snapkit
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            
        }
    }
}
