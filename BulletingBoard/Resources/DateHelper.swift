//
//  DateHelper.swift
//  BulletingBoard
//
//  Created by Lewis Jones on 18/03/2019.
//  Copyright © 2019 Rodrigo. All rights reserved.
//

import Foundation


class DateHelper {
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()
}
