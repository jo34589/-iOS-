//
//  ViewController.swift
//  COVID19
//
//  Created by 엔나루 on 2022/03/21.
//

import UIKit
import Charts
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var totalCaseLabel: UILabel!
    @IBOutlet weak var newCaseLabel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    
    @IBOutlet weak var labelStackView: UIStackView!
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicatorView.startAnimating()
        self.fetchCovidOverview(completion: { [weak self] result in
            
            //escaped closure
            //일시적으로 강한 참조화
            //Alamofire 의 responseData 의 completionHandler 는 main 스레드에서 동작하도록 되어 있기 때문에
            //ui를 수정할 때 DispatchQueue.main.async {} 를 쓰지 않아도 된다.
            
            guard let self = self else { return }
            self.indicatorView.stopAnimating()
            self.indicatorView.isHidden = true
            self.labelStackView.isHidden = false
            self.pieChartView.isHidden = false
            switch result {
            case let .success(result):
                debugPrint("success: \(result)")
                self.configureStackView(koreaCovidOverview: result.korea)
                let covidOverviewList = self.makeCovidOverviewList(cityCovidOverview: result)
                self.configureChartView(covidOverViewList: covidOverviewList)
            case let .failure(error):
                debugPrint("failure: \(error)")
            
            }
        })
        // Do any additional setup after loading the view.
    }

    func makeCovidOverviewList(cityCovidOverview: CityCovidOverview) -> [CovidOverview]{
        
        return [
            cityCovidOverview.seoul,
            cityCovidOverview.busan,
            cityCovidOverview.daegu,
            cityCovidOverview.incheon,
            cityCovidOverview.gwangju,
            cityCovidOverview.daejeon,
            cityCovidOverview.ulsan,
            cityCovidOverview.sejong,
            cityCovidOverview.gyeonggi,
            cityCovidOverview.gangwon,
            cityCovidOverview.chungbuk,
            cityCovidOverview.chungnam,
            cityCovidOverview.jeonbuk,
            cityCovidOverview.jeonnam,
            cityCovidOverview.gyeongbuk,
            cityCovidOverview.gyeongnam,
            cityCovidOverview.jeju
        ]
    }
    
    func configureChartView(covidOverViewList: [CovidOverview]) {
        self.pieChartView.delegate = self
        let entries = covidOverViewList.compactMap({ [weak self] overview -> PieChartDataEntry? in
            guard let self = self else { return nil }
            return PieChartDataEntry(
                value: self.removeFormatString(string: overview.newCase),
                label: overview.countryName,
                data: overview
            )
        })
        let dataSet = PieChartDataSet(entries: entries, label: "코로나 발생 현황")
        dataSet.sliceSpace = 1
        dataSet.entryLabelColor = .black
        dataSet.xValuePosition = .outsideSlice
        dataSet.valueLinePart1OffsetPercentage = 0.8
        dataSet.valueLinePart1Length = 1
        dataSet.valueLinePart2Length = 0.3
        dataSet.valueTextColor = .black
        
        dataSet.colors = ChartColorTemplates.vordiplom() + ChartColorTemplates.joyful() + ChartColorTemplates.liberty() + ChartColorTemplates.pastel() + ChartColorTemplates.material()
        self.pieChartView.data = PieChartData(dataSet: dataSet)
        self.pieChartView.spin(duration: 0.3, fromAngle: self.pieChartView.rotationAngle, toAngle: self.pieChartView.rotationAngle + 80)
    }
    
    func removeFormatString(string: String) -> Double {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: string)?.doubleValue ?? 0
    }
    
    func configureStackView(koreaCovidOverview: CovidOverview) {
        self.totalCaseLabel.text = "\(koreaCovidOverview.totalCase) 명"
        self.newCaseLabel.text = "\(koreaCovidOverview.newCase) 명"
    }
    
    // completion을 escaping 클로저로 해야 함
    // 함수의 인자로 클로저가 전달되지만 함수가 리턴 된 다음에도 실행됨
    // 영역을 탈출하므로 기존의 변수의 scope 개념을 완전히 무시
    // 비동기 작업을 하는 경우 많이 사용
    func fetchCovidOverview(completion:@escaping (Result<CityCovidOverview, Error>) -> Void) {
        let url = "https://api-corona19.kr/korea/country/new"
        let param = [
            "serviceKey" : "lWBak2spGCzKLc4u7AYm3i8EwI9DfZoUh"
        ]
        
        AF.request(url, method: .get, parameters: param)
            .responseData(completionHandler: {response in
                switch response.result {
                case let .success(data):
                    //성공일 경우 연관값(data)를 cityCovidOverview 구조체에 매핑
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(CityCovidOverview.self, from: data)
                        //전체 함수의 completion 클로저에 디코드된 결과를 넘김
                        completion(.success(result))
                    } catch {
                        completion(.failure(error))
                    }
                case let .failure(error):
                    completion(.failure(error))
                }
            })
    }
}

extension ViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let covidDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "CovidDetailViewController") as? CovidDetailViewController else { return }
        guard let covidOverview = entry.data as? CovidOverview else { return }
        covidDetailVC.covidOverview = covidOverview
        self.navigationController?.pushViewController(covidDetailVC, animated: true)
    }
}
