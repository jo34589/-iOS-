//
//  ContentCollectionViewHeader.swift
//  NetflixStSample
//
//  Created by 엔나루 on 2022/04/25.
//

import UIKit
import SnapKit

//헤더,푸터를 위한 클래스
class ContentCollectionViewHeader: UICollectionReusableView {
    let sectionNameLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        sectionNameLabel.font = .systemFont(ofSize: 17, weight: .bold)
        sectionNameLabel.textColor = .white
        sectionNameLabel.sizeToFit()
        
        addSubview(sectionNameLabel)
        
        sectionNameLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.top.bottom.leading.equalToSuperview().offset(10)
            
        }
    }
    
}
 
