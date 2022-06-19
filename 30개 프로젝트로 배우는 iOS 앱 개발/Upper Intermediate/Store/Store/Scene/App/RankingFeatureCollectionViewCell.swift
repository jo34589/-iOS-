//
//  RankingFeatureCollectionViewCell.swift
//  Store
//
//  Created by 엔나루 on 2022/05/17.
//

import UIKit
import SnapKit

class RankingFeatureCollectionViewCell: UICollectionViewCell {
    
    //왜 클로저로 설정할까
    static var height: CGFloat { 70.0 }
    
    private lazy var appIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 7.0
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.separator.cgColor
            
        imageView.backgroundColor = .tertiarySystemBackground
            
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("받기", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13.0, weight: .bold)
        button.backgroundColor = .secondarySystemBackground
            
        return button
    }()
    
    private lazy var purchaseLabel: UILabel = {
        let label = UILabel()
        label.text = "앱 내 구입"
        label.font = .systemFont(ofSize: 10, weight: .semibold)
        label.textColor = .secondaryLabel
        return label
    }()
    
    func setup() {
        setupLayout()
        
        //titleLabel.text
        //descriptionLabel.text
        //purchaseLabel.isHidden
    }
}

private extension RankingFeatureCollectionViewCell {
    func setupLayout() {
        [
            appIconImageView,
            titleLabel,
            descriptionLabel,
            downloadButton,
            purchaseLabel
        ].forEach {
            addSubview($0)
        }
        
        appIconImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(4)
            $0.leading.equalToSuperview().inset(16)
            $0.width.equalTo(appIconImageView.snp.height)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalTo(appIconImageView.snp.trailing).offset(8)
            $0.trailing.equalTo(downloadButton.snp.leading).offset(8)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading).offset(4)
            $0.trailing.equalTo(downloadButton.snp.leading).offset(8)
        }
        
        downloadButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(50)
            $0.height.equalTo(24)
        }
        
        purchaseLabel.snp.makeConstraints {
            $0.centerX.equalTo(downloadButton)
            $0.top.equalTo(downloadButton.snp.bottom).offset(4)
        }
    }
}


