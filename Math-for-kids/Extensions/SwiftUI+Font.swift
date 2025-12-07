//
//  SwiftUI+Font.swift
//  MathForkids
//
//  Created by Jeffery Okoli on 06/12/2025.
//
import SwiftUI


// font weight
// font size
// font family

extension Font {
    static func Rubik(size: MathFontSizes.Body = .lg) -> Font {
        return Font.custom("Rubik-Light_Medium", size: size.rawValue)
    }
    
    static func LilitaOne(size: MathFontSizes.Display = .xsm) -> Font {
        return Font.custom("LilitaOne", size: size.rawValue)
    }
}


enum MathFontSizes {
    enum Display: CGFloat {
        case huge = 48
        case xlg = 30
        case lg = 24
        case md = 20
        case sm = 18
        case xsm = 16
    }
    
    enum Body: CGFloat {
        case lg = 16
        case md = 14
        case sm = 12
        case xsm = 10
    }
}


