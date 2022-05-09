//
//  MainViewContorller.swift
//  SpotifyLoginSample
//
//  Created by 엔나루 on 2022/04/03.
//

import Foundation
import UIKit
import FirebaseAuth
import GoogleSignIn

class MainViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var resetPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        
        let email = Auth.auth().currentUser?.email ?? "고객"
        
        welcomeLabel.text = """
        환영합니다
        \(email) 님
        """
        
        //이메일로 로그인했다면 버튼을 표시한다.
        let isEmailSignIn = Auth.auth().currentUser?.providerData[0].providerID == "password"
        resetPasswordButton.isHidden = !isEmailSignIn
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error: signout error \(signOutError.localizedDescription)")
        }
        GIDSignIn.sharedInstance.signOut()
    }
    
    @IBAction func resetPasswordButtonTapped(_ sender: UIButton) {
        let email = Auth.auth().currentUser?.email ?? ""
        //비밀번호 리셋 메일을 보내게 됨
        Auth.auth().sendPasswordReset(withEmail: email, completion: nil)
    }
    
}
