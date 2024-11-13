//
//  Item.swift
//  MyTwitter
//
//  Created by Blake Frederick on 2024-11-07.
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
