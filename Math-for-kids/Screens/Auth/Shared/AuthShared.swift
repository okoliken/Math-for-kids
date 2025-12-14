//
//  AuthShared.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 11/12/2025.
//

import SwiftUI

struct AuthBackground<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {

            Image("Brand")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            content
  
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

/// Shared white card container used across auth screens.
struct AuthCard<Content: View>: View {
  var height: CGFloat = 440
  let content: Content

  init(height: CGFloat = 440, @ViewBuilder content: () -> Content) {
    self.height = height
    self.content = content()
  }

  var body: some View {
    ZStack(alignment: .center) {
      RoundedRectangle(cornerRadius: 16)
        .fill(.white)
        .frame(height: height)
        .shadow(color: Color.black.opacity(0.12), radius: 16, x: 0, y: 0)

      content
        .padding(24)
    }
  }
}


struct AvatarGroup: View {
    var body: some View {
        HStack(spacing: -16) {
          Image("av1")
          Image("av2")
          Image("av3")
        }
    }
}
