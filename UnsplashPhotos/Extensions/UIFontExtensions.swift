//
//  UIFontExtensions.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 13.10.23.
//

import Foundation
import UIKit

extension UIFont {
    var bold: UIFont {
        return with(.traitBold)
    }

    var italic: UIFont {
        return with(.traitItalic)
    }

    var boldItalic: UIFont {
        return with([.traitBold, .traitItalic])
    }

    func with(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits).union(self.fontDescriptor.symbolicTraits)) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }

    func without(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(self.fontDescriptor.symbolicTraits.subtracting(UIFontDescriptor.SymbolicTraits(traits))) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }
    
    class func montserrat(size fontSize: CGFloat) -> UIFont {
        let traits = [UIFontDescriptor.TraitKey.weight: UIFont.Weight.regular]
        let fontDescriptor = UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.family: "Montserrat"])
            .addingAttributes([UIFontDescriptor.AttributeName.traits: traits])
        return UIFont(descriptor: fontDescriptor, size: fontSize)
    }
    
    class func montserratSemiBold(size fontSize: CGFloat) -> UIFont {
        let traits = [UIFontDescriptor.TraitKey.weight: UIFont.Weight.semibold]
        let fontDescriptor = UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.family: "Montserrat"])
            .addingAttributes([UIFontDescriptor.AttributeName.traits: traits])
        return UIFont(descriptor: fontDescriptor, size: fontSize)
    }
    
    class func teko(size fontSize: CGFloat) -> UIFont {
        let fontDescriptor = UIFontDescriptor(name: "Teko", size: fontSize)
        return UIFont(descriptor: fontDescriptor, size: fontSize)
    }
    
    class func oswald(size fontSize: CGFloat) -> UIFont {
        let fontDescriptor = UIFontDescriptor(name: "Oswald", size: fontSize)
        return UIFont(descriptor: fontDescriptor, size: fontSize)
    }
}
