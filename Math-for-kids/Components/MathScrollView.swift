//
//  MathScrollView.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 22/12/2025.
//

import SwiftUI

struct MathScrollView<Content: View>: View {
    let axis: Axis.Set
    let showsIndicators: Bool
    let content: () -> Content
    
    init(
        _ axis: Axis.Set = .vertical,
        showsIndicators: Bool = false,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.axis = axis
        self.showsIndicators = showsIndicators
        self.content = content
    }
    
    var body: some View {
        ScrollView(axis, showsIndicators: showsIndicators) {
            content()
        }
    }
}
