//
//  AppRoot.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 22/12/2025.
//

import SwiftUI

// MARK: - Tab Bar Visibility Environment
/// Custom environment key to manage tab bar visibility across navigation hierarchy.
/// This allows child views (like StoreView) to hide/show the bottom tab bar.
private struct TabBarVisibilityKey: EnvironmentKey {
    static let defaultValue: Binding<Bool> = .constant(true)
}

extension EnvironmentValues {
    /// Environment value to control tab bar visibility.
    /// Usage: @Environment(\.tabBarVisible) private var tabBarVisible
    var tabBarVisible: Binding<Bool> {
        get { self[TabBarVisibilityKey.self] }
        set { self[TabBarVisibilityKey.self] = newValue }
    }
}

struct AppRoot: View {
    /// Currently selected tab index
    @State private var selectedTab = 0
    
    /// Controls bottom tab bar visibility. Child views can modify this via environment.
    @State private var isTabBarVisible = true
    
    @State var navigationtModel = NavigationViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // MARK: - Tab Content Views
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
            // Inject tab bar visibility binding into environment for child views
            .environment(\.tabBarVisible, $isTabBarVisible)
            
            // MARK: - Bottom Tab Bar
            // Conditionally render tab bar based on visibility state
            // Child views (e.g., StoreView) can hide this via .onAppear/.onDisappear
            // Animated transition: slides down and fades out when hidden
            if isTabBarVisible {
                CustomTabBar(selectedTab: $selectedTab)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isTabBarVisible)
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    AppRoot()
}
