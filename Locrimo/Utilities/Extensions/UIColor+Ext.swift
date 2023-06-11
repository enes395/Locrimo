//
//  UIColor+Ext.swift
//  Locrimo
//
//  Created by Tahir Anil Oghan on 16.03.2023.
//

import UIKit

extension UIColor {
    
    fileprivate static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor.init(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    
    static var rickGreen: UIColor = {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    return softGreen
                } else {
                    return brightGreen
                }
            }
        } else {
            /// Return a fallback color for iOS 12 and lower.
            return brightGreen
        }
      }()
    
    static var blackWhite: UIColor = {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    return white
                } else {
                    return black
                }
            }
        } else {
            /// Return a fallback color for iOS 12 and lower.
            return black
        }
      }()
    
    static var brightGreen: UIColor {
        return rgb(red: 103, green: 235, blue: 52, alpha: 1)
    }
    
    static var softGreen: UIColor {
        return rgb(red: 52, green: 235, blue: 107, alpha: 1)
    }
    
    static var white: UIColor {
        return rgb(red: 255, green: 255, blue: 255, alpha: 1)
    }
    
    static var black: UIColor {
        return rgb(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
}
