//
//  ViewController.swift
//  BubblePopGame
//
//  Created by Leon Wang on 20/4/22.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var gameBGMusic = AVAudioPlayer()
    let userDefaults = UserDefaults()
    @IBOutlet var playBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

//            playBackgroundMusic(filename: <#T##String#>)
    }
    
    func playBackgroundMusic (filename: String){
        
        let url = Bundle.main.url(forResource: filename, withExtension: nil)
        guard let newUrl = url else {
            print("Could not find file called \(filename)")
            return
        }; do {
            gameBGMusic = try AVAudioPlayer(contentsOf: newUrl)
            gameBGMusic.numberOfLoops = -1
            gameBGMusic.prepareToPlay()
            gameBGMusic.play()
        } catch let error as NSError {
            print(error.description)
            
        }
    }
    
    func stopBackgroundMusic() {
        gameBGMusic.stop()
    }
  
    @IBAction func pressPlay(_ sender: UIButton) {
        
        // Check if user hasn't entered any settinfs
        if userDefaults.value(forKey: "gameTime") == nil {
            userDefaults.setValue(60, forKey: "gameTime")
        }
        if userDefaults.value(forKey: "noBubbles") == nil {
            userDefaults.setValue(15, forKey: "noBubbles")
        }
        
        if userDefaults.value(forKey: "playerName") == nil {
            userDefaults.setValue("Anon", forKey: "playerName")
        }
        
        if userDefaults.value(forKey: "highScore") == nil {
            userDefaults.setValue(0, forKey: "highScore")
        }
        
        if userDefaults.value(forKey: "leaderboard") == nil {
            userDefaults.setValue(["ANONYMOUS": 0], forKey: "leaderboard")
        }
        
        if userDefaults.value(forKey: "hitSound") == nil {
            userDefaults.setValue("on", forKey: "hitSound")
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "PlayViewController") as? PlayViewController {
            self.navigationController?.pushViewController(viewcontroller, animated: false)
        }
        // Does nothing if not found, doesnt crash app
    }
    
    @IBAction func showSettings(_ sender: UIButton) {
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
}

