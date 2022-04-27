//
//  StarViewController.swift
//  Diary
//
//  Created by 엔나루 on 2022/03/13.
//

import UIKit

class StarViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var diaryList: [Diary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadStarDiaryList()
        self.configureCollectionView()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(editDiaryNoti(_:)),
            name: NSNotification.Name("editDiary"),
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(starDiaryNoti(_:)),
            name: NSNotification.Name("starDiary"),
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(delteDiaryNoti(_:)),
            name: NSNotification.Name("deleteDiary"),
            object: nil)
    }
    
    private func loadStarDiaryList() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "diaryList") as? [[String: Any]] else { return }
        self.diaryList = data.compactMap({
            guard let title = $0["title"] as? String else { return nil }
            guard let contents = $0["contents"] as? String else { return nil }
            guard let date = $0["date"] as? Date else { return nil }
            guard let isStar = $0["isStar"] as? Bool else { return nil }
            return Diary(uuidString: <#String#>, title: title, contents: contents, date: date, isStar: isStar)
        })
        .filter({
            $0.isStar == true
        })
        .sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
    }
    
    private func configureCollectionView() {
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    //notification 받으면 실행할 objc func들
    //editnoti
    @objc func editDiaryNoti(_ noti: Notification) {
        guard let diary = noti.object as? Diary else { return }
        guard let index = self.diaryList.firstIndex(where: {$0.uuidString == diary.uuidString}) else { return }
        self.diaryList[index] = diary
        self.diaryList.sort(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
        self.collectionView.reloadData()
    }
    //starnoti
    @objc func starDiaryNoti(_ noti: Notification) {
        guard let starDiary = noti.object as? [String:Any] else { return }
        guard let diary = starDiary["diary"] as? Diary else { return }
        guard let isStar = starDiary["isStar"] as? Bool else { return }
        guard let uuidString = noti.object as? String else { return }
        
        if !isStar {
            //즐겨찾기가 해제된 경우
            guard let index = self.diaryList.firstIndex(where: {$0.uuidString == uuidString}) else { return }
            self.diaryList.remove(at: index)
            self.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
        } else {
            self.diaryList.append(diary)
            self.diaryList.sort(by: {
                $0.date.compare($1.date) == .orderedDescending
            })
            self.collectionView.reloadData()
        }
    }
    //deletenoti
    @objc func delteDiaryNoti(_ noti: Notification) {
        guard let uuidString = noti.object as? String else { return }
        guard let index = self.diaryList.firstIndex(where: {$0.uuidString == uuidString}) else { return }
        self.diaryList.remove(at: index)
        self.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
    }
    
    private func dateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy 년 MM 월 dd 일 (EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}

extension StarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let diaryDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "DiaryDetailViewController") as? DiaryDetailViewController else { return }
        let diary = self.diaryList[indexPath.row]
        diaryDetailVC.diary = diary
        diaryDetailVC.indexPath = indexPath
        
    }
}

extension StarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.diaryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "StarCell", for: indexPath) as? StarCell else { return UICollectionViewCell()}
        let diary = self.diaryList[indexPath.row]
        cell.titleLabel.text = diary.title
        cell.dateLabel.text = dateToString(diary.date)
        
        
        return cell
    }
}

extension StarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width-20, height: 80)
    }
}
