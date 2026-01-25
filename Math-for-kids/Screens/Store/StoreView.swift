//
//  StoreView.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 22/12/2025.
//

import SwiftUI

// MARK: - Store Tab Types
enum StoreTab {
  case coins
  case packs
}

// MARK: - Tab Components
/// Wrapper component for tab group (currently passes through content)
struct TabGroup<Content: View>: View {
  @ViewBuilder let content: Content

  var body: some View {
    content
  }
}

/// Container for tab items with rounded background
struct TabList<Content: View>: View {
  @ViewBuilder let content: Content

  var body: some View {
    HStack(alignment: .center, spacing: 12) {
      content
    }
    .padding(.horizontal, 6)
    .padding(.vertical, 8)
    .background(
      RoundedRectangle(cornerRadius: 10)
        .fill(Color(.surfaceSecondary))
    )
    .padding(.horizontal, 20)
    // .padding(.vertical, 20)
  }
}

/// Individual tab button with selection state and styling
struct TabItem: View {
  let label: String
  let isSelected: Bool
  let action: () -> Void

  var body: some View {
    Button {
      action()
    } label: {
      Text(label)
        .font(.LilitaOne(size: .xsm))
        .foregroundStyle(isSelected ? .white : .textSecondary)
        .padding(.vertical, 14)
        .padding(.horizontal, 14)
        .frame(maxWidth: .infinity)
        .background {
          if isSelected {
            ZStack(alignment: .bottom) {
              RoundedRectangle(cornerRadius: 14)
                .fill(Color(.borderContent))
                .offset(y: 3)
              RoundedRectangle(cornerRadius: 14)
                .fill(Color(.brandContent))
            }
          }
        }
    }
    .buttonStyle(PlainButtonStyle())
    .conditionalEffect(isSelected)
  }
}

// MARK: - Grid Views
/// Grid view displaying coin packages with staggered animations
struct CoinsGridView: View {
  let columns = [
    GridItem(.flexible(), spacing: 12),
    GridItem(.flexible(), spacing: 12),
  ]

  let coinPackages = [
    (image: "coins", title: "500 Coins", price: "$1.99"),
    (image: "coins", title: "1500 Coins", price: "$2.99"),
    (image: "coins", title: "3000 Coins", price: "$4.99"),
    (image: "coins", title: "5000 Coins", price: "$7.99"),
  ]

  var body: some View {
    LazyVGrid(columns: columns, spacing: 12) {
      ForEach(Array(coinPackages.enumerated()), id: \.offset) { index, package in
        CoinCard(
          imageName: package.image,
          title: package.title,
          price: package.price
        ) {
          // Purchase action
          print("Purchase \(package.title)")
        }
        .transition(.scale.combined(with: .opacity))
        .animation(
          .spring(response: 0.4, dampingFraction: 0.8)
            .delay(Double(index) * 0.05),
          value: package.title
        )
      }
    }
  }
}

/// Grid view displaying subscription packs with animations
struct PacksGridView: View {
  let subscriptions = [
    (
      image: "Sub1", title: "Monthly Membership",
      description: "Enjoy Math for Kids premium\nfeatures", price: "$10.99"
    ),
    (
      image: "Sub2", title: "Yearly Membership",
      description: "Enjoy Math for Kids premium\nfeatures", price: "$100.99"
    ),
    (
      image: "Sub3", title: "Lifetime Membership",
      description: "Enjoy Math for Kids premium\nfeatures", price: "$300.99"
    ),
  ]

  var body: some View {
    VStack(spacing: 16) {
      ForEach(Array(subscriptions.enumerated()), id: \.offset) { index, subscription in
        SubscriptionCard(
          imageName: subscription.image,
          title: subscription.title,
          description: subscription.description,
          price: subscription.price
        ) {
          // Purchase action
          print("Purchase \(subscription.title)")
        }
        .transition(.scale.combined(with: .opacity))
        .animation(
          .spring(response: 0.4, dampingFraction: 0.8)
            .delay(Double(index) * 0.1),
          value: subscription.title
        )
      }
    }
  }
}

// MARK: - Subscription Card Component
/// Card displaying subscription package with image, title, description, and purchase button
struct SubscriptionCard: View {
  let imageName: String
  let title: String
  let description: String
  let price: String
  let action: () -> Void

  var body: some View {
    HStack(alignment: .top, spacing: 16) {
      // Subscription Image
      Image(imageName)
        .resizable()
        .scaledToFit()
        .frame(width: 80, height: 80)
        .padding(.leading, 16)

      // Content
      VStack(alignment: .leading, spacing: 8) {
        Text(title)
          .font(.LilitaOne(size: .sm))
          .foregroundStyle(.textPrimary)

        Text(description)
          .font(.Rubik(size: .md))
          .foregroundStyle(.textSecondary)
          .lineLimit(2)
          .fixedSize(horizontal: false, vertical: true)
          .multilineTextAlignment(.leading)

        MathButton(
          label: price,
          brandStyle: .secondary,
          fullWidth: false,
          minHeight: 32,
          action: action
        )
        .padding(.top, 12)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    
    Spacer()
    }
    .padding(.vertical, 16)
    .frame(maxWidth: .infinity, minHeight: 146)
    .background(Color(.surfacePrimary))
    .clipShape(RoundedRectangle(cornerRadius: 12))
    .overlay(
      UnevenBorderShape(
        cornerRadius: 12,
        borderWidths: .init(top: 2, leading: 2, bottom: 4, trailing: 2)
      )
      .fill(Color(.borderPrimary), style: FillStyle(eoFill: true))
    )
    .clipShape(RoundedRectangle(cornerRadius: 12))
  }
}

// MARK: - Coin Card Component
/// Card displaying coin package with image, title, and purchase button
struct CoinCard: View {
  let imageName: String
  let title: String
  let price: String
  let action: () -> Void

