//
//  ViewController.swift
//  LEDBoard
//
//  Created by 엔나루 on 2022/03/05.
//

import UIKit

class ViewController: UIViewController, LEDBoardSettingDelegate {

    @IBOutlet weak var contentsLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentsLabel.textColor = .yellow
        // Do any additional setup after loading the view.
    }

    func changedSetting(text: String?, textColor: UIColor, backgroundColor: UIColor) {
        if let text = text {
            self.contentsLabel.text = text
        }
        self.contentsLabel.textColor = textColor
        self.view.backgroundColor = backgroundColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let settingVC = segue.destination as? SettingViewController {
            settingVC.delegate = self
            settingVC.ledText = self.contentsLabel.text
            settingVC.textColor = self.contentsLabel.textColor
            settingVC.backGroundColor = self.view.backgroundColor ?? UIColor.black
        }
        
    }
}

