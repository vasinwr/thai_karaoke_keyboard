//
//  ViewController.swift
//  NewCustomKeyboard
//
//  Created by Vasin W on 18/08/2016.
//  Copyright © 2016 Vasin W. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    let defaults = NSUserDefaults(suiteName:"group.vasinwr.ThaiKaraokeKeyboard")
    
    //to see if realm works
    /*
    var datasource : Results<WordItem>!
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("anything")
        defaults!.setInteger(25, forKey: "x")
        
        //to see if realm works
        /*
        let realm = try! Realm()
        datasource = realm.objects(WordItem)
        print(datasource)
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func actionSaveData(sender: AnyObject) {
        print("saved")
        saveWord("pom", value:"ผม")
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

