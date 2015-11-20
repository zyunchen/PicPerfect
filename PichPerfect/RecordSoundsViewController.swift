//
//  RecordSoundsViewController.swift
//  PichPerfect
//
//  Created by zhangyunchen on 15/11/15.
//  Copyright © 2015年 zhangyunchen. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recodingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var recorder:AVAudioRecorder?
    var recordedAudio: RecordedAudio!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true)
        recorder = try! AVAudioRecorder(URL: NSURL(fileURLWithPath: "\(paths[0])/sound.wav"), settings: ["":""])
        recorder?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        stopButton.hidden = true
        recordButton.enabled = true
    }

    @IBAction func recordAudio(sender: UIButton) {
        //TODO: "record user's voice"
        beginRecording()
        print("in record Audio")
    }

    @IBAction func stopAction(sender: UIButton) {
        stopRecording()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            recordedAudio = RecordedAudio(filepath: recorder.url,title: recorder.url.lastPathComponent!)
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            print("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecording"{
            let playSoundsVC:PlayUIViewController = segue.destinationViewController as! PlayUIViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    func beginRecording(){
        recodingLabel.text = "Recording"
        stopButton.hidden = false
        recordButton.enabled = false
        recorder?.record()
    }
    
    func stopRecording(){
        recodingLabel.text = "Tap to Record"
        stopButton.hidden = true
        recordButton.enabled = true
        recorder?.stop()
    }
}

