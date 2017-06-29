//
//  RecordSoundViewController.swift
//  PitchPerfect
//
//  Created by Derek Justus on 6/13/17.
//  Copyright © 2017 Derek Justus. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        toggleUI(active: false)
    }


    @IBAction func recordAudio(_ sender: Any) {
        
        toggleUI(active: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self;
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    
    }
    @IBAction func stopRecording(_ sender: Any) {
        
       toggleUI(active: false)
        audioRecorder.stop()
    }
    
    func toggleUI(active isRecording: Bool) {
      
        recordingLabel.text = isRecording ? "Recording in Progress" : "Tap to Record"
            stopRecordingButton.isEnabled = isRecording
            recordButton.isEnabled = !isRecording

    }   
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

extension RecordSoundViewController: AVAudioRecorderDelegate {
    // Mark: AV implentation
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Error while recording")
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("issue with encoding")
    }

    
}

