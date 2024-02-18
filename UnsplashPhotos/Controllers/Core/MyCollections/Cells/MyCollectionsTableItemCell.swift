//
//  MyCollectionsTableItemCell.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 30.11.23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class MyCollectionsTableItemCell: ContentTableViewCell {
    
    let emptyThumbUrl = "https://thumbs.dreamstime.com/b/no-thumbnail-image-placeholder-forums-blogs-websites-148010362.jpg"
    
    let disposeBag = DisposeBag()
    var subscriptionBag: Disposable!
    var item: CollectionResponse!
    var delegate: MyCollectionsTableItemCellProtocol?
    
    var containerView: UIView!
    var thumbImage: UIImageView!
    var nameLabel: UILabel!
    var descriptionLabel: UILabel!
    
    var cardButton: UIButton!
    
    override func setupViews() {
        super.setupViews()
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        containerView = UIView()
        containerView.layer.cornerRadius = 20
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.white.cgColor
        self.addSubview(containerView)
        
        thumbImage = UIImageView()
        thumbImage.contentMode = .scaleAspectFill
        thumbImage.layer.cornerRadius = 20
        thumbImage.clipsToBounds = true
        containerView.addSubview(thumbImage)
        
        nameLabel = UILabel()
        nameLabel.text = "Default Collection Name"
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        nameLabel.textColor = .white
        containerView.addSubview(nameLabel)
        
        descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        descriptionLabel.textColor = .white
        containerView.addSubview(descriptionLabel)
        
        cardButton = UIButton()
        observeCardButtonClick()
        self.addSubview(cardButton)
        
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(20)
        }
        
        thumbImage.snp.makeConstraints { make in
            make.edges.equalTo(containerView)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(containerView).inset(40)
            make.left.equalTo(containerView).offset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.right.equalTo(containerView).inset(20)
            make.bottom.equalTo(containerView).inset(10)
        }
        
        cardButton.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    func setup(_ item: CollectionResponse) {
        self.item = item
        thumbImage.kf.setImage(with: URL(string: item.cover_photo?.urls.thumb ?? emptyThumbUrl))
        nameLabel.text = item.title
        descriptionLabel.text = item.description
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.isSelected ? selectMode() : deselectMode()
//        if isSelected {
//            selectMode()
//        } else {
//            deselectMode()
//        }
    }
    
    private func selectMode() {
        containerView.layer.shadowColor = UIColor.systemRed.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowRadius = 20
        startShake()
    }
    
    private func deselectMode() {
        containerView.layer.shadowColor = .none
        containerView.layer.shadowOpacity = .zero
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowRadius = 0
        stopShake()
    }
    
    private func observeCardButtonClick() {
        cardButton.rx.tap.bind {
            self.delegate?.cardTapped(self.item, self)
        }.disposed(by: disposeBag)
    }
    
    private func startShake(duration: CFTimeInterval = 0.5, pathLength: CGFloat = 1) {
        let position: CGPoint = self.center

        let path: UIBezierPath = UIBezierPath()
        path.move(to: CGPoint(x: position.x, y: position.y))
        path.addLine(to: CGPoint(x: position.x, y: position.y-pathLength))
        path.addLine(to: CGPoint(x: position.x, y: position.y+pathLength))
        path.addLine(to: CGPoint(x: position.x, y: position.y-pathLength))
        path.addLine(to: CGPoint(x: position.x, y: position.y+pathLength))
        path.addLine(to: CGPoint(x: position.x, y: position.y))

        let positionAnimation = CAKeyframeAnimation(keyPath: "position")

        positionAnimation.path = path.cgPath
        positionAnimation.duration = duration
        positionAnimation.repeatCount = .infinity
        positionAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)

        CATransaction.begin()
        self.layer.add(positionAnimation, forKey: nil)
        CATransaction.commit()
    }

    private func stopShake() {
        self.layer.removeAllAnimations()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbImage.image = nil
        nameLabel.text = nil
        descriptionLabel.text = nil
    }
}

protocol MyCollectionsTableItemCellProtocol {
    func cardTapped(_ item: CollectionResponse, _ cell: MyCollectionsTableItemCell)
}
