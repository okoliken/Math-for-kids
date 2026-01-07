//
//  AppRoot.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 22/12/2025.
//

import SwiftUI

struct AppRoot: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Content views
            Group {
                switch selectedTab {
                case 0:
                    HomeTabView()
                case 1:
                    LeadersTabView()
                case 2:
                    LearnTabView()
                case 3:
                    ProfileTabView()
                default:
                    HomeTabView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Custom Tab Bar
            CustomTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    AppRoot()
}
