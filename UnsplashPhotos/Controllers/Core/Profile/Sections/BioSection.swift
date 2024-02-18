//
//  BioSection.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 5.12.23.
//

import Foundation
import UIKit


class BioSection: ContentView {
    
    var bioLabel: UILabel!
    var textView: UITextView!
    
    override func setupViews() {
        super.setupViews()
        
        bioLabel = UILabel()
        bioLabel.text = "Bio:"
        bioLabel.font = UIFont.teko(size: 25).bold
        bioLabel.textColor = .white
        self.addSubview(bioLabel)
        
        textView = UITextView()
        textView.font = UIFont.teko(size: 16)
        textView.textColor = .white
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.layer.cornerRadius = 10
        textView.layer.backgroundColor = UIColor.init(hex: 0x202226).cgColor
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.white.cgColor
        textView.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        self.addSubview(textView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        bioLabel.snp.makeConstraints { make in
            make.top.left.equalTo(self).offset(20)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(bioLabel.snp.bottom).offset(10)
            make.left.right.equalTo(self).inset(10)
            make.bottom.equalTo(self)
            make.height.equalTo(100)
        }
    }
    
    func setup(_ bio: String) {
        textView.text = bio
    }
}
