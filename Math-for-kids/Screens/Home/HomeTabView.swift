//
//  HomeTabView.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 22/12/2025.
//

import SwiftUI

struct HomeTabView: View {
    // Array of days with their active states
    let weekDays: [(day: String, isActive: Bool)] = [
        ("Mon", true),
        ("Tue", false),
        ("Wed", false),
        ("Thu", false),
        ("Fri", false),
        ("Sat", false),
        ("Sun", false)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                MathScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 18) {
                        ZStack(alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.surfacePrimary)
                                .frame(maxWidth: .infinity, minHeight: 202)
                                .overlay(
                                    UnevenBorderShape(
                                        cornerRadius: 12,
                                        borderWidths: .init(top: 2, leading: 2, bottom: 4, trailing: 2)
                                    )
                                    .fill(Color(.borderPrimary), style: FillStyle(eoFill: true))
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                            
                            VStack(spacing: 24){
                                HStack(spacing: 16){
                                    Image("learning")
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack(alignment: .center){
                                            Text("1 day")
                                                .font(.LilitaOne(size: .lg))
                                                .foregroundStyle(Color(.warningContent))
                                            
                                            Spacer()
                                            
                                            Button {
                                                
                                            } label: {
                                                Image("arrow-right")
                                            }
                                        }
                                        Text("Complete practice or tutorial")
                                            .font(.Rubik(size: .md))
                                            .foregroundStyle(.textSecondary)
                                    }
                                }
                                
                                HStack(spacing: 12) {
                                    ForEach(weekDays, id: \.day) { dayData in
                                        VStack(spacing: 8) {
                                            Text(dayData.day)
                                                .font(.Rubik(size: .md))
                                                .fontWeight(.semibold)
                                                .foregroundColor(.textSecondary)
                                            
                                            Image(dayData.isActive ? "fire" : "fire-inactive")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 24, height: 24)
                                        }
                                        .frame(maxWidth: .infinity)
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                            .padding()

                        }
                        HStack(alignment: .center, spacing: 16) {
                            Image("streakIcon")
                            Text("Start Practice")
                                .font(.LilitaOne(size: .xlg))
                                .foregroundStyle(Color(.brandContent))
                        }
                        
                        PracticeCard(
                            title: "Addition",
                            buttonLabel: "Level 1",
                            surfaceColor: Color(.surfaceBrand),
                            borderLightColor: Color.borderBrandLight,
                            imageName: "brand"
                        )
                        
                        PracticeCard(
                            title: "Subtraction",
                            buttonLabel: "Level 4",
                            buttonBrandStyle: .lime,
                            surfaceColor: Color(.surfaceLime),
                            borderLightColor: Color.borderLimeLight,
                            imageName: "lime"
                        )
                        
                        PracticeCard(
                            title: "Multiplication",
                            buttonLabel: "Level 4",
                            buttonBrandStyle: .fuchsia,
                            surfaceColor: Color(.surfaceFushia),
                            borderLightColor: Color.borderFushiaLight,
                            imageName: "fushia"
                        )
                        
                        PracticeCard(
                            title: "Division",
                            buttonLabel: "Level 6",
                            buttonBrandStyle: .warning,
                            surfaceColor: Color(.surfaceOrange),
                            borderLightColor: Color.borderOrangeLight,
                            imageName: "orange"
                        )
                        
                        Spacer()
                            .frame(height: 80)
                    }
                    .padding()
                    .padding(.top, 110) // Space for HomeTopBar
                }
                .background(.white)
                
                HomeTopBar(
                    userName: "Alex",
                    coinBalance: 99000
                )
            }
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: NavigationRoute.self) { route in
                switch route {
                case .store:
                    StoreView()
                default:
                    EmptyView()
                }
            }
            .ignoresSafeArea()
        }
    }
}

