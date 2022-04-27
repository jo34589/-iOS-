//
//  ViewController.swift
//  TodoList
//
//  Created by 엔나루 on 2022/03/08.
//

import UIKit

class ViewController: UIViewController {
    

    @IBOutlet weak var tableView: UITableView!
    
    //edit과 done을 왔다갔다하게 만들고 싶음.
    //editButton을 weak 로 선언하면 done으로 바꿨을 때 메모리에서 해제가 되어버림.
    @IBOutlet var editButton: UIBarButtonItem!
    var doneButton: UIBarButtonItem?
    
    var tasks: [Task] = [] {
        //tasks 배열에 할 일이 추가될 때 마다 saveTasks() 가 호출됨
        //didSet 안의 코드블럭은 tasks가 변경된 직후 실행됨.
        //willSet 안의 코드블럭은 tasks가 변경되기 직전 실행됨.
        //사용조건: 초기화 되어 있어야 함.
        didSet {
            self.saveTasks()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.loadTasks()
        
        self.doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapDoneButton))
        // Do any additional setup after loading the view.
    }
    
    @objc func tapDoneButton() {
        self.navigationItem.leftBarButtonItem = editButton
        self.tableView.setEditing(false, animated: true)
    }
    
    @IBAction func tapEditButton(_ sender: UIBarButtonItem) {
        guard !self.tasks.isEmpty else { return }
        self.navigationItem.leftBarButtonItem = self.doneButton
        self.tableView.setEditing(true, animated: true)
        
    }
    
    @IBAction func tapAddButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "할 일 등록", message: nil, preferredStyle: .alert)
        let registerButton = UIAlertAction(title: "등록", style: .default, handler: { [weak self] _ in
            //클래스처럼 클로저도 참조 타입
            //클로저 내부에서 self 로 클래스의 인스턴스를 캡처할 때 강한 순환 참조가 발생할 수 있음
            //이를 방지하기 위해 클로저 내부에서 self 를 사용하지 않고 위에서 [weak self]를 사용함
            //debugPrint(alert.textFields?[0].text)
            guard let title = alert.textFields?[0].text else { return }
            let task = Task(title: title, done: false)
            self?.tasks.append(task)
            self?.tableView.reloadData()
            
        })
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addTextField(configurationHandler: { textField in
            //alert 에 들어가는 클로저를 구성하기 위한 클로저
            textField.placeholder = "할 일을 입력해 주세요"
        })
        
        alert.addAction(cancelButton)
        alert.addAction(registerButton)
        self.present(alert, animated: false, completion: nil)
    }
    
}

extension ViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->  UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var cellconf = cell.defaultContentConfiguration()
        
        let task = tasks[indexPath.row]
        cellconf.text = task.title
        
        if task.done {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        cell.contentConfiguration = cellconf
        return cell
    }
    
    //편집모드에서 삭제버튼을 눌렀을 때 호출되는 메소드
    //indexPath 로 어느 row가 선택됐는지 알려준다.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.tasks.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        
        if self.tasks.isEmpty {
            self.tapDoneButton()
        }
    }
    
    //편집모드에서 열 간 이동을 지원하기 위한 두 개의 메소드
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        //모든 row가 이동 가능하다.
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var tasks = self.tasks
        let task = tasks[sourceIndexPath.row]
        tasks.remove(at: sourceIndexPath.row)
        tasks.insert(task, at: destinationIndexPath.row)
        self.tasks = tasks
    }
}

extension ViewController {
    func saveTasks() {
        let data = self.tasks.map {
            [
                "title" : $0.title,
                "done" : $0.done
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "tasks")
    }
    
    func loadTasks() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "tasks") as? [[String: Any]] else { return }
        self.tasks = data.compactMap {
            guard let title = $0["title"] as? String else { return nil }
            guard let done = $0["done"] as? Bool else { return nil }
            return Task(title: title, done: done)
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var task = self.tasks[indexPath.row]
        task.done = !task.done
        self.tasks[indexPath.row] = task
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
