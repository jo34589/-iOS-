//
//  ContentCollectionViewMainCell.swift
//  NetflixStSample
//
//  Created by 엔나루 on 2022/04/25.
//

import UIKit
import SnapKit

class ContentCollectionViewMainCell: UICollectionViewCell {
    
    let baseStackView = UIStackView()
    let menuStackView = UIStackView()
    
    let tvButton = UIButton()
    let movieButton = UIButton()
    let categoryButton = UIButton()
    
    let imageView = UIImageView()
    let descriptionLabel = UILabel()
    let contentStackView = UIStackView()
    
    let plusButton = UIButton()
    let playButton = UIButton()
    let infoButton = UIButton()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        [baseStackView, menuStackView].forEach {
            contentView.addSubview($0)
            
        }
        
        //base stack view
        baseStackView.axis = .vertical
        baseStackView.alignment = .center
        baseStackView.distribution = .fillProportionally
        baseStackView.spacing = 5
        
        baseStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        [imageView, descriptionLabel, contentStackView].forEach {
            baseStackView.addSubview($0)
        }
        
        //imageView
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints {
            $0.width.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(imageView.snp.width)
        }
        
        //descriptionLabel
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.textColor = .white
        descriptionLabel.sizeToFit()
        
        //contentStackView
        contentStackView.axis = .horizontal
        contentStackView.alignment = .center
        contentStackView.distribution = .equalCentering
        contentStackView.spacing = 20
        contentStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(60)
        }
        [plusButton, playButton, infoButton].forEach {
            contentStackView.addArrangedSubview($0)
        }
        
        [plusButton, infoButton].forEach {
            $0.titleLabel?.font = .systemFont(ofSize: 13)
            $0.setTitleColor(.white, for: .normal)
            $0.imageView?.tintColor = .white
            var conf = $0.configuration
            conf?.imagePlacement = .top
            $0.configuration = conf
        }
        plusButton.setTitle("내가 찜한 콘텐츠", for: .normal)
        plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        plusButton.addTarget(self, action: #selector(plusButtonTapped(sender:)), for: .touchUpInside)
        
        infoButton.setTitle("정보", for: .normal)
        infoButton.setImage(UIImage(systemName: "info.circle"), for: .normal)
        infoButton.addTarget(self, action: #selector(infoButtonTapped(sender:)), for: .touchUpInside)
        
        playButton.setTitle("▶︎ 재생", for: .normal)
        playButton.setTitleColor(.black, for: .normal)
        playButton.backgroundColor = .white
        playButton.layer.cornerRadius = 3
        playButton.snp.makeConstraints {
            $0.width.equalTo(90)
            $0.height.equalTo(30)
        }
        playButton.addTarget(self, action: #selector(playButtonTapped(sender:)), for: .touchUpInside)
        
        //menu stack view
        menuStackView.axis = .horizontal
        menuStackView.alignment = .center
        menuStackView.distribution = .equalSpacing
        menuStackView.spacing = 20
        
        [tvButton, movieButton, categoryButton].forEach {
            menuStackView.addArrangedSubview($0)
            $0.setTitleColor(.white, for: .normal)
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 1
            $0.layer.shadowRadius = 3
        }
        
        tvButton.setTitle("TV 프로그램", for: .normal)
        movieButton.setTitle("영화", for: .normal)
        categoryButton.setTitle("카테고리 ▼", for: .normal)
        
        tvButton.addTarget(self, action: #selector(tvButtonTapped(sender:)), for: .touchUpInside)
        movieButton.addTarget(self, action: #selector(movieButtonTapped(sender:)), for: .touchUpInside)
        categoryButton.addTarget(self, action: #selector(categoryButtonTapped(sender:)), for: .touchUpInside)
        
        menuStackView.snp.makeConstraints {
            //그냥 baseStackView 라고 써도 같이 인식함
            $0.top.equalTo(baseStackView.snp.top)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
    }
    
    @objc func tvButtonTapped(sender: UIButton!) {
        print("TEST: TVButton Tapped")
    }
    @objc func movieButtonTapped(sender: UIButton!) {
        print("TEST: MovieButton Tapped")
    }
    @objc func categoryButtonTapped(sender: UIButton!) {
        print("TEST: CategoryButton Tapped")
    }
    @objc func plusButtonTapped(sender: UIButton!) {
        print("TEST: plusButton Tapped")
    }
    @objc func infoButtonTapped(sender: UIButton!) {
        print("TEST: infoButton Tapped")
    }
    @objc func playButtonTapped(sender: UIButton!) {
        print("TEST: playButton Tapped")
    }
}