  var body: some View {
    VStack(spacing: 16) {
      // Coin Image
      Image(imageName)
        .resizable()
        .scaledToFit()
        .frame(height: 99)
        .padding(.top, 20)

      // Title
      Text(title)
        .font(.LilitaOne(size: .lg))
        .foregroundStyle(.textPrimary)

      // Price Button
      MathButton(
        label: price,
        brandStyle: .secondary,
        fullWidth: true,
        action: action
      )
      .padding(.bottom, 18)
    }
    .padding(.horizontal, 16)
    // .frame(height: 240)
    .background(Color(.surfacePrimary))
    .clipShape(RoundedRectangle(cornerRadius: 12))
    .overlay(
      UnevenBorderShape(
        cornerRadius: 12,
        borderWidths: .init(top: 2, leading: 2, bottom: 4, trailing: 2)
      )
      .fill(Color(.borderPrimary), style: FillStyle(eoFill: true))
    )
    .clipShape(RoundedRectangle(cornerRadius: 12))
  }
}

struct StoreView: View {
  @Environment(\.dismiss) var dismiss

  /// Binding to control bottom tab bar visibility from AppRoot
  @Environment(\.tabBarVisible) private var tabBarVisible

  @State private var selectedTab: StoreTab = .coins

  var body: some View {
    VStack(spacing: 24) {
      TabGroup {
        TabList {
          TabItem(
            label: "Coins",
            isSelected: selectedTab == .coins,
            action: {
              withAnimation(.spring(response: 0.3)) {
                selectedTab = .coins
              }
            }
          )

          TabItem(
            label: "Packs",
            isSelected: selectedTab == .packs,
            action: {
              withAnimation(.spring(response: 0.3)) {
                selectedTab = .packs
              }
            }
          )
        }
      }
      .frame(maxWidth: .infinity, alignment: .center)

      // Content Area with animated transitions
      MathScrollView(.vertical, showsIndicators: false) {
        switch selectedTab {
        case .coins:
          CoinsGridView()
            .padding(.horizontal, 20)
            .padding(.top, 12)
            // .padding(.bottom, 100)
            .transition(
              .asymmetric(
                insertion: .move(edge: .trailing).combined(with: .opacity),
                removal: .move(edge: .leading).combined(with: .opacity)
              )
            )
            .id("coins")
        case .packs:
          PacksGridView()
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 100)
            .transition(
              .asymmetric(
                insertion: .move(edge: .trailing).combined(with: .opacity),
                removal: .move(edge: .leading).combined(with: .opacity)
              )
            )
            .id("packs")
        }
      }
      .animation(.spring(response: 0.4, dampingFraction: 0.8), value: selectedTab)

      // Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.white)
    .navigationBarBackButtonHidden(true)
    .navigationBarTitleDisplayMode(.inline)
    // MARK: - Tab Bar Visibility Management
    // Hide bottom tab bar when Store screen appears (with animation)
    .onAppear {
      withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
        tabBarVisible.wrappedValue = false
      }
    }
    // Restore tab bar visibility when navigating away from Store (with animation)
    .onDisappear {
      withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
        tabBarVisible.wrappedValue = true
      }
    }
    .toolbar {
      ToolbarItem(placement: .principal) {
        Text("Store")
          .font(.LilitaOne(size: .md))
          .foregroundStyle(.textPrimary)
      }

      ToolbarItem(placement: .navigationBarLeading) {
        Button {
          dismiss()
        } label: {
          Image("back-path-dark")
            .resizable()
            .scaledToFit()
            .frame(width: 24, height: 15)
            .foregroundStyle(.textPrimary)
        }
      }
    }
  }
}

// MARK: - Press Effect Modifier
/// Extension to apply conditional press effects to views
extension View {
  func conditionalEffect(_ isActive: Bool) -> some View {
    self.modifier(ConditionalPressEffect(isActive: isActive))
  }
}

/// ViewModifier that applies scale/opacity/offset effects only when active
struct ConditionalPressEffect: ViewModifier {
  let isActive: Bool
  @State private var isPressed = false

  func body(content: Content) -> some View {
    content
      .scaleEffect(isActive && isPressed ? 0.98 : 1.0)
      .opacity(isActive && isPressed ? 0.9 : 1.0)
      .offset(y: isActive && isPressed ? 2 : 0)
      .simultaneousGesture(
        DragGesture(minimumDistance: 0)
          .onChanged { _ in
            if isActive && !isPressed {
              isPressed = true
            }
          }
          .onEnded { _ in
            isPressed = false
          }
      )
  }
}

#Preview {
  StoreView()
}
