//
//  BaseListViewController.swift
//  PunkAPI
//
//  Created by 엔나루 on 2022/04/26.
//

import UIKit

class BeerListViewController: UITableViewController {
    
    //중복 fetching을 방지하기 위한 전역변수
    var dataTasks : [URLSessionTask] = []
    
    var beerList: [Beer] = []
    //PUNK api
    /*
     Requests that return multiple items will be limited to 25 results by default. You can access other pages using the ?page paramater, you can also increase the amount of beers returned in each request by changing the ?per_page paramater.
     */
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationBar customization
        title = "PUNKY 맥주들"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //UITableView 설정
        
        //cell register
        tableView.register(
            BeerListCell.self,
            forCellReuseIdentifier: "BeerListCell")
        tableView.rowHeight = 150
        //테이블 뷰에서 한 페이지 이상의 정보를 스크롤 다운 시 나타내게 하기 위함.
        tableView.prefetchDataSource = self
        
        fetchBeer(of: currentPage)
    }
}

//UITableViewDelegate/DataSource
extension BeerListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BeerListCell", for: indexPath) as? BeerListCell
        else {
            return UITableViewCell()
        }
        
        let beer = beerList[indexPath.row]
        cell.configure(with: beer)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBeer = beerList[indexPath.row]
        let detailVC = BeerDetailViewController()
        
        detailVC.beer = selectedBeer
        
        self.show(detailVC, sender: nil)
    }
}

//beer fetching
extension BeerListViewController {
    private func fetchBeer(of page: Int) {
        guard let url = URL(string: "https://api.punkapi.com/v2/beers?page=\(page)"),
              dataTasks.firstIndex(where: { task in
                  //이미 요청된 url 이 아니여야 한다.
                  task.originalRequest?.url == url
              }) == nil
        else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, response, error in
            guard error == nil,
                  let self = self,
                  let response = response as? HTTPURLResponse,
                  let data = data,
                  let beers = try? JSONDecoder().decode([Beer].self, from: data) else {
                      debugPrint("Error: \(String(describing: error?.localizedDescription))")
                      return
                  }
            switch response.statusCode {
            case (200 ... 299): //성공
                self.beerList += beers
                self.currentPage += 1
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case (400 ... 499): //클라이언트 에러
                debugPrint("""
                           Error: ClientError with code: \(response.statusCode)
                           Response: \(response)
                           """)
            case (500 ... 599): //서버 에러
                debugPrint("""
                           Error: ServerError with code: \(response.statusCode)
                           Response: \(response)
                           """)
            default:
                debugPrint("""
                           Error: Error with code: \(response.statusCode)
                           Response: \(response)
                           """)

            }
        })
        dataTask.resume()
        dataTasks.append(dataTask)
    }
}

extension BeerListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        //indexPaths.forEach {
            //print("prefetching rows: \($0.row)
        //}
        guard currentPage != 1 else { return }
        indexPaths.forEach {
            //page 구해서 현제 보여지는 페이지와 같다면
            if ($0.row + 1)/25 + 1 == currentPage {
                //다음 페이지를 가져오기
                self.fetchBeer(of: currentPage)
            }
        }
    }
}
