//
//  Message.swift
//  BulletingBoard
//
//  Created by Lewis Jones on 08/03/2019.
//  Copyright © 2019 Rodrigo. All rights reserved.
//

import Foundation
import CloudKit


class Message {
    
    static let TypeKey = "Message"
    private let TextKey = "Text"
    private let TimestampKey = "timmestamp"
    
    let text: String
    let timestamp: Date
    
    
    init(text: String, timestamp: Date = Date()) {
        self.text = text
        self.timestamp = timestamp
    }
    
    init?(cloudKitRecord: CKRecord) {
        guard let text = cloudKitRecord[TextKey] as? String,
        let timestamp = cloudKitRecord[TimestampKey] as? Date   else { return nil }
        
        self.text = text
        self.timestamp = timestamp
    }
    
    var cloudKitRecord: CKRecord {
        
        let record = CKRecord(recordType: Message.TypeKey)
        
        record.setValue(text, forKey: TextKey)
        record[TimestampKey] = timestamp as CKRecordValue
        
        return record
    }
}
