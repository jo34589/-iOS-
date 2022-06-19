//
//  AppViewController.swift
//  Store
//
//  Created by 엔나루 on 2022/05/11.
//

import UIKit
import SnapKit

//뷰 구조
/*
 UIScrollView {
    UIStackView {
        UIView {
            UICollectionView
        }
        UIView {
            UICollectionView
        }
    }
 }
 stackview 는 내부 컨텐트의 길이에 따라 스스로의 높이를 조절하는 뷰
 stackview 내부 컨텐트의 길이가 변경되도 높이를 계산할 필요 없이 자동으로 높이가 맞춰짐
 즉 scrollView 와 stackView를 써서 section이 있는 collectionView 처럼 구성한 것
 */

class AppViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        //뷰 각각의 높이가 다르기 때문에 간격만 동일하게
        stackView.distribution = .equalSpacing
        //하지만 간격을 없앰
        stackView.spacing = 0.0
        //서브뷰에 높이자유도를 줌
        
        //임시뷰들
        let featureSectionView = FeatureSectionView(frame: .zero)
        let rankingSectionView = RankingFeatureSectionView(frame: .zero)
        let exchangeCodeButtonView = UIView()
        
        [featureSectionView, rankingSectionView, exchangeCodeButtonView]
            .forEach {
                stackView.addArrangedSubview($0)
            }
        
        return stackView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        setupLayout()
    }
}

private extension AppViewController {
    func setupNavigationController() {
        navigationItem.title = "앱"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    func setupLayout() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            //모서리는 스크롤뷰에 맞추면서
            $0.edges.equalToSuperview()
            //너비를 고정시켜 가로스크롤이 일어나지 않게
            $0.width.equalToSuperview()
        }
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
