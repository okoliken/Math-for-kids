//
//  ContentView.swift
//  MathForkids
//
//  Created by Jeffery Okoli on 05/12/2025.
//

import SwiftUI


struct ContentView: View {
    
    var body: some View {
        
        ZStack {
            Image("Blue")
                .ignoresSafeArea(.all)
            
            VStack(spacing: 20) {
                Image("logo")
                MathButton(label: "Go To Lessons!", brandStyle: .error) {}
                MathButton(label: "Go To Lessons!") {}
                MathButton(label: "Go To Lessons!", brandStyle: .lime) {}
                MathButton(label: "Go To Lessons!", brandStyle: .secondary) {}
                MathButton(label: "Go To Lessons!", brandStyle: .success, action: {})
                MathButton(label: "Go To Lessons!", brandStyle: .warning, action: {})
                MathButton(label: "Go To Lessons!", brandStyle: .fuchsia, action: {})
            }
        }
    }
    
}

#Preview {
    ContentView()
}
