//
//  AlertListViewController.swift
//  DrinkWater
//
//  Created by 엔나루 on 2022/04/16.
//

import UIKit
import UserNotifications

class AlertListViewController: UITableViewController {
    
    var alertList: [Alert] = []
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: "AlertListCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "AlertListCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        alertList = getAlertList()
    }
    
    @IBAction func addAlertActionButton(_ sender: UIBarButtonItem) {
        guard let addAlertVC = storyboard?.instantiateViewController(withIdentifier: "AddAlertViewController") as? AddAlertViewController else { return }
        
        addAlertVC.pickedDate = { [weak self] date in
            guard let self = self else { return }
            
            let newAlert = Alert(date: date, isON: true)
            var alerts = self.getAlertList()
            
            alerts.append(newAlert)
            alerts.sort { $0.date < $1.date }
            
            self.alertList = alerts
            
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.alertList), forKey: "alerts")
            
            self.userNotificationCenter.addNotificationRequest(by: newAlert)
            
            self.tableView.reloadData()
        }
        
        self.present(addAlertVC, animated: true, completion: nil)
    }
    
    func getAlertList() -> [Alert] {
        guard let data = UserDefaults.standard.value(forKey: "alerts") as? Data,
              let alerts = try? PropertyListDecoder().decode([Alert].self, from: data)
        else { return [] }
        
        return alerts
    }
    
}

//UITalbeView Delegate/Datasource
extension AlertListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alertList.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "🍶 물마실 시간"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlertListCell", for: indexPath) as? AlertListCell else { return UITableViewCell() }
        
        cell.alertSwitch.isOn = alertList[indexPath.row].isON
        cell.timeLabel.text = alertList[indexPath.row].time
        cell.meridianLabel.text = alertList[indexPath.row].meridian
        
        cell.alertSwitch.tag = indexPath.row
        
        return cell
                
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            //노티피케이션 삭제 구현
            self.alertList.remove(at: indexPath.row)
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.alertList), forKey: "alerts")
            //알림 삭제 구현
            userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [self.alertList[indexPath.row].id])
            
            self.tableView.reloadData()
            return
        default:
            break
        }
    }
}
