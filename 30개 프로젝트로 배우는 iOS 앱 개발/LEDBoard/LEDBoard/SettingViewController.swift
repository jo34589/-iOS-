//
//  SettingViewController.swift
//  LEDBoard
//
//  Created by 엔나루 on 2022/03/06.
//

import UIKit

protocol LEDBoardSettingDelegate: AnyObject {
    func changedSetting(text: String?, textColor: UIColor, backgroundColor: UIColor)
}

class SettingViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blackButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var orangeButton: UIButton!
    
    
    weak var delegate: LEDBoardSettingDelegate?
    
    var ledText: String?
    var textColor: UIColor = UIColor.yellow
    var backGroundColor: UIColor = UIColor.black
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        // Do any additional setup after loading the view.
    }
    
    //여러 버튼을 한 액션 함수에 연결했음
    //sender 를 통해서 어느 버튼인 지 구분할 수 있음
    @IBAction func tapTextColorButton(_ sender: UIButton) {
        if sender == self.yellowButton {
            self.changeTextColor(color: UIColor.yellow)
            self.textColor = .yellow
        } else if sender == self.purpleButton {
            self.changeTextColor(color: UIColor.purple)
            self.textColor = .purple
        } else if sender == self.greenButton {
            self.changeTextColor(color: UIColor.green)
            self.textColor = .green
        } else {
            return
        }
            
    }
    
    @IBAction func tapBackgroundColorButton(_ sender: UIButton) {
        if sender == self.blackButton {
            self.changeBackgroundColor(color: UIColor.black)
            self.backGroundColor = .black
        } else if sender == self.blueButton {
            self.changeBackgroundColor(color: UIColor.blue)
            self.backGroundColor = .blue
        } else if sender == self.orangeButton {
            self.changeBackgroundColor(color: UIColor.orange)
            self.backGroundColor = .orange
        } else {
            return
        }
    }
    
    @IBAction func tapSaveButton(_ sender: Any) {
        self.delegate?.changedSetting(
            text: self.textField.text,
            textColor: self.textColor,
            backgroundColor: self.backGroundColor)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func changeTextColor(color: UIColor) {
        self.yellowButton.alpha = color == UIColor.yellow ? 1 : 0.2
        self.purpleButton.alpha = color == UIColor.purple ? 1 : 0.2
        self.greenButton.alpha = color == UIColor.green ? 1 : 0.2
    }
    
    private func changeBackgroundColor(color: UIColor) {
        self.blackButton.alpha = color == UIColor.black ? 1 : 0.2
        self.blueButton.alpha = color == UIColor.blue ? 1 : 0.2
        self.orangeButton.alpha = color == UIColor.orange ? 1 : 0.2
    }
    
    private func configureView() {
        if let ledText = ledText {
            self.textField.text = ledText
        }
        self.changeTextColor(color: self.textColor)
        self.changeBackgroundColor(color: self.backGroundColor)
    }
}
