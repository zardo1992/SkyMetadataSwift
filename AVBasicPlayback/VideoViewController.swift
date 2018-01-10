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

class VideoViewController: UIViewController , XMLParserDelegate{
    
    //@Objects
    //=====================================================
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    var playerItem: AVPlayerItem!
    var spanString : String = ""
    var isError : Bool = false
    var trimmed : String = ""
    var firstTime : Bool = true
    var scrollToBottom : Bool = true


    
    //@IBOutlets
    //=====================================================
    @IBOutlet weak var textViewP: UITextView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var playPauseViewButton: UIView!
    
    //@IBActions
    //=====================================================
    @IBAction func goToBottom(_ sender: UIButton) {
        let stringLength:Int = self.textView.text.utf8CString.count
        self.textView.scrollRangeToVisible(NSMakeRange(stringLength-1, 0))
        scrollToBottom = true
        firstTime = true
    }
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
        if data.timedMetadata != nil{
        for item in data.timedMetadata! {
            
            var lastString: String
            
            lastString = textView.text
            
            if lastString == "NO META DATA RECEIVED" {
                textView.text = ""
            }
            
            
            if item.stringValue != nil {
          //  lastString = textView.text + "" + item.stringValue!
            
                let checkString:  String = item.stringValue!
                
                
                        var appendString = "****************  START EVENT  *****************\n"
                            + "\n"
                            + checkString
                            + "\n"
                            + "****************  END EVENT  *****************\n"
                

                appendString = appendString + "\n" + "\n" + "\n" + "\n" + "\n" + "\n"

                
                textView.text.append(appendString)
                
                if firstTime{
                if textView.isDragging{
                    scrollToBottom = false
                    firstTime=false
                }else{
                    scrollToBottom = true
                    }
                }
                    
                
                
                if scrollToBottom{
                let stringLength:Int = self.textView.text.utf8CString.count
                self.textView.scrollRangeToVisible(NSMakeRange(stringLength-1, 0))
                }
                
                //  let string  = textView.text
                //   let xml :String   = String(textView.text)
                
                
                
                if let dataText = checkString.data(using: .utf8) {
                    let parser = XMLParser(data: dataText)
                    print ("********* parser: " , parser , "   *****   ")
                    parser.delegate = self
                    parser.parse()
                    
                    if isError{
                        textView.layer.borderWidth = 2
                        textView.layer.borderColor = UIColor.red.cgColor
                    }else{
                        textView.layer.borderWidth = 2
                        textView.layer.borderColor = UIColor.green.cgColor
                    }
                }
                }
            }
            
        }
        }
    
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("Errore : ", parseError)
        isError=true
    }
    
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        print ("*** sono nel FOUNDCHARACTER")
        spanString = string;
         trimmed = spanString.trimmingCharacters(in: .whitespacesAndNewlines)
        print(" ************* trimmed :" ,trimmed,"*")
        if (trimmed != "" && trimmed != " "){
        textViewP.text = trimmed
            print ("********* textViewP", textViewP.text)
            
        }
        
    }
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        if elementName == "p" {
            let tempTag = P()
            
            if let id = attributeDict["id"] {
                tempTag.id = id;
            }
            if let region = attributeDict["begin"] {
                tempTag.region = region;
            }
            
        }
        if elementName == "span" {
            let tempTag = Span()
            
            if let style = attributeDict["style"] {
                
                tempTag.style = style;
            }
        }
    }
    
    
    override func viewDidLoad() {
        self.textView.layoutManager.allowsNonContiguousLayout = true

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
            
            playerItem!.addObserver(self, forKeyPath: "timedMetadata", options: n, context: nil)
            player = AVPlayer(playerItem: playerItem)
            
            // Create a player layer for the player.
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = videoView.layer.bounds
            videoView.layer.addSublayer(playerLayer!)
            player?.play()
        }
    }
}

class P
{
    var id = "";
    var region = "";
}
class Span
{
    var style = "";
}




