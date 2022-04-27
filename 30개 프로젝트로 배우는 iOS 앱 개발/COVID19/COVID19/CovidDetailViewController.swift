//
//  CovidDetailViewController.swift
//  COVID19
//
//  Created by 엔나루 on 2022/03/21.
//

import UIKit

class CovidDetailViewController: UITableViewController {

    @IBOutlet weak var newCaseCell: UITableViewCell!
    @IBOutlet weak var totalCaseCell: UITableViewCell!
    @IBOutlet weak var recoveredCell: UITableViewCell!
    @IBOutlet weak var deathCell: UITableViewCell!
    @IBOutlet weak var percentageCell: UITableViewCell!
    @IBOutlet weak var overseasInflowCell: UITableViewCell!
    @IBOutlet weak var regionalOutbreakCell: UITableViewCell!
    
    //선택된 지역의 covidOverview 를 받을 변수
    var covidOverview: CovidOverview?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func configureView() {
        guard let covidOverview = covidOverview else {
            return
        }
        
        self.title = covidOverview.countryName
        
        var cellconf = self.newCaseCell.defaultContentConfiguration()
        cellconf.secondaryText = "\(covidOverview.newCase) 명"
        self.newCaseCell.contentConfiguration = cellconf
        
        cellconf = self.totalCaseCell.defaultContentConfiguration()
        cellconf.secondaryText = "\(covidOverview.totalCase) 명"
        self.totalCaseCell.contentConfiguration = cellconf
        
        cellconf = self.recoveredCell.defaultContentConfiguration()
        cellconf.secondaryText = "\(covidOverview.recovered) 명"
        self.recoveredCell.contentConfiguration = cellconf
        
        cellconf = self.deathCell.defaultContentConfiguration()
        cellconf.secondaryText = "\(covidOverview.death) 명"
        self.deathCell.contentConfiguration = cellconf
        
        cellconf = self.percentageCell.defaultContentConfiguration()
        cellconf.secondaryText = "\(covidOverview.percentage)%"
        self.percentageCell.contentConfiguration = cellconf
        
        cellconf = self.overseasInflowCell.defaultContentConfiguration()
        cellconf.secondaryText = "\(covidOverview.newFcase) 명"
        self.overseasInflowCell.contentConfiguration = cellconf
        
        cellconf = self.regionalOutbreakCell.defaultContentConfiguration()
        cellconf.secondaryText = "\(covidOverview.newCcase) 명"
        self.regionalOutbreakCell.contentConfiguration = cellconf
    }
    

}
