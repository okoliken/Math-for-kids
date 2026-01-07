//
//  ContentView.swift
//  MathForkids
//
//  Created by Jeffery Okoli on 05/12/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var showSplash = true
    @State private var authManager = AuthManager()
    
    var body: some View {
        ZStack {
            if showSplash {
                SplashView(isActive: $showSplash)
                    .transition(.opacity)
            } else {
                if authManager.isAuthenticated {
                    AppRoot()
                        .environment(authManager)
                } else {
                    NavigationStack {
                        AuthBackground {
                            GetStarted()
                        }
                    }
                    .environment(authManager)
                }
            }
        }
        .onAppear {
            // Check authentication status when app appears
            authManager.checkAuthenticationStatus()
        }
    }
}

#Preview {
    ContentView()
}
