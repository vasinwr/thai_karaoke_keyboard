//
//  ViewController.swift
//  NewCustomKeyboard
//
//  Created by Vasin W on 18/08/2016.
//  Copyright © 2016 Vasin W. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let defaults = NSUserDefaults(suiteName:"group.vasinwr.ThaiKaraokeKeyboard")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("anything")
        defaults!.setInteger(25, forKey: "x")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func actionSaveData(sender: AnyObject) {
        print("saved")
    }

}

