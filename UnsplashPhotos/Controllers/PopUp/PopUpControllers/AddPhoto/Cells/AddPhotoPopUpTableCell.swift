//
//  AddPhotoPopUpTableCell.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 15.2.24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class AddPhotoPopUpTableCell: ContentTableViewCell {
    
    var collectionId: String!
    var titleLabel: UILabel!
    
    override func setupViews() {
        super.setupViews()
        self.backgroundColor = .clear
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.teko(size: 20)
        self.contentView.addSubview(titleLabel)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalTo(self.contentView).offset(10)
            make.left.right.equalTo(self.contentView).inset(20)
            make.bottom.equalTo(self.contentView).inset(10)
        }
    }
    
    func setup(_ title: String, _ collectionId: String) {
        titleLabel.text = title
        self.collectionId = collectionId
    }
}
