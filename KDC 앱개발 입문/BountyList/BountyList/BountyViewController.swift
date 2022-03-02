//
//  BountyViewController.swift
//  BountyList
//
//  Created by 엔나루 on 2022/02/03.
//

import UIKit

class BountyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let nameList = ["brook","chopper", "franky", "luffy", "nami", "robin", "sanji", "zoro"]
    let bountyList = [33000000, 50, 44000000, 300000000, 16000000, 80000000, 77000000, 120000000]
    
    
    // MARK: - UITableViewDataSource Protocol
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ListCell else {
            return UITableViewCell()
        }
        
        cell.imgView.image = UIImage(named: "\(nameList[indexPath.row]).jpg")
        cell.nameLabel.text = nameList[indexPath.row]
        cell.bountyLabel.text = String(bountyList[indexPath.row])
        
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("--> \(indexPath.row)")
        
        //sender 는 같이 껴서 보내는 오브젝트
        performSegue(withIdentifier: "showDetail", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //send data to detail view controller.
        guard segue.identifier == "showDetail" else {
            return
        }
        let vc = segue.destination as? DetailViewController
        
        if let index = sender as? Int {
            vc?.name = nameList[index]
            vc?.bounty = bountyList[index]
        }
    }
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}


class ListCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bountyLabel: UILabel!
}
