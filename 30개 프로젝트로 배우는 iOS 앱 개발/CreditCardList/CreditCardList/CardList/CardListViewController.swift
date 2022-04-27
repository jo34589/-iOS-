//
//  CardListViewController.swift
//  CreditCardList
//
//  Created by 엔나루 on 2022/04/11.
//

import Foundation
import UIKit
import Kingfisher
import FirebaseDatabase
import FirebaseFirestore

//UIViewController 에 tableview를 추가한 거랑 뭐가 다르지?
//델리게이트 연결할 필요가 없다.

class CardListViewController: UITableViewController {
    //Firebase Realtime Database
    var ref: DatabaseReference!
    //Firestore
    var db = Firestore.firestore()
    
    var creditCardList: [CreditCard] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UITableViewCell register
        let nibName = UINib(nibName: "CardListCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "CardListCell")
        
        //firebase realtime database
        /*
        ref = Database.database().reference()
        
        ref.observe(.value) { snapshot in
            guard let value = snapshot.value as? [String: [String:Any]] else {
                return
            }
            //디코딩
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value)
                let cardData = try JSONDecoder().decode([String: CreditCard].self, from: jsonData)
                let cardList = Array(cardData.values)
                self.creditCardList = cardList.sorted(by: {
                    $0.rank < $1.rank
                })
                
                //메인스레드로 넘김
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } catch let error {
                print("error occured while decoding data from database")
                print(error.localizedDescription)
            }
            
        }
    */
        //Firestore
        db.collection("CreditCardList").addSnapshotListener { snapshot, error in
            guard let document = snapshot?.documents else {
                print("Error: Firestore Fetching document \(String(describing: error))")
                return
            }
            
            //compactmap을 이용해 nil 값이 반환된 경우 creditCardList 배열에 넣지 않음
            self.creditCardList = document.compactMap { doc -> CreditCard? in
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: doc.data(), options: [])
                    let creditCard = try JSONDecoder().decode(CreditCard.self, from: jsonData)
                    return creditCard
                    
                } catch let e {
                    print("Error: JSON parsing \(e.localizedDescription)")
                    return nil
                }
            }.sorted(by: {
                $0.rank < $1.rank
            })
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        creditCardList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardListCell", for: indexPath) as? CardListCell else { return UITableViewCell() }
        
        cell.rankLabel.text = "\(creditCardList[indexPath.row].rank)위"
        cell.promotionLabel.text = "\(creditCardList[indexPath.row].promotionDetail.amount)만원 증정"
        cell.cardNameLabel.text = creditCardList[indexPath.row].name
        
        //using Kingfisher
        let imageURL = URL(string: creditCardList[indexPath.row].cardImageURL)
        cell.cardImageView.kf.setImage(with: imageURL)
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //상세 화면 전달
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let cardDetailVC = storyBoard.instantiateViewController(withIdentifier: "CardDetailViewController") as? CardDetailViewController else { return }
        
        cardDetailVC.promotionDetail = creditCardList[indexPath.row].promotionDetail
        self.show(cardDetailVC, sender: nil)
        
        //기준값.
        let cardID = creditCardList[indexPath.row].id
        //realtime database에 없던 값 쓰기
        //case 1: 자동생성된 것이 아닌, 규칙에 따라 유추할 수 있는 키
        //'Item\(cardID)' 형식이라고 미리 알고 있기 때문에 가능한 방법
        //ref.child("Item\(cardID)/isSelected").setValue(true)
        
        //case 2: 키를 유추할 수 없을 때 데이터베이스에서 가져오는 방법.
        ref.queryOrdered(byChild: "id").queryEqual(toValue: cardID).observe(.value) { [weak self] snapshot in
            guard let self = self else { return }
            guard let value = snapshot.value as? [String: [String:Any]] else { return }
            guard let key = value.keys.first else { return }
            
            self.ref.child("\(key)/isSelected").setValue(true)
        }
        
        //Firestore 에 데이터 쓰기
        //case 1:
        db.collection("CreditCardList").document("card\(cardID)").updateData(["isSelected": true])
        //case 2:
        //sql의 where 문과 같은 방식
        db.collection("CreditCardList").whereField("id", isEqualTo: cardID).getDocuments { snapshot, error in
            guard let document = snapshot?.documents.first else { return }
            document.reference.updateData(["isSelected": true])
            
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let cardID = creditCardList[indexPath.row].id
            //Realtime Database 삭제 구현
            //case 1 아이디를 알 때
            //ref.child("Item\(cardID)").removeValue()
            
            //case 2: 데이터베이스에서 키를 검색해 삭제
            ref.queryOrdered(byChild: "id").queryEqual(toValue: cardID).observe(.value) { [weak self] snapshot in
                guard let self = self else { return }
                guard let value = snapshot.value as? [String: [String:Any]] else { return }
                guard let key = value.keys.first else { return }
                
                self.ref.child(key).removeValue()
            }
            
            //Firestore 삭제 구현
            //case 1:
            db.collection("CreditCardList").document("Card\(cardID)").delete()
            //case 2:
            db.collection("CreditCardList").whereField("id", isEqualTo: cardID).getDocuments { snapshot, error in
                guard let document = snapshot?.documents.first else { return }
                document.reference.delete()
                
            }
        }
    }
}
