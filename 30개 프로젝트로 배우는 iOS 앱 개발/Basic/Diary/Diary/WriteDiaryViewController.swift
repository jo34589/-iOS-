//
//  WriteDiaryViewController.swift
//  Diary
//
//  Created by 엔나루 on 2022/03/13.
//

import UIKit

enum DiaryEditMode {
    case new
    //enum의 연관값들을 전달
    case edit(IndexPath, Diary)
}

protocol WriteDiaryViewDelegate: AnyObject {
    func didSelectRegister(diary: Diary)
}

class WriteDiaryViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    
    private let datePicker = UIDatePicker()
    private var diaryDate: Date?
    weak var delegate: WriteDiaryViewDelegate?
    var diaryEditMode: DiaryEditMode = .new
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureContentsTextView()
        configureDatePicker()
        self.confirmButton.isEnabled = false
        configureInputField()
        configureEditMode()
    }
    
    //수정된 내용을 전달할 notification center
    //notification center는 등록된 이벤트가 발생하면 해당 이벤트에 대한 행동을 취하는 곳.
    //앱 내에서 아무데서나 메시지를 던지면 아무데서나 메시지를 받을 수 있게 해줌.
    //쉽게 말해 이벤트 버스
    //post(보내기) -> observe(받기)
    @IBAction func tapConfirmButton(_ sender: UIBarButtonItem) {
        guard let title = self.titleTextField.text else {return}
        guard let contents = self.contentsTextView.text else {return}
        guard let date = self.diaryDate else {return}
        
        
        
        switch self.diaryEditMode {
        case .new:
            let diary = Diary(
                uuidString: UUID().uuidString,
                title: title,
                contents: contents,
                date: date,
                isStar: false)
            self.delegate?.didSelectRegister(diary: diary)
            
        case let .edit(indexPath, diary):
            let diary = Diary(
                uuidString: UUID().uuidString,
                title: title,
                contents: contents,
                date: date,
                isStar: diary.isStar)
            NotificationCenter.default.post(
                name: NSNotification.Name("editDiary"),
                object: diary, //NotificationCenter를 통해 전달할 객체
                userInfo: nil)
        }
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    private func configureEditMode() {
        switch self.diaryEditMode {
        case let .edit(_, diary):
            self.titleTextField.text = diary.title
            self.contentsTextView.text = diary.contents
            self.dateTextField.text = dateToString(diary.date)
            self.diaryDate = diary.date
            self.confirmButton.title = "수정"
        case .new:
            ()
        }
    }
    
    
    //텍스트뷰 설정(테두리)
    private func configureContentsTextView() {
        let borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        self.contentsTextView.layer.borderColor = borderColor.cgColor
        self.contentsTextView.layer.borderWidth = 0.5
        self.contentsTextView.layer.cornerRadius = 5.0
    }
    
    //datePicker 설정
    private func configureDatePicker() {
        self.datePicker.datePickerMode = .date
        self.datePicker.preferredDatePickerStyle = .wheels
        self.datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged)
        self.dateTextField.inputView = self.datePicker
        self.datePicker.locale = Locale(identifier: "ko_KR")
    }
    
    //datePicker 값이 변경될 때 마다 호출될 함수
    @objc func datePickerValueDidChange(_ datePicker: UIDatePicker) {
        let formatter = DateFormatter()
        //E 다섯개: 요일 한글자
        formatter.dateFormat = "yyyy 년 MM 월 dd 일 (EEEEE)"
        //지역 설정
        formatter.locale = Locale(identifier: "ko_KR")
        self.diaryDate = datePicker.date
        self.dateTextField.text = formatter.string(from: datePicker.date)
        //날짜를 바꾸면 editingChanged 액션을 발생시키게 함.
        self.dateTextField.sendActions(for: .editingChanged)
    }
    
    //공백 터치에 키보드나 datePicker 등 입력창이 내려가도록
    //유저가 화면을 터치할 때 마다 실행됨
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //date 텍스트필드의 값이 변경되면 호출될 메소드
    @objc func dateTextFieldDidChange(_ textfield: UITextField) {
        self.validateInputField()
    }
    
    
    //타이틀 텍스트필드의 값이 변경될 때 마다 호출될 메소드
    @objc func titleTextFieldDidChange(_ textField: UITextField) {
        self.validateInputField()
    }
    
    //버튼을 활성화 할 조건을 확인하는 메소드
    private func validateInputField() {
        self.confirmButton.isEnabled = !(self.titleTextField.text?.isEmpty ?? true) && !(self.dateTextField.text?.isEmpty ?? true) && !(self.contentsTextView.text.isEmpty)
    }
    
    //여러 입력필드의 내부동작 설정
    private func configureInputField() {
        self.contentsTextView.delegate = self
        self.titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged)
        self.dateTextField.addTarget(self, action: #selector(dateTextFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func dateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy 년 MM 월 dd 일 (EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}

extension WriteDiaryViewController: UITextViewDelegate {
    //텍스트 뷰에 무언가 값이 변경될 때 마다 호출될 함수
    func textViewDidChange(_ textView: UITextView) {
        self.validateInputField()
    }
}
