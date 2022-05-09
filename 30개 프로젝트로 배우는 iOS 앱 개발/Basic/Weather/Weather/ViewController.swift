//
//  ViewController.swift
//  Weather
//
//  Created by 엔나루 on 2022/03/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var weatherStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func tapFetchWeather(_ sender: UIButton) {
        if let cityName = self.cityNameTextField.text {
            self.getCurrentWeather(cityName: cityName)
            self.view.endEditing(true)
        }
        
    }
    
    func configureView(weatherInfo: WeatherInformation) {
        self.cityNameLabel.text = weatherInfo.name
        if let weather = weatherInfo.weather.first {
            self.weatherDescriptionLabel.text = weather.description
            
        }
        self.tempLabel.text = "\(Int(weatherInfo.temp.temp - 273.15))℃"
        self.minTempLabel.text = "최저: \(Int(weatherInfo.temp.minTemp - 273.15))℃"
        self.maxTempLabel.text = "최대: \(Int(weatherInfo.temp.maxTemp - 273.15))℃"
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getCurrentWeather(cityName: String) {
        guard let url = URL(string: "http://api.openweathermap.org/geo/1.0/direct?q=\(cityName)&limit=5&appid=bb5bf596a9dfb06f6cdee5bb740fa0af") else { return }
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { [weak self] data, response, error in
            //completion handler
            //응답을 받은 경우 호출됨
            //data : 응답받은 data
            //response: HTTP 헤더 및 코드 등 상태
            //error: 요청 실패 시 nil 이 아닌게 담김
            let successRange = (200 ..< 300)
            
            guard let data = data, error == nil else { return }
            let decoder = JSONDecoder()
            if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode) {
                //요청 성공
                guard let weatherInformation = try? decoder.decode(WeatherInformation.self, from: data) else { return }
                //debugPrint(weatherInformation)
                //ui 변경이라 메인스레드로 넘김
                DispatchQueue.main.async {
                    self?.weatherStackView.isHidden = false
                    self?.configureView(weatherInfo: weatherInformation)
                }
            } else {
                //error사항
                guard let errorMessage = try? decoder.decode(ErrorMessage.self, from: data) else { return }
                debugPrint(errorMessage)
                DispatchQueue.main.async {
                    self?.showAlert(message: errorMessage.message)
                }
            }
        //작업실행
        }.resume()
    }
    
}

