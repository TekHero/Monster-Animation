//
//  ViewController.swift
//  My-Little-Monster
//
//  Created by Brian Lim on 12/6/15.
//  Copyright © 2015 codebluapps. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var monsterImg: MonsterImg!
    @IBOutlet weak var foodImg: DragImg!
    @IBOutlet weak var heatImg: DragImg!
    @IBOutlet weak var penalty1Img: UIImageView!
    @IBOutlet weak var penalty2Img: UIImageView!
    @IBOutlet weak var penalty3Img: UIImageView!
    
    let DIM_ALPHA:CGFloat = 0.2
    let OPAQUE:CGFloat = 1.0
    let MAX_PENALTIES = 3
    
    var penalties = 0
    var timer: NSTimer!
    var monsterHappy = false
    var currentItem: UInt32 = 0
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // When the view loads, the drop targets for both the food & heart images are set to the monstar image
        foodImg.dropTarget = monsterImg
        heatImg.dropTarget = monsterImg
        
        // Sets the penalty images to the alpa value of the DIM_ALPHA constant
        penalty1Img.alpha = DIM_ALPHA
        penalty2Img.alpha = DIM_ALPHA
        penalty3Img.alpha = DIM_ALPHA
        
        // Adds a observer that looks out for a message that was sent, if one is recieved, then the function is called
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("itemDroppedOnCharacter:"), name: "onTargetDropped", object: nil)
        
        // Setting the audio players to the path of the sound
        do {
            try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            // Preparing the audio players to play, so that it plays much faster
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            sfxBite.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxSkull.prepareToPlay()
            
        // Catching any errors that may occur
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        // Starts the timer for the game
        startTimer()
    }
    
    // This function is called when the notification was recieved
    func itemDroppedOnCharacter(notif: AnyObject) {
        monsterHappy = true
        startTimer()
        
        foodImg.alpha = DIM_ALPHA
        foodImg.userInteractionEnabled = false
        heatImg.alpha = DIM_ALPHA
        heatImg.userInteractionEnabled = false
        
        if currentItem == 0 {
            sfxHeart.play()
        } else {
            sfxBite.play()
        }
    }
    
    @IBAction func playAgainBtnPressed(sender: AnyObject) {
        
    }
    
    
    func startTimer() {
        // Checking to see if the timer is playing, if it is playing, then stop it but if not then play it
        if timer != nil {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: Selector("changeGameState"), userInfo: nil, repeats: true)
        
    }
    
    func changeGameState() {
        
        // Checking to see if the monster is happy or not, if it is not then the following penalties could happen
        if !monsterHappy {
            
            penalties++
            sfxSkull.play()
            if penalties == 1 {
                penalty1Img.alpha = OPAQUE
                penalty2Img.alpha = DIM_ALPHA
            } else if penalties == 2 {
                penalty2Img.alpha = OPAQUE
                penalty3Img.alpha = DIM_ALPHA
            } else if penalties >= 3 {
                penalty3Img.alpha = OPAQUE
            } else {
                penalty1Img.alpha = DIM_ALPHA
                penalty2Img.alpha = DIM_ALPHA
                penalty3Img.alpha = DIM_ALPHA
            }
            
            if penalties >= MAX_PENALTIES {
                gameOver()
            }
        }
        
        let rand = arc4random_uniform(2) // 0 or 1
        if rand == 0 {
            foodImg.alpha = DIM_ALPHA
            foodImg.userInteractionEnabled = false
            
            heatImg.alpha = OPAQUE
            heatImg.userInteractionEnabled = true
        } else {
            heatImg.alpha = DIM_ALPHA
            heatImg.userInteractionEnabled = false
            
            foodImg.alpha = OPAQUE
            foodImg.userInteractionEnabled = true
        }
        
        currentItem = rand
        monsterHappy = false
        
    }
    
    // When the game is over, this function is fired
    func gameOver() {
        // Stops the timer
        timer.invalidate()
        // Starts the animation of the rock monster dying
        monsterImg.playDeathAnimation()
        // Plays the sound of the death of the rock monster
        sfxDeath.play()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

