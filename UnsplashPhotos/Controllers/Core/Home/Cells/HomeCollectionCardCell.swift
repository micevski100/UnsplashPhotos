//
//  HomeCollectionCardCell.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 19.10.23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class HomeCollectionCardCell: ContentCollectionViewCell {
    
    let disposeBag = DisposeBag()
    var subscriptionBag: Disposable!
//    var delegate: CollectionClickDelegate?
    
    var collectionResponse: CollectionResponse!
    var item: PhotoResponse!
    var cardShape: CollectionShape!
    
    var imageView: UIImageView!
    
    var titleContainer: UIView!
    var goToDetailsButton: UIButton!
    var titleLabel: UILabel!
    
    override func setupViews() {
        super.setupViews()
        self.backgroundColor = .clear
        
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.shadowRadius = 5
        imageView.layer.shadowOffset = .zero
        imageView.layer.shadowOpacity = 1
        imageView.layer.shadowColor = UIColor.white.withAlphaComponent(0.3).cgColor
        self.addSubview(imageView)
        
        
        titleContainer = UIView()
        titleContainer.backgroundColor = .clear
        self.addSubview(titleContainer)
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.teko(size: 22).bold
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2
        titleContainer.addSubview(titleLabel)
        
        goToDetailsButton = UIButton()
        goToDetailsButton.setImage(UIImage(systemName: "arrow.right.circle.fill"), for: .normal)
        goToDetailsButton.tintColor = .lightGray
        goToDetailsButton.contentHorizontalAlignment = .fill
        goToDetailsButton.contentVerticalAlignment = .fill
        goToDetailsButton.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
        goToDetailsButton.rx.tap.bind {
//            self.delegate?.collectionClicked(self.collectionResponse, self.cardShape)
        }.disposed(by: disposeBag)
        titleContainer.addSubview(goToDetailsButton)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.left.equalTo(titleContainer).inset(15)
            make.right.equalTo(goToDetailsButton.snp.left).inset(10)
        }
        
        goToDetailsButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.right.equalTo(titleContainer).inset(20)
            make.width.height.equalTo(30)
        }
    }
    
    func setup(_ collectionResponse: CollectionResponse, _ title: String, _ item: PhotoResponse, _ cardShape: CollectionShape) {
        self.item = item
        self.collectionResponse = collectionResponse
        self.cardShape = cardShape
        
        titleLabel.text = title
        imageView.kf.setImage(with: URL(string: item.urls.small))
        titleContainer.snp.removeConstraints()
        switch cardShape {
        case .singleCardSmall:
            titleContainer.backgroundColor = .clear
            titleContainer.snp.makeConstraints { make in
                make.left.right.equalTo(self)
                make.centerY.equalTo(self)
            }
        case .singleCardLarge:
            titleContainer.backgroundColor = .black.withAlphaComponent(0.8)
            titleContainer.snp.makeConstraints { make in
                make.left.right.equalTo(self)
                make.bottom.equalTo(self)
            }
        default:
            break
        }
    }
}
