//
//  ViewController.swift
//  NewCustomKeyboard
//
//  Created by Vasin W on 18/08/2016.
//  Copyright © 2016 Vasin W. All rights reserved.
//

import UIKit
import RealmSwift
import MMWormhole

class ViewController: UIViewController {
    
    let defaults = NSUserDefaults(suiteName:"group.vasinwr.ThaiKaraokeKeyboard")
    let defaultCenter = NSNotificationCenter.defaultCenter()
    let wormhole = MMWormhole(applicationGroupIdentifier: "group.vasinwr.ThaiKaraokeKeyboard", optionalDirectory: "wormhole")
    
    //to see if realm works
    /*
    var datasource : Results<WordItem>!
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        defaultCenter.addObserver(self, selector: #selector(wordKeyChanged), name: NSUserDefaultsDidChangeNotification, object: nil)
        
        print("anything")
        
        //to see if realm works
        /*
        let realm = try! Realm()
        datasource = realm.objects(WordItem)
        print(datasource)
        */
        
        wormhole.listenForMessageWithIdentifier("messageIdentifier", listener: { (messageObject) -> Void in
            if let message: AnyObject = messageObject {
                print("aeh")
            }
        })
        
    }
    
    @objc func wordKeyChanged() {
        print("wordKeyChanged called")
        let wordKey = defaults?.objectForKey("wordKey") as! String
        print(wordKey + " received in containing app") // TODO: change this line to realm query
        defaults?.setObject(["ddd","eee"], forKey: "wordSuggestions")
        //defaults?.synchronize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func actionSaveData(sender: AnyObject) {
        print("saved")
        saveWord("pom", value:"ผม")
        /* change defaults to see if notification is fired (it is only within same process)
        defaults!.setObject("hey", forKey: "wordKey")
        print("ho")
        //defaults?.synchronize()
        */
    }
    
    func saveWord(key:String, value:String) {
        let newWord = WordItem()
        newWord.key = key
        newWord.value = value
        let realm = try! Realm()
        try! realm.write {
            realm.add(newWord)
            print("word saved")
        }
    }

}

