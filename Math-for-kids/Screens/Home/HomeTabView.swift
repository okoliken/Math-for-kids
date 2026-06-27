//
//  HomeTabView.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 22/12/2025.
//

import SwiftData
import SwiftUI

struct HomeTabView: View {
    @Query private var progresses: [SubjectProgress]
    @Query private var practiceDays: [PracticeDay]
    @Query private var wallets: [Wallet]

    /// The current coin balance, shown in the top bar.
    private var coinBalance: Int { wallets.first?.coins ?? 0 }

    /// Current streak length and the Mon–Sun strip, both derived from practice days.
    private var streakCount: Int { ProgressStore.streak(from: practiceDays) }
    private var weekDays: [(day: String, isActive: Bool)] { ProgressStore.currentWeek(from: practiceDays) }

    /// Subjects from the catalog with their stored level progress applied.
    private var subjects: [Subject] {
        Subject.catalog.map { subject in
            let completed = progresses.first { $0.subjectID == subject.id }?.completedLevels ?? 0
            return subject.withCompletedLevels(completed)
        }
    }

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
                                            Text("\(streakCount) day\(streakCount == 1 ? "" : "s")")
                                                .font(.LilitaOne(size: .lg))
                                                .foregroundStyle(Color(.warningContent))
                                            
                                            Spacer()
                                            
                                            NavigationLink(value: NavigationRoute.streak) {
                                                Image("arrow-right")
                                            }
                                            .buttonStyle(PressableButtonStyle())
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
                        
                        ForEach(subjects) { subject in
                            PracticeCard(subject: subject)
                        }
                        
                        Spacer()
                            .frame(height: 80)
                    }
                    .padding()
                    .padding(.top, 110) // Space for HomeTopBar
                }
                .background(.white)
                
                HomeTopBar(
                    userName: "Alex",
                    coinBalance: coinBalance
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

