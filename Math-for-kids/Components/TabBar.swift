//
//  TabBar.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 22/12/2025.
//

import SwiftUI

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
        .padding(.horizontal)
        .background(Color.white)
        .clipShape(TopRoundedRectangle(cornerRadius: 24))
        .overlay(alignment: .top) {
            TopBorderShape(cornerRadius: 24, borderWidth: 3)
                .fill(Color.borderPrimary)
        }
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
                    .renderingMode(.template)
                    .scaledToFit()
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

