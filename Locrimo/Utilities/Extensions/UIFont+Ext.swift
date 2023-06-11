//
//  UIFont+Ext.swift
//  Locrimo
//
//  Created by Tahir Anil Oghan on 16.03.2023.
//

import UIKit

extension UIFont {
    
    enum Avenir: String {
        case Book, Medium, Heavy
    }
    
    static func avenir(_ type: UIFont.Avenir, size: CGFloat) -> UIFont {
        return UIFont.init(name: "Avenir-\(type.rawValue)", size: size)!
    }
    
}
