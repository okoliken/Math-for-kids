//
//  NavigationRoute.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 11/12/2025.
//

import Foundation

/// Enum defining all navigation routes in the app
enum NavigationRoute: Hashable {
    case store
    case streak
    case subjectDetail(Subject)
    // Add more routes as needed
    // case detail(id: Int)
    // case settings
}

