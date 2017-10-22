//
//  MainMenuViewController.swift
//  TripButton
//
//  Created by Lambros Tzanetos on 02/01/17.
//  Copyright © 2017 Mogul Asterovska. All rights reserved.
//

import UIKit
import AVFoundation

var errorPlayer = AVAudioPlayer()
let errorAudioPath = Bundle.main.path(forResource: "errorSound", ofType: "wav")

var bgMusicPlayer = AVAudioPlayer()
let bgMusicAudioPath = Bundle.main.path(forResource: "tripColourBGMusic", ofType: "wav")

var selectPlayer = AVAudioPlayer()
let selectAudioPath = Bundle.main.path(forResource: "selectNew", ofType: "mp3")

var hasPlayedBgMusic = false

class MainMenuViewController: UIViewController {
    
    var gameMode: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if !hasPlayedBgMusic {
            do { //checks error player
                try errorPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: errorAudioPath!))
            } catch  {
            }
            
            do { //checks bgMusic player
                try bgMusicPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: bgMusicAudioPath!))
            } catch  {
            }
            
            do { //checks select player
                try selectPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: selectAudioPath!))
            } catch  {
            }
        

            bgMusicPlayer.numberOfLoops = -1
            bgMusicPlayer.volume = 0.6
            
            bgMusicPlayer.play()
            hasPlayedBgMusic = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectGameMode(sender: UIButton) {
        if sender.tag == 1 {
            gameMode = "ArcadeMode"
        } else {
            gameMode = "PracticeMode"
        }
        performSegue(withIdentifier: "goToGameplay", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGameplay" {
            if let destination = segue.destination as? ViewController {
                destination.selectedMode = gameMode
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


}
