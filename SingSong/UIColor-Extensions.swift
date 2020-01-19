//
//  UIColor-Extensions.swift
//  SingSong
//
//  Created by Jake Grant on 2/19/19.
//  Copyright © 2019 Jake Grant. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0

        var rgbValue: UInt64 = 0

        scanner.scanHexInt64(&rgbValue)

        let redHex = (rgbValue & 0xff0000) >> 16
        let greenHex = (rgbValue & 0xff00) >> 8
        let blueHex = rgbValue & 0xff

        self.init(
            red: CGFloat(redHex) / 0xff,
            green: CGFloat(greenHex) / 0xff,
            blue: CGFloat(blueHex) / 0xff, alpha: 1
        )
    }

    convenience init(red: Double, green: Double, blue: Double) {
        let redAdditive = red / 255.0
        let greenAdditive = green / 255.0
        let blueAdditive = blue / 255.0

        self.init(
            red: CGFloat(redAdditive),
            green: CGFloat(greenAdditive),
            blue: CGFloat(blueAdditive), alpha: 1.0
        )
    }
}

extension UIColor {
    static func darkModeText() -> UIColor {
        return UIColor(red: 174, green: 192, blue: 200)
    }

    static func darkModeSubtitle() -> UIColor {
        return UIColor(red: 111, green: 115, blue: 115)
    }

    static func darkModeBackground() -> UIColor {
        return UIColor(red: 30, green: 32, blue: 34)
    }

    static func darkModeTint() -> UIColor {
        return UIColor(red: 107, green: 196, blue: 240)
    }

    static func darkModeCellSeparator() -> UIColor {
        return UIColor(red: 0, green: 0, blue: 0)
    }
}

extension UIColor {
    static func lightModeText() -> UIColor {
        return UIColor(red: 0, green: 0, blue: 0)
    }

    static func lightModeSubtitle() -> UIColor {
        return UIColor(red: 76, green: 76, blue: 76)
    }

    static func lightModeBackground() -> UIColor {
        return UIColor(red: 255, green: 255, blue: 255)
    }

    static func lightModeTint() -> UIColor {
        return UIColor(red: 21, green: 126, blue: 251)
    }

    static func lightModeCellSeparator() -> UIColor {
        return UIColor(red: 217, green: 217, blue: 219)
    }
}

extension UIColor {
    static func getUserThemePreference() -> UserThemePreference {
        let defaults = UserDefaults.standard
        if let theme = defaults.string(forKey: "UserThemePreference"),
            let preferedTheme = UserThemePreference(rawValue: theme) {
            return preferedTheme
        } else {
            return .dark
        }
    }

    static func preferedTextColor() -> UIColor {
        switch getUserThemePreference() {
        case .dark:
            return darkModeText()
        case .light:
            return lightModeText()
        }
    }

    static func preferedSubtitleColor() -> UIColor {
        switch getUserThemePreference() {
        case .dark:
            return darkModeSubtitle()
        case .light:
            return lightModeSubtitle()
        }
    }

    static func preferedBackgroundColor() -> UIColor {
        switch getUserThemePreference() {
        case .dark:
            return darkModeBackground()
        case .light:
            return lightModeBackground()
        }
    }

    static func preferedTintColor() -> UIColor {
        switch getUserThemePreference() {
        case .dark:
            return darkModeTint()
        case .light:
            return lightModeTint()
        }
    }

    static func preferedCellSeparatorColor() -> UIColor {
        switch getUserThemePreference() {
        case .dark:
            return darkModeCellSeparator()
        case .light:
            return lightModeCellSeparator()
        }
    }
}
