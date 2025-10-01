//
//  BackgroundColor.swift
//  Finance
//
//  Created by Giorgi Zautashvili on 01.10.25.
//

import UIKit

extension UIColor {
    /// Init from hex string like "#RRGGBB" or "RRGGBB". Alpha optional.
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexString.hasPrefix("#") { hexString.removeFirst() }
        assert(hexString.count == 6, "Invalid hex code used.")
        let rString = hexString.prefix(2)
        let gString = hexString.dropFirst(2).prefix(2)
        let bString = hexString.dropFirst(4).prefix(2)
        let r = CGFloat(Int(rString, radix: 16) ?? 0) / 255.0
        let g = CGFloat(Int(gString, radix: 16) ?? 0) / 255.0
        let b = CGFloat(Int(bString, radix: 16) ?? 0) / 255.0
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }

    /// Aston Martin / Racing Green (common option)
    static var astonMartinRacingGreen: UIColor {
        return UIColor(hex: "#004225")
    }

    /// Slightly lighter variant
    static var astonMartinRacingGreenLight: UIColor {
        return UIColor(hex: "#007A4D")
    }

    /// Slightly darker variant
    static var astonMartinRacingGreenDark: UIColor {
        return UIColor(hex: "#00391B")
    }
}
