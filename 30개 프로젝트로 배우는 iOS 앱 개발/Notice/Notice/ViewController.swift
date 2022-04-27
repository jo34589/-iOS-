//
//  ViewController.swift
//  Notice
//
//  Created by 엔나루 on 2022/04/15.
//

import UIKit
import FirebaseRemoteConfig
import FirebaseAnalytics

class ViewController: UIViewController {
    
    var remoteConfig: RemoteConfig?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        remoteConfig = RemoteConfig.remoteConfig()
        
        let setting = RemoteConfigSettings()
        //새로운 값을 가져오는 인터벌, 최소화시킴
        setting.minimumFetchInterval = 0
        
        remoteConfig?.configSettings = setting
        
        remoteConfig?.setDefaults(fromPlist: "RemoteConfigDefaults")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getNotice()
    }

}


//Remote Config 가져오기
extension ViewController {
    
    func getNotice() {
        guard let remoteConfig = remoteConfig else { return }
        
        remoteConfig.fetch(completionHandler: {[weak self] state, error in
            if state == .success {
                remoteConfig.activate(completion: nil)
                
            } else {
                print("ERROR: \(String(describing: error?.localizedDescription))")
            }
            
            guard let self = self else { return }
            
            if !self.isNoticeHidden(remoteConfig) {
                let noticeVC = NoticeViewController(nibName: "NoticeViewController", bundle: nil)
                noticeVC.modalPresentationStyle = .custom
                noticeVC.modalTransitionStyle = .crossDissolve
                
                //.replacingOccurences(of: , with:) 는 Firebase 콘솔에서 줄바꾸기가 입력된 경우 본래의 줄바꾸기 기능을 수행시키기 위해.
                let title = (remoteConfig["title"].stringValue ?? "").replacingOccurrences(of: "\\n", with: "\n")
                let detail = (remoteConfig["detail"].stringValue ?? "").replacingOccurrences(of: "\\n", with: "\n")
                let date = (remoteConfig["date"].stringValue ?? "").replacingOccurrences(of: "\\n", with: "\n")
                
                noticeVC.noticeContents = (title: title, detail: detail, date: date)
                self.present(noticeVC, animated: true, completion: nil)
            } else {
                self.showEventAlert()
            }
        })
    }
    
    func isNoticeHidden(_ remoteConfig: RemoteConfig) -> Bool {
        return remoteConfig["isHidden"].boolValue
    }
    
}

// A/B test 를 위한 코드
extension ViewController {
    func showEventAlert() {
        guard let remoteConfig = remoteConfig else { return }
        
        remoteConfig.fetch(completionHandler: { [weak self] status, error in
            if status == .success {
                remoteConfig.activate(completion: nil)
            } else {
                print("ERROR: \(String(describing: error?.localizedDescription))")
            }
            
            let message = remoteConfig["message"].stringValue ?? ""
            
            let confirmAction = UIAlertAction(title: "확인하기", style: .default, handler: { _ in
                //Google Analytics
                //Event logging code
                
                Analytics.logEvent("PromotionMessage", parameters: nil)
            })
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            
            let alertController = UIAlertController(title: "이벤트 알림", message: message, preferredStyle: .alert)
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            
            self?.present(alertController, animated: true, completion: nil)
        })
    }
}
