//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by 엔나루 on 2022/03/13.
//

import UIKit

class DiaryDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    //표시할 값을 전달받을 프로퍼티
    var diary: Diary?
    //수정, 삭제를 위한 것인가 봄.
    var indexPath: IndexPath?
    //즐겨찾기 기능
    var starButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(starDiaryNoti(_:)),
            name: NSNotification.Name("starDiary"),
            object: nil)
    }
    
    private func configureView() {
        guard let diary = self.diary  else { return }
        self.titleLabel.text = diary.title
        self.contentsTextView.text = diary.contents
        self.dateLabel.text = dateToString(diary.date)
        self.starButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(tapStarButton))
        self.starButton?.image = diary.isStar ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        self.starButton?.tintColor = .orange
        self.navigationItem.rightBarButtonItem = self.starButton
    }
    
    @IBAction func tapEditButton(_ sender: UIButton) {
        guard let writeDiaryVC = self.storyboard?.instantiateViewController(withIdentifier: "WriteDiaryViewController") as? WriteDiaryViewController else {return}
        guard let indexPath = self.indexPath else { return }
        guard let diary = self.diary else { return }
        writeDiaryVC.diaryEditMode = .edit(indexPath, diary)
        //notification observing
        //파라미터: 어느 객체에서 observe?, 그때 실행할 함수, observe할 이름
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(editDiaryNoti(_:)),
            name: NSNotification.Name("editDiary"),
            object: nil)
        
        self.navigationController?.pushViewController(writeDiaryVC, animated: true)
        
    }
    
    @IBAction func tapDeleteButton(_ sender: UIButton) {
        guard let uuidString = self.diary?.uuidString else { return }
        NotificationCenter.default.post(name: NSNotification.Name("deleteDiary"), object: uuidString)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    //수정 기능 중 notificationcenter를 위한 objc 함수
    @objc func editDiaryNoti(_ noti: Notification) {
        //수정된 diary 객체를 가져옴
        guard let diary = noti.object as? Diary else { return }
        
        self.diary = diary
        self.configureView()
    }
    @objc func starDiaryNoti(_ noti: Notification) {
        guard let starDiary = noti.object as? [String:Any] else { return }
        guard let isStar = starDiary["isStar"] as? Bool else { return }
        guard let uuidString = starDiary["uuidString"] as? String else { return }
        guard let diary = self.diary else { return }
        if diary.uuidString == uuidString {
            self.diary?.isStar = isStar
            self.configureView()
        }
    }
    
    
    //star button toggle
    @objc func tapStarButton() {
        guard let isStar = self.diary?.isStar else { return }
        
        if isStar {
            self.starButton?.image = UIImage(systemName: "star")
        } else {
            self.starButton?.image = UIImage(systemName: "star.fill")
        }
        self.diary?.isStar.toggle()
        //딜리게이트를 사용하면 일대일 전달밖에 되지 않으므로.
        //self.delegate?.didSelectStar(indexPath: indexPath, isStar: self.diary?.isStar ?? false)
        NotificationCenter.default.post(
            name: NSNotification.Name("starDiary"),
            object: [
                "diary": self.diary!,
                "isStar":self.diary?.isStar ?? false,
                "uuidString" : self.diary?.uuidString])
                     
    }
    
    private func dateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy 년 MM 월 dd 일 (EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

