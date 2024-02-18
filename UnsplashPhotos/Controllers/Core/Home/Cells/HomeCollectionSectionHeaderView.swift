//
//  HomeCollectionSectionHeaderView.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 16.10.23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher


class HomeCollectionSectionHeaderView: UICollectionReusableView {
    
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.backgroundColor = .clear
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.teko(size: 22).bold
        titleLabel.textColor = .white
        self.addSubview(titleLabel)
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(20)
            make.bottom.left.right.equalTo(self).inset(10)
        }
    }
    
    func setup(_ title: String) {
        titleLabel.text = title
    }
}
