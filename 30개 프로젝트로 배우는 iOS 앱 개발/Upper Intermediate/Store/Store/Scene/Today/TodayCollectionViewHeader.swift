//
//  TodayCollectionViewHeader.swift
//  Store
//
//  Created by 엔나루 on 2022/05/11.
//

import UIKit
import SnapKit

final class TodayCollectionViewHeader: UICollectionReusableView {
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        let formatter = DateFormatter()
        formatter.dateFormat = "M 월 d 일 EEEE"
        label.text = formatter.string(from: Date())
        label.font = .systemFont(ofSize: 24.0, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "투데이"
        label.font = .systemFont(ofSize: 36.0, weight: .black)
        label.textColor = .white
        return label
    }()
    
    func setupViews() {
        [dateLabel, titleLabel].forEach {
            addSubview($0)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(32)
            $0.leading.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(8)
            $0.leading.equalTo(dateLabel)
        }
    }
}
