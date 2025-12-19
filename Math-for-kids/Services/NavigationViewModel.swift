//
//  NavigationViewModel.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 11/12/2025.
//

import SwiftUI

/// ViewModel responsible for managing navigation state
@Observable
class NavigationViewModel {
    private var appendRoute: ((NavigationRoute) -> Void)?
    private var removeLast: (() -> Void)?
    private var removeAll: (() -> Void)?
    
    /// Setup the navigation path handlers
    func setup(path: Binding<NavigationPath>) {
        appendRoute = { route in
            path.wrappedValue.append(route)
        }
        removeLast = {
            if !path.wrappedValue.isEmpty {
                path.wrappedValue.removeLast()
            }
        }
        removeAll = {
            path.wrappedValue.removeLast(path.wrappedValue.count)
        }
    }
    
    /// Navigate to a specific route
    func navigate(to route: NavigationRoute) {
        appendRoute?(route)
    }
    
    /// Navigate back in the navigation stack
    func navigateBack() {
        removeLast?()
    }
    
    /// Navigate back to root
    func navigateToRoot() {
        removeAll?()
    }
    
    /// Navigate back to a specific route (removes all routes after it)
    func navigateBack(to route: NavigationRoute) {
        guard let removeAll = removeAll, let appendRoute = appendRoute else { return }
        removeAll()
        appendRoute(route)
    }
}


