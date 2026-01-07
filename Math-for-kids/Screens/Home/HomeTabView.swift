//
//  HomeTabView.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 22/12/2025.
//

import SwiftUI

struct HomeTabView: View {
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.brandContent))
                        .frame(height: 180)
                        .frame(maxWidth: .infinity)
                    
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.fuchsiaContent))
                        .frame(height: 180)
                        .frame(maxWidth: .infinity)
                    
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.limeContent))
                        .frame(height: 180)
                        .frame(maxWidth: .infinity)
                    
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.successContent))
                        .frame(height: 180)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
            .safeAreaInset(edge: .top, spacing: 0) {
                HomeTopBar(
                    userName: "Alex",
                    coinBalance: 99000,
                    safeAreaTop: geometry.safeAreaInsets.top
                )
            }
            .background(.white)
        }
        .ignoresSafeArea()
    }
}

