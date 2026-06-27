//
//  Wallet.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 23/06/2026.
//

import Foundation
import SwiftData

/// The learner's coin balance. A single row for the whole app — credited when
/// coins are purchased in the Store and read by the Home top bar.
@Model
final class Wallet {
    var coins: Int

    init(coins: Int = 0) {
        self.coins = coins
    }
}
