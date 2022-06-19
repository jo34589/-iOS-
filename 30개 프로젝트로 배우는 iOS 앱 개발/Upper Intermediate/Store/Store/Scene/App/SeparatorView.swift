//
//  SeparatorView.swift
//  Store
//
//  Created by 엔나루 on 2022/05/13.
//

import UIKit
import SnapKit

//셀이 구분된 것 처럼 보이기 위한 구분선 뷰

final class SeparatorView: UIView {
    private lazy var separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = .separator
        return separator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //add and customize subviews
        
        addSubview(separator)
        separator.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.top.equalToSuperview()
            $0.height.equalTo(0.5)
            
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
