//
//  PlayViewController.swift
//  BubblePopGame
//
//  Created by Leon Wang on 21/4/22.
//

import UIKit

class PlayViewController: UIViewController {

    let userDefaults = UserDefaults()

    @IBOutlet var countdownLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    
    var remainingTime = 60
    var score = 0
    var highscore = 0
    var timer = Timer()
    var bubble = Bubble()
    var maxBubbles = 0
    var bubbleArr = [Bubble]()
    var prev = 9999
    var highscoreDict = [String: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        scoreLabel.text = String(score)
        
        countdownLabel.text = String((userDefaults.value(forKey: "gameTime") as! Int)) + "s"
        remainingTime = userDefaults.value(forKey: "gameTime") as! Int
        highscore = userDefaults.value(forKey: "highScore") as! Int
        highScoreLabel.text = String(highscore)
        highscoreDict = userDefaults.value(forKey: "leaderboard") as! [String: Int]
        
        // Activate timer, and generate bubble each second
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            timer in
            self.counting()
            self.removeBubble()
            self.generateBubble()
        }
    }
    
    func checkHighScore(name: String){
        
        let playerName: String = userDefaults.value(forKey: "playerName") as! String
        if (userDefaults.value(forKey: playerName) == nil){
            userDefaults.set(score, forKey: playerName)
            highscoreDict.updateValue(score, forKey: playerName)
            userDefaults.setValue(highscoreDict, forKey: "leaderboard")
        } else {
            let playerScore: Int = userDefaults.value(forKey: playerName) as! Int
            if (playerScore < score){
                userDefaults.set(score, forKey: playerName)
                highscoreDict.updateValue(score, forKey: playerName)
                userDefaults.setValue(highscoreDict, forKey: "leaderboard")
            }
        }
    }
    
    @objc func counting() {
        remainingTime -= 1
        countdownLabel.text = String(remainingTime) + "s"
        
        if remainingTime == 0 {
            timer.invalidate()
            
            // Save score and check for high score
            let playerName: String = userDefaults.value(forKey: "playerName") as! String
            checkHighScore(name: playerName)
            
            // Show HighScore Screen
            let vc = storyboard?.instantiateViewController(identifier: "HighScoreViewController") as! HighScoreViewController
            self.navigationController?.pushViewController(vc, animated: true)
            vc.navigationItem.setHidesBackButton(true, animated: true)
        }
    }
    
    
    // Check if bubbles overlap
    func isOverlapped(newBubble: Bubble) -> Bool {
        for eachBubble in bubbleArr{
            if newBubble.frame.intersects(eachBubble.frame){
                return true
            }
        }
        return false
    }

    @objc func generateBubble(){
        
        let noBubbles = userDefaults.value(forKey: "noBubbles") as! Int
        let randomInt = Int.random(in: 0...noBubbles)
        var i = 0
                    
        while (i < randomInt && maxBubbles < noBubbles){ // Randomly decide how many bubbles shall display on screen
            // Create button object
            bubble = Bubble()
            // No overlap
            if (!isOverlapped(newBubble: bubble)){
                // Show button
                bubble.animation()
                self.view.addSubview(bubble)
                bubble.addTarget(self, action: #selector(bubblePressed), for: .touchUpInside)
                bubbleArr += [bubble]
                maxBubbles += 1
                i += 1
            }
        }
    }
    
    @objc func removeBubble(){  // Remove bubbles every second
        
        let randomInt = Int.random(in: 0...bubbleArr.count)
        var i = 0
        
        while (i < randomInt){
            let rand = bubbleArr.randomElement()
            // remove count of bubble
            maxBubbles -= 1
            // remove bubble from superview
            rand!.removeFromSuperview()
            // remove bubble from array
            if let index = bubbleArr.firstIndex(of: rand!){
                bubbleArr.remove(at: index)
            }
            i += 1
        }
    }
    
    @IBAction func bubblePressed(_ sender: Bubble) {
        
        // Add points to score
        if (sender.value == prev){
            let a = Double(sender.value)*1.5
            score += Int(a.rounded())
            prev = sender.value
        } else {
            score += sender.value
            prev = sender.value
        }
        
        // Remove count of bubble
        maxBubbles -= 1
        
        // Remove bubble at array when pressed
        if let index = bubbleArr.firstIndex(of: sender.self) {
            bubbleArr.remove(at: index)
        }
        
        scoreLabel.text = String(score)
        
        // Check for high score
        if score > highscore {
            highScoreLabel.text = scoreLabel.text
            userDefaults.setValue(score, forKey: "highScore")
        }
        
        // Remove pressed bubble from view
        sender.tapAnimation()
        if (userDefaults.value(forKey: "hitSound") as! String == "on"){
            sender.hitSound()
        }
    }


}
