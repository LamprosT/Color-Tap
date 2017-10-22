//
//  GameOverViewController.swift
//  TripButton
//
//  Created by Lambros Tzanetos on 02/01/17.
//  Copyright © 2017 Mogul Asterovska. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {
    @IBOutlet var actualScoreDisplayLabel: UILabel!
    @IBOutlet var bestScoreDisplayLabel: UILabel!
    
    let defaults = UserDefaults.standard
    var scoreFromGameView = 0
    var colorOfBackground = UIColor.white
    var previousGameMode = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let checkIfHighScoreExists = defaults.object(forKey: "HighScore") as? Int {
            bestScoreDisplayLabel.text = String(checkIfHighScoreExists)
        }
        actualScoreDisplayLabel.text = String(scoreFromGameView)
        
        self.view.backgroundColor = colorOfBackground
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playAgain" {
            if let destination = segue.destination as? ViewController {
               destination.selectedMode = self.previousGameMode
            }
        }
    }

    
  
    @IBAction func muteMusic(_ sender: Any) {
        if bgMusicPlayer.volume != 0 {
            bgMusicPlayer.volume = 0
        } else {
            bgMusicPlayer.volume = 0.6
        }
    }
    
    
    @IBAction func muteSound(_ sender: Any) {
        if selectPlayer.volume != 0 { //no need to check for both sound players
            selectPlayer.volume = 0
            errorPlayer.volume = 0
        } else {
            selectPlayer.volume = 1
            errorPlayer.volume = 1
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
