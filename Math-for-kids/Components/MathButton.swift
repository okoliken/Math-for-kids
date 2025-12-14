//
//  SwiftUIView.swift
//  MathForkids
//
//  Created by Jeffery Okoli on 06/12/2025.
//

import SwiftUI


struct MathButton: View {
    let label: String
    var brandStyle: ButtonBrandStyle = .brand
    var fullWidth: Bool = false
    var action: (() -> Void)? = nil
   
    var body: some View {
        Button {
            action?()
        } label: {
            Text(label)
        }
        .buttonStyle(MathButtonBrandStyle(style: brandStyle, fullWidth: fullWidth))
    }
    
}

enum ButtonBrandStyle {
    case brand
    case lime
    case fuchsia
    case error
    case warning
    case success
    case secondary
    
    var contentColor: Color {
        switch self {
            case .brand:
                return Color(.brandContent)
            case .lime:
                return Color(.limeContent)
            case .fuchsia:
                return Color(.fuchsiaContent)
            case .error:
                return Color(.errorContent)
            case .warning:
                return Color(.warningContent)
            case .success:
                return Color(.successContent)
            case .secondary:
                return Color(.surfaceSecondary)
        }
    }
    
    var borderColor: Color {
        switch self {
            case .brand:
                return Color(.borderContent)
            case .lime:
                return Color(.limeBorder)
            case .fuchsia:
                return Color(.fuchsiaBorder)
            case .error:
                return Color(.errorBorder)
            case .warning:
                return Color(.warningBorder)
            case .success:
                return Color(.successBorder)
            case .secondary:
                return Color(.borderSecondary)
        }
    }
}

struct MathButtonBrandStyle: ButtonStyle {
    let style: ButtonBrandStyle
    var fullWidth: Bool = false
    
    var color: Color {
        return style == .secondary ? .textPrimary : .white
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.LilitaOne(size: .xsm))
            .foregroundColor(color)
            .padding(.vertical, 14)
            .padding(.horizontal, 16)
            .frame(maxWidth: fullWidth ? .infinity : nil, minHeight: 52)
            .background(
                ZStack(alignment: .bottom) {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(style.borderColor)
                        .offset(y: 3)
                    RoundedRectangle(cornerRadius: 14)
                        .fill(style.contentColor)
                }
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .offset(y: configuration.isPressed ? 2 : 0)
    }
    
}


