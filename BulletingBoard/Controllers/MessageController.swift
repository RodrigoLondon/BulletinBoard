//
//  MessageController.swift
//  BulletingBoard
//
//  Created by Lewis Jones on 08/03/2019.
//  Copyright © 2019 Rodrigo. All rights reserved.
//

import Foundation
import CloudKit

class MessageController {
    
    static let shared = MessageController()
    
    
    let messagesWereUpdatedNotification = Notification.Name("messagesWereUpdated")
    let searchedUserMessagesWereUpdatedNotification = Notification.Name("searchedUsermessagesWereUpdated")
    
    var messages: [Message] = [] {
        didSet {
            NotificationCenter.default.post(name: messagesWereUpdatedNotification, object: nil)
        }
    }
    
    var searchedUserMessages: [Message] = [] {
        didSet {
            NotificationCenter.default.post(name: searchedUserMessagesWereUpdatedNotification, object: nil)
        }
    }

    func saveMessageRecordToiCloud(text: String) {
        
        let message = Message(text: text)
        
        CloudKitManager.shared.saveRecordToCLoudKit(record: message.cloudKitRecord, database: CKContainer.default().publicCloudDatabase) { (error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.messages.append(message)
            }
        }
    }
    func fetchMessageRecordsFromiCloud() {
        CloudKitManager.shared.fetchRecordsOf(type: Message.TypeKey, database: CKContainer.default().publicCloudDatabase) { (records, error) in
            
            if let error = error {
                print(error.localizedDescription)
                
                guard let records = records else { return }
                
                let messages = records.compactMap({ Message(cloudKitRecord: $0) })
                self.messages = messages
                
            }
        }
       
    }
    func subscribeToCreationOfNewMessages() {
        
        let subscritionKey = "userSubscribed"
        
        guard UserDefaults.standard.bool(forKey: subscritionKey) != true else { return }
        
        CloudKitManager.shared.subscribeToCreationOfRecordsOf(type: Message.TypeKey, inDatabase: CKContainer.default().publicCloudDatabase, withNotificationTitle: "Hey", alertBody: "Tere is anew message on the board", andSoundName: "default") { (subscribe, error) in
            
            if let error = error {
                print(error.localizedDescription)
            } else {
                UserDefaults.standard.set(true, forKey: subscritionKey)
            }
        }
    }
    func fetchMessagesOfUserWith(email: String) {
        CloudKitManager.shared.fetchUserIdentityWith(email: email) { (identity, error) in
            
            if let error = error {
                print(error.localizedDescription)
               
                
                guard let identity = identity,
                    let userRecordID = identity.userRecordID else { return }
                
                let predicate = NSPredicate(format: "creatorUserRecordID == %@", userRecordID)
                
                let query = CKQuery(recordType: Message.TypeKey, predicate: predicate)
                
                CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil, completionHandler: { (records, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    guard let records = records else { return }
                    
                    let userMessages = records.compactMap({Message(cloudKitRecord: $0)})
                    self.searchedUserMessages = userMessages
                })
            }
        
        }
    }
    
}
