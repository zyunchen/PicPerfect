//
//  PlayUIViewController.swift
//  PichPerfect
//
//  Created by zhangyunchen on 15/11/15.
//  Copyright © 2015年 zhangyunchen. All rights reserved.
//

import UIKit
import AVFoundation

class PlayUIViewController: UIViewController {
    
    var player:AVAudioPlayer?
    
    // the following three is just for echo effects
    var playerTwoForEcho:AVAudioPlayer?
    var playerThreeForEcho:AVAudioPlayer?
    var playerFourForEcho:AVAudioPlayer?
    
    var receivedAudio:RecordedAudio!
    
    var audioEngine: AVAudioEngine?
    var audioFile: AVAudioFile?
    var audioPlayerNode: AVAudioPlayerNode?
    
    var isPlaying:Bool = false
    
    override func viewDidLoad() {
        player = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        player?.enableRate = true
        
        audioEngine = AVAudioEngine()
        
         do {
            try audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl)
        }catch{
            print("there is sth wrong init aduoFile")
        }
    }
    
    @IBAction func playSlow(sender: UIButton) {
        stopPlaying()
        player?.rate = 0.5
        player?.play()
        isPlaying = true
    }
    
    @IBAction func playFast(sender: AnyObject) {
        stopPlaying()
        player?.rate = 2.0
        player?.play()
        isPlaying = true
    }
    
    @IBAction func playEcho(sender: AnyObject) {
        stopPlaying()
        isPlaying = true
        playerTwoForEcho = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        playerThreeForEcho = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        playerFourForEcho = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        player?.play()
        
        _ = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "timerFired1", userInfo: nil, repeats: false)
        _ = NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: "timerFired2", userInfo: nil, repeats: false)
        _ = NSTimer.scheduledTimerWithTimeInterval(0.9, target: self, selector: "timerFired3", userInfo: nil, repeats: false)
        
        
        
    }
    
    func timerFired1(){
        if isPlaying {
            playerTwoForEcho?.volume = 0.8
            playerTwoForEcho?.play()
        }
    }
    func timerFired2(){
        if isPlaying {
            playerThreeForEcho?.volume = 0.5
            playerThreeForEcho?.play()
        }
    }
    func timerFired3(){
        if isPlaying {
            playerFourForEcho?.volume = 0.1
            playerFourForEcho?.play()
        }
    }
    
    @IBAction func playChipmunkAudio(sender: AnyObject) {
        stopPlaying()
        playAudioWithVariablePich(1000)
        isPlaying = true
    }
    
    @IBAction func datchVader(sender: UIButton) {
        stopPlaying()
        playAudioWithVariablePich(-1000)
        isPlaying = true
    }
    
    
    func playAudioWithVariablePich(pitch:Float){

        
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine?.attachNode(audioPlayerNode!)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine?.attachNode(changePitchEffect)
        
        audioEngine?.connect(audioPlayerNode!, to: changePitchEffect, format: nil)
        audioEngine?.connect(changePitchEffect, to: audioEngine!.outputNode, format: nil)
        audioPlayerNode!.scheduleFile(audioFile!, atTime: nil, completionHandler: nil)
        do {
            try audioEngine?.start()
        }catch{
            print("cannot play due to some reason..")
        }
        audioPlayerNode!.play()
    }
    
    
    @IBAction func stopButton(sender: AnyObject) {
        stopPlaying()
    }
    
    func stopPlaying(){
        player?.stop()
        player?.rate = 1.0
        player?.currentTime = 0.0
        
        playerTwoForEcho?.stop()
        playerThreeForEcho?.stop()
        playerFourForEcho?.stop()
        audioPlayerNode?.stop()
        
        audioEngine?.stop()
        audioEngine?.reset()
        
        isPlaying = false
    }
}
