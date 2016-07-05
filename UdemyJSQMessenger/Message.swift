//
//  Message.swift
//  UdemyJSQMessenger
//
//  Created by Donovan Cotter on 4/13/16.
//  Copyright © 2016 DonovanCotter. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase

class Message: JSQMessage {
    
    var mediaType: MediaType
    
    init(snapshot: FDataSnapshot) {
        let text = snapshot.value["text"] as? String
        let senderId = snapshot.value["senderId"] as? String
        let senderName = snapshot.value["senderName"] as? String
        let timestamp = snapshot.value["timestamp"] as? NSTimeInterval
        let mediaType = snapshot.value["mediaType"] as? String
        
        self.mediaType = MediaType(rawValue: mediaType!)!
        
        if self.mediaType == .Text {
            super.init(senderId: senderId, senderDisplayName: senderName, date: NSDate(timeIntervalSince1970: timestamp!), text: text)
        } else if self.mediaType == .Photo {
            let decodedData = NSData(base64EncodedString: text!, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
            let decodedImage = UIImage(data: decodedData!)
            let jsqImage = JSQPhotoMediaItem(image: decodedImage)
            
            super.init(senderId: senderId, senderDisplayName: senderName, date: NSDate(timeIntervalSince1970: timestamp!), media: jsqImage)
        } else {
            super.init(senderId: senderId, senderDisplayName: senderName, date: NSDate(timeIntervalSince1970: timestamp!), text: text)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

enum MediaType: String {
    case Text = "TEXT"
    case Photo = "PHOTO"
}
