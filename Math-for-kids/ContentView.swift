//
//  ContentView.swift
//  MathForkids
//
//  Created by Jeffery Okoli on 05/12/2025.
//

import SwiftUI



struct ContentView: View {
    @State private var showSplash = true
    
    var body: some View {
        ZStack {
            if showSplash {
                SplashView(isActive: $showSplash)
                    .transition(.opacity)
            } else {
                
                NavigationStack {
                    AuthBackground {
                        GetStarted()
                    }
                }
                
            }
        }
    }
}

#Preview {
    ContentView()
}
