//
//  URL+Extensions.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 11.10.23.
//

import Foundation

extension URL {
    
    func value(of name: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == name })?.value
    }
}
