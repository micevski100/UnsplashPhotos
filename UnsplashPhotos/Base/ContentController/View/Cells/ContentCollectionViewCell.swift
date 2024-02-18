//
//  ContentCollectionViewCell.swift
//  MiaTestProject
//
//  Created by Aleksandar Micevski on 7.10.23.
//

import Foundation
import UIKit

open class ContentCollectionViewCell: UICollectionViewCell {
    
    open var shouldSetupConstraints = true
    public let screenSize = UIScreen.main.bounds
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews();
    }
    
    open override func updateConstraints() {
        // AutoLayout constraints
        if(shouldSetupConstraints) {
            // Configurar Constraints
            setupConstraints();
            // Ya se configuro
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
    
    open func setupViews() { }
    open func setupConstraints() { }
}
