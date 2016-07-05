//
//  ChatVC.swift
//  UdemyJSQMessenger
//
//  Created by Donovan Cotter on 4/12/16.
//  Copyright © 2016 DonovanCotter. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import MobileCoreServices
import Firebase

class ChatVC: JSQMessagesViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var outgoingBubbleImage: JSQMessagesBubbleImage!
    var incomingBubbleImage: JSQMessagesBubbleImage!
    var messages = [Message]()
    var avatars = [String: JSQMessagesAvatarImage]()
    var imagePicker = UIImagePickerController()
    var chatRoomName = String()
    
    var firebaseRef: Firebase {
        get {
            return Firebase(url: "https://udemyjsqmessenger.firebaseio.com/\(chatRoomName)/Messages")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        JSQMessageBubbleSetup()
        retrieveFirebaseMessages()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func didPressAccessoryButton(sender: UIButton!) {
        
        let alertSheet = UIAlertController(title: "Media Messages", message: "Please Selecte a Media", preferredStyle: .ActionSheet)
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (alert: UIAlertAction) -> Void in
            alertSheet.dismissViewControllerAnimated(true, completion: nil)
        }
        
        let sendPhoto = UIAlertAction(title: "Send Photo", style: .Default) { (alert: UIAlertAction) -> Void in
            self.photoLibrary()
        }
        
        alertSheet.addAction(sendPhoto)
        alertSheet.addAction(cancel)

        presentViewController(alertSheet, animated: true, completion: nil)
        
//        let message = JSQMessage(senderId: "23", senderDisplayName: "Kenny", date: NSDate(), text: "Hello, I'm another user")
//        messages.append(message)
//        
//        if self.avatars[senderId] == nil {
//            print("Called")
//            setupAvatarColor(message.senderId, name: message.senderDisplayName, incoming: true)
//        }
//
//        self.finishReceivingMessageAnimated(true)

    }
    
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
//        let message = JSQMessage(senderId: self.senderId, senderDisplayName: self.senderDisplayName, date: date, text: text)
//        self.messages.append(message)
//        
//        if self.avatars[senderId] == nil {
//            setupAvatarColor(senderId, name: senderDisplayName, incoming: false)
//        }
//        
        firebaseRef.childByAutoId().setValue(["text": text, "senderId": senderId, "senderName": senderDisplayName, "timestamp": date.timeIntervalSince1970, "mediaType": "TEXT"])
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
 
        self.finishSendingMessageAnimated(true)
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
        
        let message = messages[indexPath.row]
        
        return self.avatars[message.senderId] as? JSQMessageAvatarImageDataSource
 
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

    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.row]
        
        if indexPath.row <= 1 {
            return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date)
        } else {
            let previousMessage = messages[indexPath.row - 1]
            let elapsedTime = message.date.timeIntervalSinceDate(previousMessage.date)
            
            //If the elapsed time is greated than 2 minutes then make the time stamp the time of the message. Otherwise it will show the time in seconds since the last message.
            if elapsedTime > 120 {
                return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date)
            }
            return nil
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let message = messages[indexPath.row]
        
        if indexPath.row <= 1 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        } else {
            let previousMessage = messages[indexPath.row - 1]
            let elapsedTime = message.date.timeIntervalSinceDate(previousMessage.date)
            
            //If the elapsed time is greated than 2 minutes then make the time stamp the time of the message. Otherwise it will show the time in seconds since the last message.
            if elapsedTime > 120 {
                return kJSQMessagesCollectionViewCellLabelHeightDefault
            }
            return 0.0
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let message = messages[indexPath.row]
        
        if indexPath.row <= 1 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        } else {
            let previousMessage = messages[indexPath.row - 1]
            
            if previousMessage.senderId != message.senderId {
                return kJSQMessagesCollectionViewCellLabelHeightDefault
            }
        }
            return 0.0
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.row]
        
        if indexPath.row <= 1 {
            return NSAttributedString(string: message.senderDisplayName)
        } else {
            let previousMessage = messages[indexPath.row - 1]
            
            if previousMessage.senderId != message.senderId {
                return NSAttributedString(string: message.senderDisplayName)
            }
        }
        return nil
    }
    
    //MARK: UIImagePicker Delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {

        let image = resizeImage(image)
        
        self.dismissViewControllerAnimated(true) { () -> Void in
            let imageData = UIImagePNGRepresentation(image)!
            let base64String = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
            
            let photoMsg = ["text": base64String, "mediaType": MediaType.Photo.rawValue, "senderId": self.senderId, "senderName": self.senderDisplayName, "timestamp": NSDate().timeIntervalSince1970]
            
            self.firebaseRef.childByAutoId().setValue(photoMsg)
            
            self.finishSendingMessage()
        }
        
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
    }
    
    //MARK: Supporting Methods
    
    func setupAvatarColor(id: String, name: String, incoming: Bool) {
        let diameter: UInt
        
        if incoming == true {
            diameter = UInt((collectionView?.collectionViewLayout.incomingAvatarViewSize.width)!)
        } else {
            diameter = UInt((collectionView?.collectionViewLayout.outgoingAvatarViewSize.width)!)
        }
        
        let color = UIColor.blackColor()
        let initials = name.substringToIndex(name.startIndex.advancedBy(min(3, name.characters.count)))
        
        let userImage = JSQMessagesAvatarImageFactory.avatarImageWithUserInitials(initials, backgroundColor: color, textColor: UIColor.whiteColor(), font: UIFont.systemFontOfSize(12), diameter: diameter)
        
        self.avatars[id] = userImage
        
    }
    
    
    func JSQMessageBubbleSetup() {
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        self.outgoingBubbleImage = bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
        self.incomingBubbleImage = bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleGreenColor())
    }
    
    func photoLibrary() {
        self.imagePicker.allowsEditing = false
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.imagePicker.mediaTypes = [kUTTypeImage as String]
        self.presentViewController(self.imagePicker, animated: true, completion: nil)
    }
    
    func retrieveFirebaseMessages() {
        firebaseRef.queryLimitedToLast(25).observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in

            let message = Message(snapshot: snapshot)
            
            if message.senderId == self.senderId {
                self.setupAvatarColor(message.senderId, name: message.senderDisplayName, incoming: false)
            } else {
                self.setupAvatarColor(message.senderId, name: message.senderDisplayName, incoming: true)
            }

            self.messages.append(message)
            self.finishReceivingMessage()
            
            }) { (error) -> Void in
                print(error.description)
        }
    }
    
    func resizeImage(image: UIImage) -> UIImage {
        //Takes the image and resizes it to 50% of its size and width and then returns the scaled image.
        let size = CGSizeApplyAffineTransform(image.size, CGAffineTransformMakeScale(0.25, 0.25))
        let hasAlpha = false
        let scale: CGFloat = 0.0
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.drawInRect(CGRect(origin: CGPointZero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }

}
