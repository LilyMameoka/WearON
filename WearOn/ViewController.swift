//
//  ViewController.swift
//  WearOn
//
//  Created by Lily.Mameoka on 2019/07/21.
//  Copyright © 2019 Lily.Mameoka. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import AudioToolbox

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    
    var modeValue : Int = 1
    var shakeValue : Int = 1
    var blindValue = true
    
    @IBOutlet var minusButton: UIButton!//擬似音量プラス
    @IBOutlet var pulseButton: UIButton!//擬似音量マイナス
    @IBOutlet var blindImage: UIImageView!
    @IBOutlet var blindButton: UISwitch!
    @IBOutlet var shakeChoice: UISegmentedControl!
    @IBOutlet var modeChoice: UISegmentedControl!
    
    var audioPlayer : AVAudioPlayer!
    var selectedSoundFileName = ""
    
    @IBAction func pulsePressed(_ sender: Any) {
        
        if audioPlayer != nil {
            audioPlayer.volume = 10
        }
        playSoundPulse(fileName: "note1", Expand: "wav")//for test
        print(String(shakeValue) + String(modeValue))
        
    }
    
    @IBAction func minusPressed(_ sender: Any) {
        
        if audioPlayer != nil {
            audioPlayer.volume = 10
        }
        playSoundPulse(fileName: "note5", Expand: "wav")//for test
        print(String(shakeValue) + String(modeValue))
        
    }
    
    @IBAction func shakeChange(_ sender: Any) {
        
        if blindValue {
            switch (sender as AnyObject).selectedSegmentIndex {
            case 0:
                shakeModeAction(choiceSender: 1)
            case 1:
                shakeModeAction(choiceSender: 2)
            case 2:
                shakeModeAction(choiceSender: 3)
            case 3:
                shakeModeAction(choiceSender: 0)
            default:
                print("エラ〜")
            }
        }
        
    }
    
    @IBAction func defaulChoice(_ sender: Any) {
        
        if blindValue {
            switch (sender as AnyObject).selectedSegmentIndex {
            case 0:
                defaultModeAction(choiceSender: 1)
            case 1:
                defaultModeAction(choiceSender: 2)
            case 2:
                defaultModeAction(choiceSender: 3)
            case 3:
                defaultModeAction(choiceSender: 4)
            case 4:
                defaultModeAction(choiceSender: 5)
            case 5:
                defaultModeAction(choiceSender: 6)
            case 6:
                defaultModeAction(choiceSender: 7)
            case 7:
                defaultModeAction(choiceSender: 8)
            case 8:
                defaultModeAction(choiceSender: 9)
            case 9:
                defaultModeAction(choiceSender: 0)
            default:
                print("エラ〜")
            }
        }
        
    }
    
    func shakeModeAction(choiceSender : Int){
        
        shakeValue = choiceSender
        print("ShakeMode:" + String(choiceSender))
        
    }
    
    func defaultModeAction(choiceSender : Int){
        
        modeValue = choiceSender
        print("defaultMode:" + String(choiceSender))
        
    }
    
    @IBAction func blindPressed(_ sender: UISwitch) {
        
        if sender.isOn{
            blindImage.image = UIImage(named: "scelton.png")
            blindValue = true
            print("Blind")
        }
        if !sender.isOn{
            blindImage.image = UIImage(named: "blind.png")
            blindValue = false
            print("scelton")
            
        }
        
    }
    
    func pulseAction(){
        
        playSoundPulse(fileName: String(modeValue)  + String(1), Expand: "wav")
        
    }
    
    func minusAction(){
        
        playSoundPulse(fileName: String(modeValue)  + String(0), Expand: "wav")
        
    }
    
    func playSound() {
        
        let soundURL = Bundle.main.url(forResource: selectedSoundFileName, withExtension: "wav")
        
        audioPlayer = try! AVAudioPlayer(contentsOf: soundURL!)
        
        audioPlayer.play()
    }
    
    func playSoundPulse(fileName:String,Expand : String) {
        
        let soundURL = Bundle.main.url(forResource: fileName, withExtension: Expand)
        
        audioPlayer = try! AVAudioPlayer(contentsOf: soundURL!)
        
        audioPlayer.play()
    }
    
    //音量ボタン検知　https://teratail.com/questions/155302
    
    @objc func volumeChanged(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            if let volumeChangeType = userInfo["AVSystemController_AudioVolumeChangeReasonNotificationParameter"] as? String {
                if volumeChangeType == "ExplicitVolumeChange" {
//                    print("changed! \(userInfo)")
                    print("ok")
                    nemeAccessPlaySound(name: "EyePower")
                    audioPlayer.volume -= 0.1
                    
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        modeChoice.frame = CGRect(x: 51, y: 300, width: 732, height: 70)
        shakeChoice.frame = CGRect(x: 238 , y: 112, width: 227, height: 50)
        modeChoice.tintColor = UIColor(red: 113/255, green: 243/255, blue: 73/255, alpha: 1)
        modeChoice.backgroundColor = UIColor.clear
        shakeChoice.tintColor = UIColor(red: 113/255, green: 243/255, blue: 73/255, alpha: 1)
        modeChoice.backgroundColor = UIColor.clear
        let volumeView = MPVolumeView(frame: CGRect(origin:CGPoint(x:/*-3000*/ 0, y:0), size:CGSize.zero))
        self.view.addSubview(volumeView)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.volumeChanged(notification:)), name:
            NSNotification.Name("AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
        
    }
    
    func nemeAccessPlaySound(name: String){
        
        guard let path = Bundle.main.path(forResource: name, ofType: "mp3") else {
            print("I cannot find any music file...")
            return
        }
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            
            audioPlayer.delegate = self
            
            audioPlayer.play()
        } catch {
        }
    }
}

