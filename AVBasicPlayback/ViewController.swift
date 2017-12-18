//
//  ViewController.swift
//  AVBasicPlayback
//
//  Created by Antonio Di Raffaele on 14/12/17.
//  Copyright © 2017 Antonio Di Raffaele. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {
    var Player: AVPlayer!
    var PlayerItem: AVPlayerItem!
    
    @IBAction func play(_ sender: Any) {
   
        // let url = URL(string: "http://test.hls.liveos.micdn.skycdn.it/ethan367/index.m3u8")
        let url = URL(string: "http://test.hls.liveos.micdn.skycdn.it/11519/pocv7/index.m3u8")
       // PlayerItem = AVPlayerItem(url: url!)
     
        let asset=AVURLAsset(url: url!)
        let PlayerItem=AVPlayerItem(asset: asset)

        //let player=AVPlayer(playerItem: item)
       

        let n = NSKeyValueObservingOptions()
        PlayerItem.addObserver(self, forKeyPath: "timedMetadata", options: n, context: nil)
        Player = AVPlayer(playerItem: PlayerItem)
        let controller = AVPlayerViewController()
                controller.player = Player
        
        
                // Modally present the player and call the player's play() method when complete.
                present(controller, animated: true) {
                    self.Player.play()
                }
    }
    
    
    
    override func observeValue(forKeyPath: String?, of: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if forKeyPath != "timedMetadata" { return }
        
        let data: AVPlayerItem = of as! AVPlayerItem
        for item in data.timedMetadata! {
            print(item.value!)
        }
        
        
  
        if forKeyPath != "error" { return }
        let data_: AVPlayerItem = of as! AVPlayerItem
        for item in data_.timedMetadata! {
            print(item.value!)
        }
        
//        for item in PlayerItem.error{
//            print(item.value)
//        }
        
        for item in data.timedMetadata! {
            print(item.value!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

