//
//  HomeTopBar.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 22/12/2025.
//

import SwiftUI

struct HomeTopBar: View {
    let userName: String
    let coinBalance: Int
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
                // Left side - Avatar and name
                HStack(spacing: 8) {
                    Image("av3")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    
                    Text(userName)
                        .font(.LilitaOne(size: .md))
                        .fontWeight(.bold)
                        .foregroundStyle(.textPrimary)
                }
                
                Spacer()
                
                // Right side - Coin balance
                HStack(spacing: 8) {
                    Image("Coin")
                    
                    Text("\(coinBalance.formatted())")
                        .font(.LilitaOne(size: .md))
                        .fontWeight(.bold)
                        .foregroundStyle(.textPrimary)
                    
                    NavigationLink(value: NavigationRoute.store) {
                        Image("Add")
                            .foregroundColor(.green)
                            .font(.title3)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(.surfacePrimary)
                .clipShape(Capsule())
                .overlay(
                    RoundedRectangle(cornerRadius: 100)
                        .stroke(Color.borderPrimary, lineWidth: 5)
                )
            .clipShape(RoundedRectangle(cornerRadius: 100))
        }
        .padding(.horizontal, 20)
        .padding(.top, 50)
        .padding(.bottom, 12)
        .frame(height: 110)
        .background(Color.white)
        .clipShape(BottomRoundedRectangle(cornerRadius: 24))
        .overlay(alignment: .bottom) {
            BottomBorderShape(cornerRadius: 24, borderWidth: 3)
                .fill(Color.borderPrimary)
        }
        .shadow(color: Color.black.opacity(0.1), radius: 12, x: 0, y: -1)
    }
}
