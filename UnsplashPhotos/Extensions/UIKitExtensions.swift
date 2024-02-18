//
//  UIKitExtensions.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 13.10.23.
//

import Foundation
import UIKit

protocol ReusableView: AnyObject {
    static var reuseIdentifier: String { get }
}

extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView {
}

extension UICollectionViewCell: ReusableView {
}

extension UITableView {
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        
        return cell
    }
}

extension UICollectionView {
    
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        
        return cell
    }
}


extension UIView {
    func setStatusBarAlpha(_ alpha: CGFloat) {
        let tag = 109901
        
        let statusBarView = self.viewWithTag(tag)
        statusBarView?.backgroundColor = statusBarView?.backgroundColor?.withAlphaComponent(alpha)
    }
}
