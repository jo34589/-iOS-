//
//  ViewController.swift
//  ScreenTransactionExample
//
//  Created by 엔나루 on 2022/03/05.
//

import UIKit

class ViewController: UIViewController, SendDataDelegate {
    
    func sendDate(name: String) {
        self.nameLabel.text = name
        self.nameLabel.sizeToFit()
    }
    

    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapCodePushButton(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CodePushViewController") as? CodePushViewController else { return }
        vc.name = "gunter"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapCodePresentButton(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CodePresentViewController") as? CodePresentViewController else { return }
        vc.name = "gunter"
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SeguePushViewController {
            vc.name = "Gunter"
            
        }
            
    }
    
}

