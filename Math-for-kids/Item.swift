//
//  Item.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 07/12/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
