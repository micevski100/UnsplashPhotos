//
//  LikedCollectionItemCell.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 5.12.23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class LikedCollectionItemCell: ContentCollectionViewCell {
    
    let disposeBag = DisposeBag()
    var subscriptionBag: Disposable!
    var item: PhotoResponse!
    
    var containerView: UIView!
    var imageView: UIImageView!
    
    override func setupViews() {
        super.setupViews()
        self.backgroundColor = .clear
        
        containerView = UIView()
        self.contentView.addSubview(containerView)
        
        imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        containerView.addSubview(imageView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(self.contentView)
            make.height.greaterThanOrEqualTo(1)
        }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(containerView)
        }
    }
    
    func setup(_ item: PhotoResponse) {
        self.item = item
        imageView.kf.cancelDownloadTask()
        imageView.kf.setImage(with: URL(string: item.urls.regular))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
