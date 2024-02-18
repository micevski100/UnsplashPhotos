//
//  UIColor.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 19.10.23.
//

import UIKit

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat) {
        let r = CGFloat((hex & 0xFF0000) >> 16)/255
        let g = CGFloat((hex & 0xFF00) >> 8)/255
        let b = CGFloat(hex & 0xFF)/255
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }

    convenience init(hex: Int) {
        self.init(hex: hex, alpha: 1.0)
    }
}
