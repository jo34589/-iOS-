//
//  LoginViewController.swift
//  SpotifyLoginSample
//
//  Created by 엔나루 on 2022/04/03.
//

import Foundation
import UIKit
import GoogleSignIn
import FirebaseAuth
import AuthenticationServices

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailLoginButton: UIButton!
    
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    
    @IBOutlet weak var appleLoginButton: UIButton!
    
    let signInConfig = GIDConfiguration.init(clientID: "381942374216-1n4q2r9k0scndni4bp8pfmrjolvjba8v.apps.googleusercontent.com")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [emailLoginButton, googleLoginButton, appleLoginButton].forEach {
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.white.cgColor
            $0?.layer.cornerRadius = 30
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //네비게이션 바 숨기기
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    @IBAction func googleLoginButtonTapped(_ sender: UIButton) {
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            //signin succeeded
            guard let user = user else { return }
            user.authentication.do { authentication, error in
                guard error == nil else { return }
                guard let authentication = authentication else { return }
                
                let idToken = authentication.idToken ?? ""
                let accessToken = authentication.accessToken
                //import FirebaseAuth 필요
                //GoogleAuthPrivider 클래스는 FirebaseAuth에 있음
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
                
                Auth.auth().signIn(with: credential, completion: { [weak self] authDataResult , error in
                    guard let self = self else { return }
                    
                    if let error = error {
                        //로그인 에러 발생
                        debugPrint(error.localizedDescription)
                        return
                    } else {
                        self.showMainViewController()
                    }
                })
            }
        }
    }
    
    @IBAction func appleLoginButtonTapped(_ sender: UIButton) {
    }
    
    private func showMainViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainVC = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        mainVC.modalPresentationStyle = .fullScreen
        self.navigationController?.show(mainVC, sender: nil)
    }
}
