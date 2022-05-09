//
//  RoundButton.swift
//  Calculator
//
//  Created by 엔나루 on 2022/03/06.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {

    @IBInspectable var isRound: Bool = false {
        didSet {
            if isRound {
                self.layer.cornerRadius = self.frame.height/2
            }
        }
    }
}
