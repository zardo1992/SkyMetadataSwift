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
    
    //@IBOutlets
    //=====================================================
    @IBOutlet weak var textField: UITextField!

    //@Objects
    //=====================================================
    var Player: AVPlayer!
    var PlayerItem: AVPlayerItem!
    var URL: String! = ""
    
    //@IBActions
    //=====================================================
    @IBAction func play(_ sender: Any) {
        self.URL = textField.text
        Shared.shared.stringValue = self.URL
        self.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "passToView", sender: self)
    }
    
    //@Override functions
    //=====================================================
    override func viewDidLoad() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
    }
    

}

//@ Other data structures
//=====================================================
final class Shared {
    static let shared = Shared()
    
    var stringValue : String!
}
