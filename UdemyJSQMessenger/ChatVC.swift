//
//  ChatVC.swift
//  UdemyJSQMessenger
//
//  Created by Donovan Cotter on 4/12/16.
//  Copyright © 2016 DonovanCotter. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class ChatVC: JSQMessagesViewController {

    var outgoingBubbleImage: JSQMessagesBubbleImage!
    var incomingBubbleImage: JSQMessagesBubbleImage!
    var messages = [JSQMessage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        JSQMessageBubbleSetup()

        self.senderId = "99"
        self.senderDisplayName = "Donovan"
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func didPressAccessoryButton(sender: UIButton!) {
        
        let message = JSQMessage(senderId: "2", senderDisplayName: "Kenny Powers", date: NSDate(), text: "Hello, I'm another user")
        messages.append(message)
        
        self.finishReceivingMessageAnimated(true)
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        let message = JSQMessage(senderId: self.senderId, senderDisplayName: self.senderDisplayName, date: date, text: text)
        
        self.messages.append(message)
        
        self.finishSendingMessageAnimated(true)
        print(message)
    }
    
    func JSQMessageBubbleSetup() {
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        self.outgoingBubbleImage = bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
        self.incomingBubbleImage = bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleGreenColor())
    }
    
    //MARK: UICollectionView Methods
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.messages.count
    }

    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        
        return messages[indexPath.row]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let message = messages[indexPath.row]
        
        if message.senderId == self.senderId {
            return self.outgoingBubbleImage
        } else {
            return self.incomingBubbleImage
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.row]
        
        if message.senderId == self.senderId {
            cell.textView?.textColor = UIColor.blackColor()
        } else {
            cell.textView?.textColor = UIColor.whiteColor()
        }
        return cell
    }
    
}
