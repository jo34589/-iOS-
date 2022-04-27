//
//  NoticeViewController.swift
//  Notice
//
//  Created by 엔나루 on 2022/04/15.
//

import UIKit

class NoticeViewController: UIViewController {
    //내용을 메인 뷰에서 받아오기 때문
    var noticeContents: (title: String, detail: String, date: String)?
    
    @IBOutlet weak var noticeView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        noticeView.layer.cornerRadius = 6
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        guard let noticeContents = noticeContents else {
            return
        }
        
        self.titleLabel.text = noticeContents.title
        self.detailLabel.text = noticeContents.detail
        self.dateLabel.text = noticeContents.date
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
