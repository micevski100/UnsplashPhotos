//
//  GenericSection.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 5.12.23.
//

import UIKit
import Kingfisher



class GenericSection: ContentView {
    
    var containerView: UIView!
    var imageView: UIImageView!
    var sectionNameLabel: UILabel!
    var sectionValueLabel: UILabel!
    var cardButton: UIButton!
    
    
    override func setupViews() {
        super.setupViews()
        self.backgroundColor = .clear
        
        containerView = UIView()
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.white.cgColor
        containerView.layer.cornerRadius = 10
        containerView.layer.backgroundColor = UIColor.init(hex: 0x202226).cgColor
        containerView.layer.shadowRadius = 2
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowColor = UIColor.white.withAlphaComponent(0.3).cgColor
        self.addSubview(containerView)
        
        imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .white
        containerView.addSubview(imageView)
        
        sectionNameLabel = UILabel()
        sectionNameLabel.font = UIFont.teko(size: 15)
        sectionNameLabel.textColor = .white
        containerView.addSubview(sectionNameLabel)
        
        sectionValueLabel = UILabel()
        sectionValueLabel.font = UIFont.teko(size: 15)
        sectionValueLabel.textColor = .white
        containerView.addSubview(sectionValueLabel)
        
        cardButton = UIButton()
        containerView.addSubview(cardButton)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalTo(self)
            make.left.right.equalTo(self).inset(10)
            make.height.equalTo(40)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerY.equalTo(containerView)
            make.left.equalTo(containerView).offset(10)
            make.width.height.equalTo(25)
        }
        
        sectionNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(containerView)
            make.left.equalTo(imageView.snp.right).offset(10)
            make.right.equalTo(sectionValueLabel.snp.left).inset(10)
        }
        
        sectionValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(containerView)
            make.right.equalTo(containerView).inset(10)
        }
        
        cardButton.snp.makeConstraints { make in
            make.edges.equalTo(containerView)
        }
    }
    
    func setup(_ image: UIImage, _ name: String, _ value: String) {
        imageView.image = image
        sectionNameLabel.text = name
        sectionValueLabel.text = value
    }
}
