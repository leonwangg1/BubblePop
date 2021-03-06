//
//  HighScoreViewController.swift
//  BubblePopGame
//
//  Created by Leon Wang on 21/4/22.
//

import UIKit

class HighScoreViewController: UIViewController {

    @IBOutlet weak var highScoreTableView: UITableView!
    
    let userDefaults = UserDefaults()
    var namescore = [String: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if userDefaults.value(forKey: "playerName") == nil {
            userDefaults.setValue("ANONYMOUS", forKey: "playerName")
        }
        if userDefaults.value(forKey: "leaderboard") != nil {
            namescore = userDefaults.value(forKey: "leaderboard") as! [String : Int]
        }

    }
    
    @IBAction func returnMainPage(_ sender: UIButton) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}

extension HighScoreViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namescore.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "highScoreCell", for: indexPath)
        
        let sortedOne = namescore.sorted { (first, second) -> Bool in
            return first.value > second.value
        }

        cell.textLabel?.text = "\(sortedOne[indexPath.row].key)"
        cell.detailTextLabel?.text = "\(sortedOne[indexPath.row].value)"
        
        return cell
    }
    
    
}
