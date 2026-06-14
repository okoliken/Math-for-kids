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
                            RoundedRectangle(cornerRadius: 16).fill(Color.surfacePrimary)
                                .cardSurface(
                                        cornerRadius: 12,
                                        borderWidths: .init(top: 2, leading: 2, bottom: 4, trailing: 2)
                                    )
        
                            
                            VStack(spacing: 22){
                                HStack(spacing: 16){
                                    Image("learning")
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack(alignment: .center){
                                            Text("1 day")
                                                .font(.LilitaOne(size: .lg))
                                                .foregroundStyle(Color(.warningContent))
                                            
                                            Spacer()
                                            
                                            NavigationLink(value: NavigationRoute.streak) {
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
//                                .padding(.horizontal, 16)
                            }
                            .padding()

                        }
                        HStack(alignment: .center, spacing: 6) {
                            Image("streakIcon")
                            Text("Start Practice")
                                .font(.LilitaOne(size: .xlg))
                                .foregroundStyle(Color(.brandContent))
                        }
                        .padding(.horizontal, 10)
                        
                        PracticeCard(
                            title: "Addition",
                            buttonLabel: "Level 1",
                            surfaceColor: Color(.surfaceBrand),
                            borderLightColor: Color.borderBrandLight,
                            imageName: "brand",
                            completedLevels: 0
                        )

                        PracticeCard(
                            title: "Subtraction",
                            buttonLabel: "Level 4",
                            buttonBrandStyle: .lime,
                            surfaceColor: Color(.surfaceLime),
                            borderLightColor: Color.borderLimeLight,
                            imageName: "lime",
                            completedLevels: 3
                        )

                        PracticeCard(
                            title: "Multiplication",
                            buttonLabel: "Level 4",
                            buttonBrandStyle: .fuchsia,
                            surfaceColor: Color(.surfaceFushia),
                            borderLightColor: Color.borderFushiaLight,
                            imageName: "fushia",
                            completedLevels: 3
                        )

                        PracticeCard(
                            title: "Division",
                            buttonLabel: "Level 6",
                            buttonBrandStyle: .warning,
                            surfaceColor: Color(.surfaceOrange),
                            borderLightColor: Color.borderOrangeLight,
                            imageName: "orange",
                            completedLevels: 5
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
                    case .streak:
                        StreakView()
                    case .subjectDetail(let subject):
                        SubjectDetailView(subject: subject)
                }
            }
            .ignoresSafeArea()
        }
    }
}

