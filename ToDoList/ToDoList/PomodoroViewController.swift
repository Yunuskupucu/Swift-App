//
//  PomodoroViewController.swift
//  ToDoList
//
//  Created by Yunus Emre KÜPÜCÜ on 9.05.2024.
//

import UIKit
import AVFoundation

class PomodoroViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    var pomodoro = 4
    let breakTime = 2
    
    var player: AVAudioPlayer!
    var timer = Timer()
    var totalTime = 0
    var secondsPassed = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    
    @IBAction func pomodoroButtonPressed(_ sender: UIButton) {
        
        timer.invalidate()
        totalTime = pomodoro
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        
        progressBar.progress = 0.0
        secondsPassed = 0
        timeLabel.text = String(totalTime)
       
        
    }
    
    @IBAction func breakButtonPressed(_ sender: UIButton) {
        timer.invalidate()
        totalTime = breakTime
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        
        progressBar.progress = 0.0
        secondsPassed = 0
        timeLabel.text = String(breakTime)
       
    }
    
    
    @objc func updateTimer(){
               
        if secondsPassed < totalTime {
            // ilerleme yüzesi güncelleme
            secondsPassed += 1
            progressBar.progress = Float(secondsPassed) / Float(totalTime)
            timeLabel.text = "\(totalTime-secondsPassed)"
        } else {
            timer.invalidate()
//            timeLabel.text = "\(pomodoro)"
            
            let url = Bundle.main.url(forResource: "news-flash", withExtension: "mp3")
                        player = try! AVAudioPlayer(contentsOf: url!)
                        player.play()
        }
    }
}


