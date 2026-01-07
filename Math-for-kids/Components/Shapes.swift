//
//  Shapes.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 22/12/2025.
//

import SwiftUI

struct TopBorderShape: Shape {
    var cornerRadius: CGFloat
    var borderWidth: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let innerRadius = cornerRadius - borderWidth
        
        // Outer path (top edge with rounded corners)
        path.move(to: CGPoint(x: 0, y: cornerRadius))
        path.addArc(
            center: CGPoint(x: cornerRadius, y: cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(180),
            endAngle: .degrees(270),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: rect.width - cornerRadius, y: 0))
        path.addArc(
            center: CGPoint(x: rect.width - cornerRadius, y: cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(270),
            endAngle: .degrees(0),
            clockwise: false
        )
        
        // Inner path (creating the border effect)
        path.addLine(to: CGPoint(x: rect.width, y: borderWidth))
        path.addArc(
            center: CGPoint(x: rect.width - cornerRadius, y: cornerRadius),
            radius: innerRadius,
            startAngle: .degrees(0),
            endAngle: .degrees(270),
            clockwise: true
        )
        path.addLine(to: CGPoint(x: cornerRadius, y: borderWidth))
        path.addArc(
            center: CGPoint(x: cornerRadius, y: cornerRadius),
            radius: innerRadius,
            startAngle: .degrees(270),
            endAngle: .degrees(180),
            clockwise: true
        )
        path.closeSubpath()
        
        return path
    }
}

struct TopRoundedRectangle: Shape {
    var cornerRadius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: 0, y: cornerRadius))
        path.addArc(
            center: CGPoint(x: cornerRadius, y: cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(180),
            endAngle: .degrees(270),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: rect.width - cornerRadius, y: 0))
        path.addArc(
            center: CGPoint(x: rect.width - cornerRadius, y: cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(270),
            endAngle: .degrees(0),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: cornerRadius))
        path.closeSubpath()
        
        return path
    }
}

struct BottomBorderShape: Shape {
    var cornerRadius: CGFloat
    var borderWidth: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let innerRadius = cornerRadius - borderWidth
        
        // Outer path (bottom edge with rounded corners)
        path.move(to: CGPoint(x: rect.width, y: rect.height - cornerRadius))
        path.addArc(
            center: CGPoint(x: rect.width - cornerRadius, y: rect.height - cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(0),
            endAngle: .degrees(90),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: cornerRadius, y: rect.height))
        path.addArc(
            center: CGPoint(x: cornerRadius, y: rect.height - cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(90),
            endAngle: .degrees(180),
            clockwise: false
        )
        
        // Inner path (creating the border effect)
        path.addLine(to: CGPoint(x: 0, y: rect.height - borderWidth))
        path.addArc(
            center: CGPoint(x: cornerRadius, y: rect.height - cornerRadius),
            radius: innerRadius,
            startAngle: .degrees(180),
            endAngle: .degrees(90),
            clockwise: true
        )
        path.addLine(to: CGPoint(x: rect.width - cornerRadius, y: rect.height - borderWidth))
        path.addArc(
            center: CGPoint(x: rect.width - cornerRadius, y: rect.height - cornerRadius),
            radius: innerRadius,
            startAngle: .degrees(90),
            endAngle: .degrees(0),
            clockwise: true
        )
        path.closeSubpath()
        
        return path
    }
}

struct BottomRoundedRectangle: Shape {
    var cornerRadius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - cornerRadius))
        path.addArc(
            center: CGPoint(x: rect.width - cornerRadius, y: rect.height - cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(0),
            endAngle: .degrees(90),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: cornerRadius, y: rect.height))
        path.addArc(
            center: CGPoint(x: cornerRadius, y: rect.height - cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(90),
            endAngle: .degrees(180),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.closeSubpath()
        
        return path
    }
}

