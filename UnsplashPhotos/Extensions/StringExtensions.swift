//
//  StringExtensions.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 18.2.24.
//

import Foundation

extension String {
    func containsOnlyLetters() -> Bool {
       for chr in self {
          if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
             return false
          }
       }
       return true
    }
}
