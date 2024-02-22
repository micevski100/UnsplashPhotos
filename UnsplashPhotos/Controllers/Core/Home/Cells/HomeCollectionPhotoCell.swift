//
//  HomeCollectionPhotoCell.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 14.10.23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class HomeCollectionPhotoCell: ContentCollectionViewCell {
    
    let disposeBag = DisposeBag()
    var subscriptionBag: Disposable!
    var item: PhotoResponse!
    var collectionResponse: CollectionResponse!
    var delegate: HomeCollectionPhotoCellDelegate?
    
    var imageView: UIImageView!
    
    var likesStack: UIStackView!
    var likeButton: UIButton!
    var numOfLikesLabel: UILabel!
    
    override func setupViews() {
        super.setupViews()
        self.backgroundColor = .clear
        
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.shadowRadius = 5
        imageView.layer.shadowOffset = .zero
        imageView.layer.shadowOpacity = 1
        imageView.layer.shadowColor = UIColor.white.withAlphaComponent(0.3).cgColor
        self.addSubview(imageView)
        
        likeButton = UIButton(type: .custom)
        likeButton.tintColor = .white
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        likeButton.isSelected = false
        observeLikeButtonClick()
        
        numOfLikesLabel = UILabel()
        numOfLikesLabel.font = UIFont.systemFont(ofSize: 10)
        numOfLikesLabel.textColor = .white
        
        likesStack = UIStackView(arrangedSubviews: [numOfLikesLabel, likeButton])
        likesStack.distribution = .fillProportionally
        likesStack.axis = .horizontal
        self.addSubview(likesStack)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        likesStack.snp.makeConstraints { make in
            make.bottom.right.equalTo(self).inset(10)
        }
    }
    
    func setup(_ collectionResponse: CollectionResponse, _ item: PhotoResponse, _ withCornerRadius: Bool) {
        self.collectionResponse = collectionResponse
        self.item = item
        imageView.kf.cancelDownloadTask()
        imageView.kf.setImage(with: URL(string: item.urls.small))
        imageView.layer.borderWidth = withCornerRadius ? 2 : 0
        imageView.layer.cornerRadius = withCornerRadius ? 10 : 0
        numOfLikesLabel.text = "\(item.likes)"
        likeButton.isSelected = item.liked_by_user
    }
    
    private func observeLikeButtonClick() {
        likeButton.rx.tap.bind {
            self.likeButton.isSelected.toggle()
            self.delegate?.photoLikeButtonClick(self.likeButton.isSelected, self.item.id)
            self.numOfLikesLabel.text = "\(self.item.likes)"
        }.disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        numOfLikesLabel.text = nil
        likeButton.isSelected = false
    }
}

protocol HomeCollectionPhotoCellDelegate {
    func photoLikeButtonClick(_ isSelected: Bool, _ photoId: String)
}
