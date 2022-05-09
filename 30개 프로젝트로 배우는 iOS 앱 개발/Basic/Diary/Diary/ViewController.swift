//
//  ViewController.swift
//  Diary
//
//  Created by 엔나루 on 2022/03/13.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var diaryList: [Diary] = [] {
        didSet {
            self.saveDiaryList()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadDiaryList()
        self.configureCollectionView()
        
        //여기도 NotificationCenter 추가
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
            selector: #selector(deleteDiaryNoti(_:)),
            name: NSNotification.Name("deleteDiary"),
            object: nil)
    }
    
    //segueway를 통해 이동하므로 준비하는 메소드
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let writeDiaryVC = segue.destination as? WriteDiaryViewController {
            writeDiaryVC.delegate = self
        }
    }
    
    //다른 곳에서 수정됨
    @objc func editDiaryNoti(_ noti: Notification) {
        guard let diary = noti.object as? Diary else { return }
        guard let index = self.diaryList.firstIndex(where: {$0.uuidString == diary.uuidString}) else { return }
        self.diaryList[index] = diary
        self.diaryList.sort(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
        self.collectionView.reloadData()
    }
    //다른 곳에서 별찍힘
    @objc func starDiaryNoti(_ noti: Notification) {
        guard let starDiary = noti.object as? [String : Any] else { return }
        guard let isStar = starDiary["isStar"] as? Bool else { return }
        guard let uuidString = starDiary["uuidString"] as? String else { return }
        guard let index = self.diaryList.firstIndex(where: {$0.uuidString == uuidString}) else { return }
        self.diaryList[index].isStar = isStar
    }
    //다른 곳에서 삭제됨
    @objc func deleteDiaryNoti(_ noti: Notification) {
        guard let uuidString = noti.object as? String else { return }
        guard let index = self.diaryList.firstIndex(where: {$0.uuidString == uuidString}) else { return }
        self.diaryList.remove(at: index)
        self.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
    }
    
    //collection 뷰 설정
    private func configureCollectionView() {
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    //Date 타입을 받아 원하는 문자열로 변환하는 함수
    private func dateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy 년 MM 월 dd 일 (EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    //데이터 저장 불러오기
    private func saveDiaryList() {
        let date = self.diaryList.map {
            [
                "uuidString" : $0.uuidString,
                "title": $0.title,
                "contents" : $0.contents,
                "date" : $0.date,
                "isStar" : $0.isStar
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(date, forKey: "diaryList")
    }
    
    private func loadDiaryList() {
        let userDefaults = UserDefaults.standard
        //any 타입 리턴이라 타입캐스팅
        guard let data = userDefaults.object(forKey: "diaryList") as? [[String : Any]] else {
            return
        }
        self.diaryList = data.compactMap {
            guard let uuidString = $0["uuidString"] as? String else { return nil }
            guard let title = $0["title"] as? String else { return nil }
            guard let contents = $0["contents"] as? String else { return nil }
            guard let date = $0["date"] as? Date else { return nil }
            guard let isStar = $0["isStar"] as? Bool else { return nil }
            
            return Diary(
                uuidString: uuidString,
                title: title,
                contents: contents,
                date: date,
                isStar: isStar)
        }
        self.diaryList.sort(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
    }
}

extension ViewController: WriteDiaryViewDelegate {
    //작성 완룐된 diary 가 파라미터로 담겨 온다.
    func didSelectRegister(diary: Diary) {
        self.diaryList.append(diary)
        self.collectionView.reloadData()
    }
}

extension ViewController: UICollectionViewDelegate {
    //선택된 셀의 정보를 전달하고 detailVC 를 띄움
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DiaryDetailViewController") as? DiaryDetailViewController else {
            return
        }
        detailVC.diary = self.diaryList[indexPath.row]
        detailVC.indexPath = indexPath
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.diaryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryCell", for: indexPath) as? DiaryCell else {
            return UICollectionViewCell()
        }
        
        let diary = self.diaryList[indexPath.row]
        cell.titleLabel.text = diary.title
        cell.dateLabel.text = dateToString(diary.date)
        
        return cell
    }
}

//셀 크기를 정하기 위해.
extension ViewController: UICollectionViewDelegateFlowLayout {
    //size for item at indexPath
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width)/2 - 20, height: 200)
    }
}
