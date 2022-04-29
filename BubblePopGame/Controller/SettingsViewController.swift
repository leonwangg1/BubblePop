//
//  SettingsViewController.swift
//  BubblePopGame
//
//  Created by Leon Wang on 21/4/22.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    let userDefaults = UserDefaults()
    
    @IBOutlet weak var playerName: UITextField!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var noBubblesLbl: UILabel!
    @IBOutlet weak var timerSlider: UISlider!
    @IBOutlet weak var maxBubblesSlider: UISlider!
    @IBOutlet weak var soundSwitch: UISwitch!
    @IBOutlet weak var musicSwitch: UISwitch!
    
    @IBAction func closeSettingsBtn(_ sender: Any) {
        self.removeAnimate()
    }
    
    // Update maximum time given the players choice
    @IBAction func maxTimeSlider(_ sender: UISlider) {
        var maxTime = Int(sender.value)
        userDefaults.setValue(maxTime, forKey: "gameTime")
        timeLbl.text = String(maxTime) + "s"
    }
    
    // Update maximum bubbles given the players choice
    @IBAction func maxBubblesSlider(_ sender: UISlider) {
        var maxBubbles = Int(sender.value)
        userDefaults.setValue(maxBubbles, forKey: "noBubbles") 
        noBubblesLbl.text = String(maxBubbles)
    }
    
    @IBAction func bgMusic(_ sender: UISwitch) {
        if sender.isOn {
//            ViewController.playBackgroundMusic(<#T##self: ViewController##ViewController#>)
        } else {
//            ViewController.stopBackgroundMusic()
        }
    }
    
    @IBAction func hitSound(_ sender: UISwitch) {
        if sender.isOn {
            userDefaults.set("on", forKey: "hitSound")
        } else {
            userDefaults.set("off", forKey: "hitSound")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Dim the background
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        // Show opening window animation
        self.showAnimate()
        playerName.delegate = self

        if let value = userDefaults.value(forKey: "playerName") as? String {
            playerName.text = value
        }
//        timerSlider.value = userDefaults.value(forKey: "gameTime") as! Float
        if let value = userDefaults.value(forKey: "gameTime") as? Float {
            timerSlider.value = value
        } 
//        timeLbl.text = String((userDefaults.value(forKey: "gameTime") as! Int)) + "s"
        if let value = userDefaults.value(forKey: "gameTime") as? Int {
            timeLbl.text = String(value) + "s"
        }
//        maxBubblesSlider.value = userDefaults.value(forKey: "noBubbles") as! Float
        if let value = userDefaults.value(forKey: "noBubbles") as? Float {
            maxBubblesSlider.value = value
        }
//        noBubblesLbl.text = String((userDefaults.value(forKey: "noBubbles") as! Int))
        if let value = userDefaults.value(forKey: "noBubbles") as? Int {
            noBubblesLbl.text = String(value)
        }
        
        if let value = userDefaults.value(forKey: "hitSound") as? String {
            if value == "on"{
                soundSwitch.setOn(true, animated: true)
            } else {
                soundSwitch.setOn(false, animated: true)
            }
        }
        // Do any additional setup after loading the view
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userDefaults.setValue(playerName.text, forKey: "playerName")
        playerName.resignFirstResponder()
        return true
    }
    
    // Animation for opening the settings window
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    // Animation for closing the settings window
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.removeFromSuperview()
                }
        });
    }
    
}
