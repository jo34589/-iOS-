//
//  DetailViewController.swift
//  BountyList
//
//  Created by 엔나루 on 2022/02/04.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bountyLabel: UILabel!
    
    var name: String?
    var bounty: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
        // Do any additional setup after loading the view.
    }
    
    func updateUI() {
        if let name = self.name, let bounty = self.bounty {
            
            imgView.image = UIImage(named: "\(name).jpg")
            nameLabel.text = name
            bountyLabel.text = String(bounty)
        }
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
