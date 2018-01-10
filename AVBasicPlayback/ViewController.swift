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

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //@IBOutlets
    //=====================================================
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    
    //@Objects
    //=====================================================
    var URL: String! = ""
    var links: [String] = []
    var fullLinks: [String] = []
    
    //@IBActions
    //=====================================================
    @IBAction func play(_ sender: Any) {
        self.URL = textField.text
        Shared.shared.stringValue = self.URL
        self.dismiss(animated: true, completion: nil)
        links.removeAll()
        fullLinks.removeAll()
        self.performSegue(withIdentifier: "passToView", sender: self)
    }
    
    //@Override functions
    //=====================================================
    override func viewDidLoad() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let path = Bundle.main.path(forResource: "video", ofType: "urls") {
            do {
                links.append("")
                fullLinks.append("")
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let lines = data.components(separatedBy: .newlines)
                for line in lines {
                    let splitted = line.components(separatedBy: "$")
                    if splitted.count > 1 {
                        links.append("\(splitted[0])")
                        fullLinks.append("\(splitted[1])")
                    }
                }
            } catch {
                print(error)
            }
        }
        
        picker.dataSource = self
        picker.delegate = self
        textField.becomeFirstResponder()
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
    }
    
    //@Functions
    //=====================================================
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return links.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return links[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = fullLinks[picker.selectedRow(inComponent: 0)]
    }

}

//@ Other data structures
//=====================================================
final class Shared {
    static let shared = Shared()
    
    var stringValue : String!
}
