//
//  AppRoot.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 22/12/2025.
//

import SwiftUI

// Custom shape for rounded top corners only
struct TopRoundedRectangle: Shape {
    var cornerRadius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Top-left corner - start from the arc
        path.move(to: CGPoint(x: 0, y: cornerRadius))
        path.addArc(
            center: CGPoint(x: cornerRadius, y: cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(180),
            endAngle: .degrees(270),
            clockwise: false
        )
        
        // Top edge
        path.addLine(to: CGPoint(x: rect.width - cornerRadius, y: 0))
        
        // Top-right corner
        path.addArc(
            center: CGPoint(x: rect.width - cornerRadius, y: cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(270),
            endAngle: .degrees(0),
            clockwise: false
        )
        
        // Right edge
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        
        // Bottom edge
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        
        // Left edge back to start
        path.addLine(to: CGPoint(x: 0, y: cornerRadius))
        
        path.closeSubpath()
        return path
    }
}

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

// MARK: - Custom Tab Bar

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            TabBarItem(
                icon: "home",
                label: "HOME",
                isSelected: selectedTab == 0
            ) {
                selectedTab = 0
            }
            
            TabBarItem(
                icon: "leader",
                label: "LEADERS",
                isSelected: selectedTab == 1
            ) {
                selectedTab = 1
            }
            
            TabBarItem(
                icon: "learn",
                label: "LEARN",
                isSelected: selectedTab == 2
            ) {
                selectedTab = 2
            }
            
            TabBarItem(
                icon: "profile",
                label: "PROFILE",
                isSelected: selectedTab == 3
            ) {
                selectedTab = 3
            }
        }
        .padding(.top, 16)
        .padding(.bottom, 32)
        .background(Color.white)
        .clipShape(TopRoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(0.1), radius: 12, x: 0, y: -1)
    }
}

struct TabBarItem: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(icon)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(isSelected ? Color.brandContent : Color.textSecondary)
                
                Text(label)
                    .font(.LilitaOne(size: .xxsm))
                    .foregroundColor(isSelected ? Color.brandContent : Color.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Tab Views

struct HomeTabView: View {
    var body: some View {
        VStack {
            Text("Home")
                .font(.LilitaOne(size: .xlg))
        }
    }
}

struct LeadersTabView: View {
    var body: some View {
        VStack {
            Text("Leaders")
                .font(.LilitaOne(size: .xlg))
        }
    }
}

struct LearnTabView: View {
    var body: some View {
        VStack {
            Text("Learn")
                .font(.LilitaOne(size: .xlg))
        }
    }
}

struct ProfileTabView: View {
    var body: some View {
        VStack {
            Text("Profile")
                .font(.LilitaOne(size: .xlg))
        }
    }
}

#Preview {
    AppRoot()
}
