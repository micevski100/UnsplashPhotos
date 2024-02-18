//
//  CircleButton.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 30.11.23.
//

import UIKit

final class CircleImageButton: UIButton {
    
    init(image: UIImage, backgroundColor: UIColor, tintColor: UIColor = .white) {
        super.init(frame: .zero)
        self.setImage(image, for: .normal)
        self.backgroundColor = backgroundColor
        self.snp.makeConstraints { make in
            make.width.height.equalTo(70)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }

    func setup() {
        let size = self.frame.size.height
        self.clipsToBounds = true
        self.contentVerticalAlignment = .fill
        self.contentHorizontalAlignment = .fill
        self.imageView?.contentMode = .scaleAspectFit
        self.imageView?.tintColor = .white
        self.imageEdgeInsets = .init(top: 15 , left: 15, bottom: 15, right: 15)
        self.layer.cornerRadius = size / 2.0
    }
}
