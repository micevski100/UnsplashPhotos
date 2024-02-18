//
//  PhotoDetailsView.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 6.12.23.
//

import UIKit
import Kingfisher

class PhotoDetailsView: ContentView {
    
    var imageView: UIImageView!
    var downloadButton: CircleImageButton!
    var addButton: CircleImageButton!
    
    override func setupViews() {
        super.setupViews()
        
        imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        self.addSubview(imageView)
        
//        downloadButton = UIButton()
//        downloadButton.setImage(UIImage(systemName: "arrow.down.square.fill"), for: .normal)
//        downloadButton.tintColor = .white
//        downloadButton.backgroundColor = UIColor.init(hex: 0x202226)
//        downloadButton.layer.cornerRadius = 35
        downloadButton = CircleImageButton(image: UIImage(systemName: "arrow.down.square.fill")!, backgroundColor: UIColor.init(hex: 0x202226), tintColor: .white)
        self.addSubview(downloadButton)
        
        addButton = CircleImageButton(image: UIImage(systemName: "plus")!, backgroundColor: UIColor.init(hex: 0x202226), tintColor: .white)
        self.addSubview(addButton)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.width.height.equalTo(70)
            make.right.bottom.equalTo(self.safeAreaLayoutGuide).inset(10)
        }
        
        addButton.snp.makeConstraints { make in
            make.width.height.equalTo(70)
            make.right.equalTo(downloadButton.snp.left).offset(-10)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(10)
        }
    }
    
    func setup(_ imageURL: String) {
        imageView.kf.setImage(with: URL(string: imageURL)!)
    }
}
