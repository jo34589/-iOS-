//
//  ViewController.swift
//  Pomodoro
//
//  Created by 엔나루 on 2022/03/18.
//

import UIKit
//알람소리
import AudioToolbox

enum TimerStatus {
    case start
    case pause
    case end
}

class ViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var toggleButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    //datePicker가 기본 1분
    var duration = 60
    var timerStatus: TimerStatus = .end
    //현제 카운트다운 된 시간을 초 단위로 저장
    var currentSeconds = 0
    
    //멀티스레드 이용.
    var timer: DispatchSourceTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureToggleButton()
        // Do any additional setup after loading the view.
    }
    
    func setTimerInfoViewVisible(isHidden: Bool) {
        self.timerLabel.isHidden = isHidden
        self.progressView.isHidden = isHidden
    }
    
    func configureToggleButton() {
        self.toggleButton.setTitle("시작", for: .normal)
        self.toggleButton.setTitle("일시정지", for: .selected)
    }
    
    
    
    func startTimer() {
        if self.timer == nil {
            //ui 업데이트 등이 포함된 작업이 타이머와 연동되므로 메인스레드
            self.timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
            self.timer?.schedule(deadline: .now(), repeating: 1)
            self.timer?.setEventHandler(handler: { [weak self] in
                //일시적으로 self를 strong reference로 바꿈
                guard let self = self else { return }
                self.currentSeconds -= 1
                //debugPrint(self?.currentSeconds)
                
                let hour = self.currentSeconds / 3600
                let minutes = (self.currentSeconds % 3600) / 60
                let seconds = (self.currentSeconds % 3600) % 60
                
                self.timerLabel.text = String(format: "%02d:%02d:%02d", hour, minutes, seconds)
                self.progressView.progress = Float(self.currentSeconds) / Float(self.duration)
                //debugPrint(self.progressView.progress)
                
                UIView.animate(withDuration: 0.5, delay: 0, animations: {
                    self.imageView.transform = CGAffineTransform(rotationAngle: .pi)
                })
                UIView.animate(withDuration: 0.5, delay: 0.5, animations: {
                    self.imageView.transform = CGAffineTransform(rotationAngle: .pi * 2)
                })
                
                //카운트다운끝
                if self.currentSeconds <= 0 {
                    //타이머 종료
                    self.stopTimer()
                    //https://iphonedev.wiki/index.php/AudioServices
                    AudioServicesPlaySystemSound(1005)
                }
            })
            //타이머가 시작되게 해줌.
            self.timer?.resume()
        }
    }
    
    func stopTimer() {
        //timer를 suspend 시킨 상태에서 nil 을 대입하면 런타임 에러가 남
        //timer에 남은 작업이 있는데 메모리에서 해제시킨다고 생각하기 때문
        //따라서 resume() 을 시키고 나서 self.timer = nil 을 해줘야 함
        if self.timerStatus == .pause {
            self.timer?.resume()
        }
        self.timerStatus = .end
        self.cancelButton.isEnabled = false
        //self.setTimerInfoViewVisible(isHidden: true)
        //self.datePicker.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.timerLabel.alpha = 0.0
            self.progressView.alpha = 0.0
            self.datePicker.alpha = 1.0
            self.imageView.transform = .identity
        })
        self.toggleButton.isSelected = false
        
        self.timer?.cancel()
        //메모리에서 해제시켜줘야 함
        //화면에서 벗어나도 타이머가 동작할 가능성이 있음.
        self.timer = nil
        
    }
    
    @IBAction func tapCalcelButton(_ sender: UIButton) {
        switch self.timerStatus {
        case .start, .pause:
            
            self.stopTimer()
        default:
            break
        }
    }
    
    @IBAction func tapToggleButton(_ sender: UIButton) {
        self.duration = Int(self.datePicker.countDownDuration)
        //debugPrint(self.duration)
        switch self.timerStatus {
        case .end:
            self.currentSeconds = self.duration
            self.timerStatus = .start
            //self.setTimerInfoViewVisible(isHidden: false)
            //self.datePicker.isHidden = true
            UIView.animate(withDuration: 0.5, animations: {
                self.timerLabel.alpha = 1.0
                self.progressView.alpha = 1.0
                self.datePicker.alpha = 0.0
                
            })
            self.toggleButton.isSelected = true
            self.cancelButton.isEnabled = true
            self.startTimer()
        case .start:
            self.timerStatus = .pause
            self.toggleButton.isSelected = false
            self.timer?.suspend()
        case .pause:
            self.timerStatus = .start
            self.toggleButton.isSelected = true
            self.timer?.resume()
        }
    }
    

}

