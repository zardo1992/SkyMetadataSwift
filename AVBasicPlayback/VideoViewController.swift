//
//  VideoViewController.swift
//  AVBasicPlayback
//
//  Created by Matteo Zardoni on 18/12/17.
//  Copyright © 2017 Antonio Di Raffaele. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Foundation

class VideoViewController: UIViewController {
    
    //@Objects
    //=====================================================
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    var playerItem: AVPlayerItem!
    
    //@IBOutlets
    //=====================================================
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var playPauseViewButton: UIView!
    
    //@IBActions
    //=====================================================
    @IBAction func eraseTextView(_ sender: Any) {
        textView.text = ""
    }
    
    @IBAction func copyToClipboard(_ sender: Any) {
        UIPasteboard.general.string = textView.text
    }
    
    @IBAction func goBack(_ sender: Any) {
        textView.text = ""
        player.pause()
        player = nil
        self.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "returnToView", sender: self)
    }
    
    
    //@Override functions
    //=====================================================
    override func observeValue(forKeyPath: String?, of: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if forKeyPath != "timedMetadata" {
            return
        }
        
        let data: AVPlayerItem
            
        data = of as! AVPlayerItem
        
        for item in data.timedMetadata! {
            
            var lastString: String
                
            lastString = textView.text
            if lastString == "NO META DATA RECEIVED" {
                textView.text = ""
            }
            
            if item.stringValue != nil {
                lastString = textView.text + " " + item.stringValue!
                textView.text = lastString
                
                if let dataText = textView.text.data(using: .utf8) {
                    let parser = XMLParser(data: dataText)
                    let success : Bool = parser.parse()
                    
                    if success {
                        textView.layer.borderWidth = 1
                        textView.layer.borderColor = UIColor.green.cgColor
                    } else {
                        textView.layer.borderWidth = 1
                        textView.layer.borderColor = UIColor.red.cgColor
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.black.cgColor
        
        if let value = Shared.shared.stringValue {
            
            guard let contentURL = URL(string: value) else {
                let alert = UIAlertController(title: "A problem occurred!", message: "ERROR! \nPlease use a valid URL for the content URL", preferredStyle: UIAlertControllerStyle.alert)
                
                self.present(alert, animated: true, completion: nil)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                    
                    switch action.style {
                        case .default:
                            print("default")

                            self.textView.text = ""
                            self.player = nil
                            self.dismiss(animated: true, completion: nil)
                        
                        case .cancel:
                            print("cancel")
                       
                        
                        case .destructive:
                            print("destructive")
                    
                    
                    }
                }))

                return
            }

            let n = NSKeyValueObservingOptions()
            let asset = AVURLAsset(url: contentURL)
            playerItem = AVPlayerItem(asset: asset)
        
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(accessLogEvent),
                                                   name: NSNotification.Name.AVPlayerItemNewAccessLogEntry,
                                                   object: nil)
           
            playerItem!.addObserver(self, forKeyPath: "timedMetadata", options: n, context: nil)
            player = AVPlayer(playerItem: playerItem)

            // Create a player layer for the player.
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = videoView.layer.bounds
            videoView.layer.addSublayer(playerLayer!)
            player?.play()
        }
    }
    
    //Functions
    //=====================================================
    @objc
    func accessLogEvent(notification: NSNotification) {
        guard let item = notification.object as? AVPlayerItem,
            let accessLog = item.accessLog() else {
                return
        }
        for event in accessLog.events {
            print(String(event.uri!))
        }
    }
}

