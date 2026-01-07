//
//  MathTextField.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 08/12/2025.
//

import SwiftUI

struct MathTextField: View {
    @Binding var text: String

    let label: String
    var isSecure: Bool = false
    var placeholder: String = ""
    var variant: Color = .surfacePrimary
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.Rubik(size: .lg))
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
            
            ZStack(alignment: .leading) {
                if text.isEmpty && !placeholder.isEmpty {
                    Text(placeholder)
                        .font(.Rubik(size: .lg))
                        .foregroundColor(Color(.textInactive))
                }
                
                Group {
                    if isSecure {
                        SecureField("", text: $text)
                    } else {
                        TextField("", text: $text)
                    }
                }
                .font(.Rubik(size: .lg))
                .foregroundColor(.textPrimary)
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, minHeight: 52)
            .background(variant)
            .overlay(
                UnevenBorderShape(
                    cornerRadius: 12,
                    borderWidths: .init(top: 1, leading: 1, bottom: 3, trailing: 1)
                )
                .fill(Color(.borderPrimary), style: FillStyle(eoFill: true))
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

// Custom shape for borders with different widths on each side (like CSS)
struct UnevenBorderShape: Shape {
    var cornerRadius: CGFloat
    var borderWidths: EdgeInsets
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius = cornerRadius
        let top = borderWidths.top
        let leading = borderWidths.leading
        let bottom = borderWidths.bottom
        let trailing = borderWidths.trailing
        
        // Create outer rounded rectangle
        let outerRect = rect
        let outerPath = Path(roundedRect: outerRect, cornerRadius: radius)
        
        // Create inner rounded rectangle (inset by border widths)
        let innerRect = CGRect(
            x: rect.origin.x + leading,
            y: rect.origin.y + top,
            width: rect.width - leading - trailing,
            height: rect.height - top - bottom
        )
        
        // Adjust inner corner radius proportionally
        let innerRadius = max(0, radius - min(leading, trailing, top, bottom))
        let innerPath = Path(roundedRect: innerRect, cornerRadius: innerRadius)
        
        // Combine paths for even-odd fill (outer minus inner = border)
        path.addPath(outerPath)
        path.addPath(innerPath)
        
        return path
    }
}

