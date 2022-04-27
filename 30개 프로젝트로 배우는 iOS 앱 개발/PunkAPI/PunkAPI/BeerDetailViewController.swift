//
//  BeerDetailViewController.swift
//  PunkAPI
//
//  Created by 엔나루 on 2022/04/26.
//

import UIKit
import SnapKit

class BeerDetailViewController: UITableViewController {
    var beer: Beer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //nav bar title
        title = beer?.name ?? "이름 없는 맥주"
        
        tableView = UITableView(frame: tableView.frame, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BeerDetailListCell")
        tableView.rowHeight = UITableView.automaticDimension
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
        let headerView = UIImageView(frame: frame)
        let imageURL = URL(string: beer?.imageURL ?? "")
        
        headerView.contentMode = .scaleAspectFit
        headerView.kf.setImage(with: imageURL, placeholder: UIImage(named: "beer_icon"))
        
        tableView.tableHeaderView = headerView
        
    }
}

//tableViewDatasource, delegate

extension BeerDetailViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 3:
            return beer?.foodPairing?.count ?? 0
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "ID"
        case 1:
            return "DESCRIPTION"
        case 2:
            return "BREWERS TIP"
        case 3:
            return beer?.foodPairing?.isEmpty ?? true ? nil : "FOOD PARING"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "BeerDetailListCell")
        
        cell.selectionStyle = .none
        
        var cellConf = cell.defaultContentConfiguration()
        cellConf.textProperties.numberOfLines = 0
        var cellText: String = ""
        switch indexPath.section {
        case 0:
            cellText = String(describing: beer?.id ?? 0)
        case 1:
            cellText = beer?.description ?? "설명 없는 맥주"
        case 2:
            cellText = beer?.brewersTips ?? "팁 없는 맥주"
        case 3:
            cellText = beer?.foodPairing?[indexPath.row] ?? ""
        default:
            ()
        }
        cellConf.text = cellText
        
        cell.contentConfiguration = cellConf
        
        return cell
    }
    
}
