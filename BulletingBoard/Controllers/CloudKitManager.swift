//
//  CloudKitManager.swift
//  BulletingBoard
//
//  Created by Lewis Jones on 08/03/2019.
//  Copyright © 2019 Rodrigo. All rights reserved.
//

import Foundation
import CloudKit


class CloudKitManager {
    
    static let shared = CloudKitManager()
    
    func saveRecordToCLoudKit(record: CKRecord, database: CKDatabase, completion: @escaping (Error?) -> Void = {_ in }){
        
        database.save(record) { (_, error) in
            completion(error)
        }
    }
    
    func fetchRecordsOf(type: String, database: CKDatabase, completion: @escaping ([CKRecord]?, Error?) -> Void) {
        
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: Message.TypeKey, predicate: predicate)
        
        database.perform(query, inZoneWith: nil, completionHandler: completion)
    }
    
    func subscribeToCreationOfRecordsOf(type: String, inDatabase database: CKDatabase, withNotificationTitle title: String?, alertBody: String?, andSoundName soundName: String?, completion: @escaping (CKSubscription?, Error?) -> Void) {
        
        let predicate = NSPredicate(value: true)
        
        let subscription = CKQuerySubscription(recordType: type, predicate: predicate, options: .firesOnRecordCreation)
        
        let notificationInfo = CKSubscription.NotificationInfo()
        
        notificationInfo.title = title
        notificationInfo.alertBody = alertBody
        notificationInfo.soundName = soundName
        
        subscription.notificationInfo = notificationInfo
        
        database.save(subscription, completionHandler: completion)
        
    }
    
    func requestDiscoverabilityAuthorization(completion: @escaping (CKContainer_Application_PermissionStatus, Error?) -> Void) {
        
        CKContainer.default().status(forApplicationPermission: .userDiscoverability) { (permissionStatus, error) in
            
            guard permissionStatus != .granted else { completion(.granted, error); return }
            
            CKContainer.default().requestApplicationPermission(.userDiscoverability, completionHandler: completion)
        }
    }
    
    func fetchUserIdentityWith(email: String, completion: @escaping (CKUserIdentity?, Error?) -> Void) {
        CKContainer.default().discoverUserIdentity(withEmailAddress: email, completionHandler: completion)
        
    }
}
