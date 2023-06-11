//
//  UIView+Ext.swift
//  Locrimo
//
//  Created by Tahir Anil Oghan on 16.03.2023.
//

import UIKit

extension UIView {
    
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.masksToBounds = true
            layer.cornerRadius = newValue
        }
    }
    
    func rounded() {
        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.masksToBounds = true
    }
}
