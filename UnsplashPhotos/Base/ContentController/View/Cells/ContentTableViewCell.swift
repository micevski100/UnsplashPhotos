//
//  ContentTableViewCell.swift
//  MiaTestProject
//
//  Created by Aleksandar Micevski on 7.10.23.
//

import UIKit

open class ContentTableViewCell: UITableViewCell {
    
    open var shouldSetupConstraints = true
    public let screenSize = UIScreen.main.bounds
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews();
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews();
    }
    
    open override func updateConstraints() {
        // AutoLayout constraints
        if(shouldSetupConstraints) {
            // Configurar Constraints
            self.contentView.isUserInteractionEnabled = false // fixes Xcode12+ unclickable cells
            setupConstraints();
            // Ya se configuro
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
    
    
    open func setupViews() { }
    open func setupConstraints() { }
}
