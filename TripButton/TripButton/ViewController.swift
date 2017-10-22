//
//  ViewController.swift
//  TripButton
//
//  Created by Lambros Tzanetos on 24/07/16.
//  Copyright © 2016 Mogul Asterovska. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var practiceModeHomeButton: UIButton!
    
    @IBOutlet var progressBarImageView: UIImageView!
    var progressTimer = Timer()  //timer used to animate the progress bar
    var initialProgressWidth: CGFloat = 0.0
    var initialPositionProgress = CGPoint(x: 0, y: 0) //the initial position of the image view is assigned to this variable
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet var button4: UIButton!
    @IBOutlet var button5: UIButton!
    @IBOutlet var button6: UIButton!
    @IBOutlet var button7: UIButton!
    @IBOutlet var button8: UIButton!
    @IBOutlet var button9: UIButton!
    @IBOutlet var button10: UIButton!
    @IBOutlet var button11: UIButton!
    @IBOutlet var button12: UIButton!
    @IBOutlet var button13: UIButton!
    @IBOutlet var button14: UIButton!
    @IBOutlet var button15: UIButton!
    @IBOutlet var button16: UIButton!
    
    @IBOutlet var additionalTimeLabel: UILabel!
    @IBOutlet var extraTimeIndicator: UILabel!
    @IBOutlet var buttonsPressedIndicator: UILabel!
    @IBOutlet var playButtonWhenPaused: UIImageView!
    @IBOutlet var restartButtonWhenPaused: UIImageView!
    @IBOutlet var homeButtonWhenPaused: UIImageView!
    var arrayOfButtons = [UIButton]()
    @IBOutlet var pauseButton: UIButton!
    var arrayOfPausedButtons = [UIImageView]()
    
    let maxInitialTimer = 10
    
    var scoreCounterVar = 0
    var timer = Timer()  //timer used to count remaining time
    var blackNumber = 0
    var timerValue = 10
    var gameHasNotStarted = true
    var buttonsPressed = 0
    let buttonsNeeded = 8
    var gameOverBool = false
    let additionalTime = 5
    var isPaused = false
    
    
    let defauls = UserDefaults.standard
    var highScore = 0
   
    var selectedMode: String = ""
    
    
    //otan kapio ginete mavro vazo to tag tou se variable
    
    func startGame() { //is called to setup game
        
        timerValue = maxInitialTimer
        scoreLabel.text = "0"
        if selectedMode == "ArcadeMode" {
            timerLabel.text = String(maxInitialTimer)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.timeProcess), userInfo: nil, repeats: true)
            progressTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(ViewController.progressTimerProcess), userInfo: nil, repeats: true)
        }
        
        buttonsPressed = 0
        scoreCounterVar = 0
        gameHasNotStarted = false
        gameOverBool = false
        
        let randomNum = Int(arc4random_uniform(UInt32(arrayOfButtons.count)))
        arrayOfButtons[randomNum].backgroundColor = UIColor.black //uses the random number generated to make create the first button that has to be pressed
        blackNumber = arrayOfButtons[randomNum].tag
        
        progressBarImageView.frame.size.width = initialProgressWidth
        progressBarImageView.frame.origin = initialPositionProgress

        additionalTimeLabel.isHidden = true
        additionalTimeLabel.alpha = 1
        extraTimeIndicator.isHidden = true
        extraTimeIndicator.alpha = 1
        
        buttonsPressedIndicator.text = "Extra Time: \(buttonsPressed)/\(buttonsNeeded)"
        
        if isPaused {
            pause(self) //in the case that the game is paused
        }
    
    }
    
    @IBAction func playButtonStart(_ sender: AnyObject) {
        
        if timer.isValid {
            timer.invalidate()
        }
        
        if progressTimer.isValid {
            progressTimer.invalidate()
        }
        
        if playButton.titleLabel?.text == "Play" {
            startGame()
            playButton.setTitle("Restart", for: UIControlState.normal)
        } else {
            for button in arrayOfButtons { //randomizes all colours of buttons and gets rid of already black button
                button.backgroundColor = getRandomColour()
            }
            startGame()
        }
    
    }
    
    
    func getRandomColour() -> UIColor {
        let randomRed:CGFloat = CGFloat(drand48())
        
        let randomGreen:CGFloat = CGFloat(drand48())
        
        let randomBlue:CGFloat = CGFloat(drand48())
        
        let resultColour = UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
        if resultColour != UIColor.black {
            return resultColour
        } else {
            return getRandomColour()
        }
    }
    


    
    @IBAction func buttonPress(sender: UIButton) { //vazo antistoixa sounds
        if gameOverBool == false && gameHasNotStarted == false {
            if sender.tag == blackNumber {  //if the correct button is pressed and the game is going on
                if selectPlayer.isPlaying {
                    selectPlayer.stop()
                    setupSelectPlayer()
                }
                selectPlayer.play()
                scoreCounterVar += 1
                scoreLabel.text = "\(scoreCounterVar)"
                
                self.view.backgroundColor = getRandomColour() //adjust the background colour to a random one
                
                for button in arrayOfButtons { //randomizes all colours of buttons
                    button.backgroundColor = getRandomColour()
                }
                
                let randomNum = Int(arc4random_uniform(UInt32(arrayOfButtons.count)))
                
                arrayOfButtons[randomNum].backgroundColor = UIColor.black
                blackNumber = arrayOfButtons[randomNum].tag
                if selectedMode == "ArcadeMode" {
                    buttonsPressed += 1
                }
                buttonsPressedIndicator.text = "Extra Time: \(buttonsPressed)/\(buttonsNeeded)"
                
                if buttonsPressed == buttonsNeeded {
                    timerValue += additionalTime
                    if timerValue > maxInitialTimer {
                        timerValue = maxInitialTimer
                    }
                    timerLabel.text = String(timerValue)
                    progressBarImageView.frame.size.width += (initialProgressWidth/CGFloat(maxInitialTimer)) * CGFloat(additionalTime)
                    
                    additionalTimeLabel.alpha = 1
                    additionalTimeLabel.isHidden = false
                    extraTimeIndicator.text = "+\(additionalTime)"
                    extraTimeIndicator.isHidden = false
                    extraTimeIndicator.alpha = 1
                    UIView.animate(withDuration: 1, animations: {
                        self.additionalTimeLabel.alpha = 0
                        self.extraTimeIndicator.alpha = 0
                    })
                    
                    buttonsPressed = 0
                }
            } else {
                if selectedMode == "ArcadeMode" {
                    timerValue -= 2
                    errorPlayer.play()
                    
                    if timerValue > 0 {
                        timerLabel.text = String(timerValue)
                        progressBarImageView.frame.size.width -= (initialProgressWidth/CGFloat(maxInitialTimer)) * 2
                    } else {
                        timerHasReachedZero()
                    }
                }
            }
        }
    }
    

    
    func progressTimerProcess() {
        let deductionAmount = initialProgressWidth/(CGFloat(maxInitialTimer)/0.01)   //0.001 is the time period for which the function is called
        progressBarImageView.frame.size.width -= deductionAmount
    }
    

    func timeProcess(){
        timerValue -= 1
        
        if timerValue == 0 { //ta vazo se function
            timerHasReachedZero()
        }
        else if timerValue > 0 {
            timerLabel.text = String(timerValue)
            
        }
    }
    
    
    @IBAction func pause(_ sender: Any) {
        if isPaused {
            changeFromPause(isPausedParameter: isPaused)
            isPaused = !isPaused
            if !(timer.isValid && progressTimer.isValid) {
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.timeProcess), userInfo: nil, repeats: true)
                progressTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(ViewController.progressTimerProcess), userInfo: nil, repeats: true)
            }
        } else {
            changeFromPause(isPausedParameter: isPaused)
            isPaused = !isPaused
            timer.invalidate()
            progressTimer.invalidate()
        }
        
        for button in arrayOfButtons {
            if button.isUserInteractionEnabled {
                button.isUserInteractionEnabled = false
            } else {
                button.isUserInteractionEnabled = true
            }
        }
        
    }
    
    
    func changeFromPause(isPausedParameter: Bool) {
        for button in arrayOfPausedButtons {
            button.isHidden = isPausedParameter
            button.alpha = floor(abs(button.alpha - 1))
            button.isUserInteractionEnabled = !isPausedParameter
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if isPaused && touch.view == playButtonWhenPaused {
                pause(self)
            } else if isPaused && touch.view == restartButtonWhenPaused {
                playButtonStart(self) //restarts game
            } else if isPaused && touch.view == homeButtonWhenPaused {
                performSegue(withIdentifier: "goHomeArcade", sender: self)
            }
        }
    }
    
        
    func setupSelectPlayer() {
        do { //checks select player
            try selectPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: selectAudioPath!))
        } catch  {
        }
    }


    func timerHasReachedZero() {
        timerValue = 0
        progressBarImageView.frame.size.width = 0
        buttonsPressed = 0
        timer.invalidate()
        progressTimer.invalidate()
        timerLabel.text = String(timerValue)
        gameOverBool = true
        gameHasNotStarted = true
        goToGameOverView()
    }
    
    func goToGameOverView() {
        if scoreCounterVar > highScore {  //checks if the score was higher than the highScore and acts according to the situation
            defauls.set(scoreCounterVar, forKey: "HighScore")
            highScore = scoreCounterVar
        }
        performSegue(withIdentifier: "goToGameOverView", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        arrayOfButtons = [button1, button2, button3, button4, button5, button6, button7, button8, button9, button10, button11, button12, button13, button14, button15, button16]
        
        initialProgressWidth = progressBarImageView.frame.size.width
        initialPositionProgress = progressBarImageView.frame.origin
        
        self.view.backgroundColor = getRandomColour() //adjust the background colour to a random one
        
        buttonsPressedIndicator.text = "Extra Time: \(buttonsPressed)/\(buttonsNeeded)"
        

        if selectedMode == "PracticeMode" { //makes the button pressed counter not visible
            buttonsPressedIndicator.isHidden = true
            timerLabel.text = "No Pressure"
            pauseButton.isHidden = true
            pauseButton.isUserInteractionEnabled = false
        } else {
            practiceModeHomeButton.isEnabled = false
            practiceModeHomeButton.isHidden = true
            timerLabel.text = String(maxInitialTimer)
        }
       
        
        progressBarImageView.layer.zPosition = -2
        scoreLabel.layer.zPosition = -1
        extraTimeIndicator.layer.zPosition = -1
        
        if let checkIfHighScoreExists = defauls.object(forKey: "HighScore") as? Int{
            highScore = checkIfHighScoreExists
        } else {
            highScore = 0
            defauls.set(0, forKey: "HighScore")
        }
        
        arrayOfPausedButtons = [playButtonWhenPaused, restartButtonWhenPaused, homeButtonWhenPaused]
        changeFromPause(isPausedParameter: isPaused)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGameOverView" {
            if let destination = segue.destination as? GameOverViewController {
                destination.scoreFromGameView = self.scoreCounterVar
                destination.colorOfBackground = self.view.backgroundColor!
                destination.previousGameMode = self.selectedMode
            }
        }
    }
    


}



