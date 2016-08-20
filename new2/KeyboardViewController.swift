//
//  KeyboardViewController.swift
//  new2
//
//  Created by Vasin W on 18/08/2016.
//  Copyright © 2016 Vasin W. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {

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
        /*
        let buttonTitles = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"]
        var buttons :[UIButton] = [UIButton]()
        let keyboardRowView = UIView(frame: CGRectMake(0, 0, 320, 50))
        
        for buttonTitle in buttonTitles{
           
            print(buttonTitle)
            let button = createButtonWithTitle(buttonTitle)
            buttons.append(button)
            keyboardRowView.addSubview(button)
        }
 
        
        self.view.addSubview(keyboardRowView)
 */
        /*
        // addition
        let button = createButtonWithTitle("A")
        self.view.addSubview(button)
        let button2 = createButtonWithTitle("B")
        self.view.addSubview(button2)
        */
        
        let buttonTitles = ["Q", "W", "E", "R", "T", "Y"]
        let buttons = createButtons(buttonTitles)
        let topRow = UIView(frame: CGRectMake(0, 0, 320, 40))
        
        for button in buttons {
            topRow.addSubview(button)
        }
        
        self.view.addSubview(topRow)
        
        addConstraints(buttons, containingView: topRow)
    }
    
    func createButtons(titles: [String]) -> [UIButton] {
    
        var buttons :[UIButton] = [UIButton]()
    
        for title in titles {
            let button = UIButton(type: .System) as UIButton
            button.setTitle(title, forState: .Normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
            button.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
            button.addTarget(self, action: "keyPressed:", forControlEvents: .TouchUpInside)
            buttons.append(button)
        }
    
    return buttons
    }
    
    func keyPressed(sender: AnyObject?) {
        let button = sender as! UIButton
        let title = button.titleForState(.Normal)
        (textDocumentProxy as UIKeyInput).insertText(title!)
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
    
    /*
    func createButtonWithTitle(title: String) -> UIButton {
    
        let button = UIButton(type: .System) as UIButton
        button.frame = CGRectMake(0, 0, 20, 20)
        button.setTitle(title, forState: .Normal)
        button.sizeToFit()
        button.titleLabel?.font = UIFont.systemFontOfSize(15)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        button.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
    
        button.addTarget(self, action: "didTapButton:", forControlEvents: .TouchUpInside)
    
        return button
    }
 
    func didTapButton(sender: AnyObject?) {
        
        let button = sender as! UIButton
        let title = button.titleForState(.Normal)
        let proxy = textDocumentProxy as UITextDocumentProxy
        
        proxy.insertText(title!)
    }
    */
    
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
