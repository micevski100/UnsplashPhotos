//
//  ProfileHeaderSection.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 5.12.23.
//

import UIKit
import Kingfisher

class ProfileHeaderSection: ContentView {
    
    let profileImageHeight: CGFloat = 100.0
    
    var profileImageView: UIImageView!
    var nameLabel: UILabel!
    
    var stack: UIStackView!
    
    var followingLabel: UILabel!
    var followersLabel: UILabel!
    var collectionsLabel: UILabel!
    
    override func setupViews() {
        super.setupViews()
        self.backgroundColor = .clear
        
        profileImageView = UIImageView()
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = profileImageHeight / 2
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = UIColor.white.cgColor
        self.addSubview(profileImageView)
        
        nameLabel = UILabel()
        nameLabel.font = UIFont.teko(size: 25).bold
        nameLabel.textColor = .white
        nameLabel.numberOfLines = 2
        nameLabel.textAlignment = .center
        self.addSubview(nameLabel)
        
        stack = UIStackView()
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.axis = .horizontal
        stack.spacing = 20
        self.addSubview(stack)
        
        followingLabel = UILabel()
        followingLabel.font = UIFont.teko(size: 18).bold
        followingLabel.textColor = .white
        followingLabel.textAlignment = .center
        followingLabel.numberOfLines = 2
        stack.addArrangedSubview(followingLabel)
        
        followersLabel = UILabel()
        followersLabel.font = UIFont.teko(size: 18).bold
        followersLabel.textColor = .white
        followersLabel.textAlignment = .center
        followersLabel.numberOfLines = 2
        stack.addArrangedSubview(followersLabel)
        
        collectionsLabel = UILabel()
        collectionsLabel.font = UIFont.teko(size: 18).bold
        collectionsLabel.textColor = .white
        collectionsLabel.textAlignment = .center
        collectionsLabel.numberOfLines = 2
        stack.addArrangedSubview(collectionsLabel)
        
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(profileImageHeight)
            make.top.left.equalTo(self).offset(20)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.left.equalTo(profileImageView.snp.right).offset(10)
            make.right.equalTo(self).inset(10)
            make.bottom.equalTo(self)
        }
        
        stack.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.left.right.equalTo(self).inset(20)
            make.bottom.equalTo(self)
        }
    }
    
    func setup(_ item: UserResponse) {
        if let profileImage = item.profile_image.small {
            profileImageView.kf.setImage(with: URL(string: profileImage))
        } else {
            profileImageView.image = UIImage(named: "profile-default")
        }
        
        nameLabel.text = item.username
        followingLabel.text = "\(item.following_count ?? 0)\nFollowing"
        followersLabel.text = "\(item.followers_count ?? 0)\nFollowers"
        collectionsLabel.text = "\(item.total_collections)\nCollections"
    }
}
