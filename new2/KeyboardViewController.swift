//
//  KeyboardViewController.swift
//  new2
//
//  Created by Vasin W on 18/08/2016.
//  Copyright © 2016 Vasin W. All rights reserved.
//

import UIKit
import MMWormhole

class KeyboardViewController: UIInputViewController {
    
    var label :UILabel? = nil
    let suggestionsContainer = UIView(frame: CGRectMake(160, 0, 160, 40))
    let defaults: NSUserDefaults = NSUserDefaults(suiteName: "group.vasinwr.ThaiKaraokeKeyboard")!
    let wormhole = MMWormhole(applicationGroupIdentifier: "group.vasinwr.ThaiKaraokeKeyboard", optionalDirectory: "wormhole")
    

    @IBOutlet var nextKeyboardButton: UIButton!

    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Perform custom UI setup here
        
        //original code
        
        self.nextKeyboardButton = UIButton(type: .System)
    
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), forState: .Normal)
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
    
        self.nextKeyboardButton.addTarget(self, action: #selector(advanceToNextInputMode), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(self.nextKeyboardButton)
    
        self.nextKeyboardButton.leftAnchor.constraintEqualToAnchor(self.view.leftAnchor).active = true
        self.nextKeyboardButton.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor).active = true
        

        //addition
        
        let buttonTitles1 = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"]
        let buttonTitles2 = ["A", "S", "D", "F", "G", "H", "J", "K", "L"]
        let buttonTitles3 = ["Z", "X", "C", "V", "B", "N", "M", "bs"]
        let buttonTitles4 = ["space"]
        
        let buttons1 = createButtons(buttonTitles1)
        let buttons2 = createButtons(buttonTitles2)
        let buttons3 = createButtons(buttonTitles3)
        let buttons4 = createButtons(buttonTitles4)
        
        let topRow = UIView(frame: CGRectMake(0, 40, 320, 40))
        let secRow = UIView(frame: CGRectMake(0, 80, 320, 40))
        let thrRow = UIView(frame: CGRectMake(0, 120, 320, 40))
        let fthRow = UIView(frame: CGRectMake(0, 160, 320, 40))
        
        for button in buttons1 {
            topRow.addSubview(button)
        }
        for button in buttons2 {
            secRow.addSubview(button)
        }
        for button in buttons3 {
            thrRow.addSubview(button)
        }
        for button in buttons4 {
            fthRow.addSubview(button)
        }
        
        self.view.addSubview(topRow)
        self.view.addSubview(secRow)
        self.view.addSubview(thrRow)
        self.view.addSubview(fthRow)
        
        addConstraints(buttons1, containingView: topRow)
        addConstraints(buttons2, containingView: secRow)
        addConstraints(buttons3, containingView: thrRow)
        addConstraints(buttons4, containingView: fthRow)
 
        /* label - top left of keyboard */
        label = UILabel(frame: CGRectMake(0, 0, 160, 40))
        label!.textAlignment = NSTextAlignment.Center
        label!.text = ""
        self.view.addSubview(label!)
        
        /* suggestions - top right */
        self.view.addSubview(suggestionsContainer)
        
        //read from shared container
        //print(defaults.objectForKey("values"))
    }
    
    func createButtons(titles: [String]) -> [UIButton] {
    
        var buttons :[UIButton] = [UIButton]()
    
        for title in titles {
            let button = UIButton(type: .System) as UIButton
            button.setTitle(title, forState: .Normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
            button.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
            if(title == "space"){
                button.addTarget(self, action: "spacePressed:", forControlEvents: .TouchUpInside)
            } else if(title == "bs") {
                button.addTarget(self, action: "backspacePressed:", forControlEvents: .TouchUpInside)
            } else {
                button.addTarget(self, action: "keyPressed:", forControlEvents: .TouchUpInside)
            }
            buttons.append(button)
        }
    
    return buttons
    }
    
    func createSuggestionButtons(titles: [String]) -> [UIButton] {
        
        var buttons :[UIButton] = [UIButton]()
        
        for title in titles {
            let button = UIButton(type: .System) as UIButton
            button.setTitle(title, forState: .Normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
            button.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)

            button.addTarget(self, action: "suggestionPressed:", forControlEvents: .TouchUpInside)
            
            buttons.append(button)
        }
        
        return buttons
    }
    
    func keyPressed(sender: AnyObject?) {
        let button = sender as! UIButton
        let title = button.titleForState(.Normal)
        (textDocumentProxy as UIKeyInput).insertText(title!)
        
        label!.text = label!.text! + title!
    }
    
    func spacePressed(sender: AnyObject?) {
        let button = sender as! UIButton
        (textDocumentProxy as UIKeyInput).insertText(" ")
        
        createSuggestion(label!.text!)
    }
    
    func suggestionPressed(sender: AnyObject?) {
        let endlabel = label!.text!.characters.count
        for i in 0...endlabel{
            textDocumentProxy.deleteBackward()
        }
        
        let button = sender as! UIButton
        let title = button.titleForState(.Normal)
        (textDocumentProxy as UIKeyInput).insertText(title!)
        
        label!.text = ""
        for button in suggestionsContainer.subviews {
            UIView.animateWithDuration(0.2, animations: {
                button.alpha = 0.0
            })
        }
    }
    
    func backspacePressed(sender: AnyObject?) {
        if(label!.text! != ""){
            label!.text! = label!.text!.substringToIndex(label!.text!.endIndex.predecessor())
        }
        textDocumentProxy.deleteBackward()
    }
    
    func addConstraints(buttons: [UIButton], containingView: UIView){
        
        for (index, button) in buttons.enumerate() {
            
            let topConstraint = NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: containingView, attribute: .Top, multiplier: 1.0, constant: 1)
            
            let bottomConstraint = NSLayoutConstraint(item: button, attribute: .Bottom, relatedBy: .Equal, toItem: containingView, attribute: .Bottom, multiplier: 1.0, constant: -1)
            
            var leftConstraint : NSLayoutConstraint!
            
            if index == 0 {
                
                leftConstraint = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: containingView, attribute: .Left, multiplier: 1.0, constant: 1)
                
            }else{
                
                leftConstraint = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: buttons[index-1], attribute: .Right, multiplier: 1.0, constant: 1)
                
                let widthConstraint = NSLayoutConstraint(item: buttons[0], attribute: .Width, relatedBy: .Equal, toItem: button, attribute: .Width, multiplier: 1.0, constant: 0)
                
                containingView.addConstraint(widthConstraint)
            }
            
            var rightConstraint : NSLayoutConstraint!
            
            if index == buttons.count - 1 {
                
                rightConstraint = NSLayoutConstraint(item: button, attribute: .Right, relatedBy: .Equal, toItem: containingView, attribute: .Right, multiplier: 1.0, constant: -1)
                
            }else{
                
                rightConstraint = NSLayoutConstraint(item: button, attribute: .Right, relatedBy: .Equal, toItem: buttons[index+1], attribute: .Left, multiplier: 1.0, constant: -1)
            }
            
            containingView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
        }
    }
    
    func createSuggestion(title : String) {
        
        suggestionsContainer.subviews.forEach({ $0.removeFromSuperview() })
        
        let suggestions = createSuggestionButtons(lookupSuggestions(title))
        
        for button in suggestions {
            button.alpha = 0
            suggestionsContainer.addSubview(button)
        }
        addConstraints(suggestions, containingView: suggestionsContainer)
        var delay = 0.0
        for button in suggestions {
            delay += 0.1
            UIView.animateWithDuration(delay, animations: {
                button.alpha = 1.0
            })
        }

        
    }
    
    /* now a dummy function. TODO: implement real lookup */
    func lookupSuggestions(title: String) -> [String] {
        wormhole.passMessageObject("titleString", identifier: "messageIdentifier")
        
        defaults.setObject(title, forKey: "wordKey")
        print(defaults.objectForKey("wordKey") as! String)
        defaults.synchronize()
        print(defaults.objectForKey("wordSuggestions") as! [String])
        return defaults.objectForKey("wordSuggestions") as! [String]
        //return ["ครับ" , "คับ", "ขับ"]
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    override func textWillChange(textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
    
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.Dark {
            textColor = UIColor.whiteColor()
        } else {
            textColor = UIColor.blackColor()
        }
        self.nextKeyboardButton.setTitleColor(textColor, forState: .Normal)
    }

}
