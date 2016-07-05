//
//  ViewController.swift
//  UdemyJSQMessenger
//
//  Created by Donovan Cotter on 4/12/16.
//  Copyright © 2016 DonovanCotter. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var enterChatButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //We put it in viewDidAppear because it runs when our view is loaded.
        
        UIView.animateWithDuration(1) { () -> Void in
            
            let logoImageYMoveTo = self.view.center.y - (self.usernameTextField.center.y - self.logoImageView.center.y)
            let enterChatButtonYMoveTo = self.view.center.y - (self.usernameTextField.center.y - self.enterChatButton.center.y)
            
            //This will center our textfield and button with the center y axis.
            self.usernameTextField.center.y = self.view.center.y
            self.enterChatButton.center.y = enterChatButtonYMoveTo
            self.logoImageView.center.y = logoImageYMoveTo
            
            self.usernameTextField.alpha = 1
            self.enterChatButton.alpha = 1
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func enterChatButtonPressed(sender: AnyObject) {
        
        if self.usernameTextField.text != "" {
            self.performSegueWithIdentifier("startChatting", sender: self)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationVC = segue.destinationViewController as? ChatVC {
            destinationVC.senderId = UIDevice.currentDevice().identifierForVendor?.UUIDString
            destinationVC.senderDisplayName = usernameTextField.text
            destinationVC.chatRoomName = "Chatter Room 1"
        }
    }

}

