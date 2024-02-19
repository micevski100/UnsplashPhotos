//
//  PopUpBaseView.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 15.2.24.
//

import UIKit
import RxSwift
import RxCocoa

class PopUpBaseView: ContentView {
    
    let disposeBag = DisposeBag()
    var subscriptionBag: Disposable!
    var delegate: PopUpBaseViewDelegate?
    
    var backGroundContainer: UIView!
    var contentContainer: UIView!
    
    var closeButton: UIButton!
    var titleLabel: UILabel!
    var titleDivider: UIView!
    
    override func setupViews() {
        super.setupViews()
        self.backgroundColor = .clear
        
        let backgroundTapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        backGroundContainer = UIView()
        backGroundContainer.backgroundColor = .black.withAlphaComponent(0.6)
        backGroundContainer.isUserInteractionEnabled = true
        backGroundContainer.addGestureRecognizer(backgroundTapGesture)
        self.addSubview(backGroundContainer)
        
        contentContainer = UIView()
        contentContainer.backgroundColor = UIColor.white
        contentContainer.layer.backgroundColor = UIColor.init(hex: 0xF3F7F9).cgColor
        contentContainer.layer.cornerRadius = 15
        contentContainer.layer.borderWidth = 2
        contentContainer.layer.borderColor = UIColor.init(hex: 0xF3F7F9).cgColor
        contentContainer.layer.shadowRadius = 3
        contentContainer.layer.shadowOffset = .init(width: 0, height: 2)
        contentContainer.layer.shadowOpacity = 1
        contentContainer.layer.shadowColor = UIColor.init(hex:0x5E799E).withAlphaComponent(0.3).cgColor
        self.addSubview(contentContainer)
        
        closeButton = UIButton()
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .black
        contentContainer.addSubview(closeButton)
        
        titleLabel = UILabel()
        titleLabel.text = "Title"
        titleLabel.textColor = .black
        titleLabel.font = UIFont.teko(size: 17).bold
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        contentContainer.addSubview(titleLabel)
        
        titleDivider = UIView()
        titleDivider.backgroundColor = .systemGray3
        contentContainer.addSubview(titleDivider)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        backGroundContainer.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        contentContainer.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.8)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.left.equalTo(contentContainer).offset(13)
            make.width.height.equalTo(15)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentContainer).offset(30)
            make.left.right.equalTo(contentContainer).inset(15)
        }
        
        titleDivider.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.right.equalTo(contentContainer).inset(40)
            make.height.equalTo(1)
        }
    }
    
    func show() {
        backGroundContainer.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        backGroundContainer.alpha = 0
        
        contentContainer.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        contentContainer.alpha = 0
        
        UIView.animate(withDuration: 0.5) {
            self.backGroundContainer.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.backGroundContainer.alpha = 1
            
            self.contentContainer.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.contentContainer.alpha = 1
        }
    }
    
    func hide(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.5) {
            self.backGroundContainer.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.backGroundContainer.alpha = 0
            
            self.contentContainer.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.contentContainer.alpha = 0
            
        } completion: { _ in
            completion()
        }
    }
    
    @objc func backgroundTapped() {
        self.delegate?.backgroundTapped()
    }
}

protocol PopUpBaseViewDelegate {
    func backgroundTapped()
}
