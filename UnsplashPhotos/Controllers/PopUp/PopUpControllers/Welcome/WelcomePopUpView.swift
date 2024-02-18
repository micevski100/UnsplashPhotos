//
//  WelcomePopUpView.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 15.2.24.
//

import UIKit
import RxSwift
import RxCocoa

class WelcomePopUpView: PopUpBaseView {
    
    var descriptionLabel: UILabel!
    var proceedButton: RoundedTitleButton!
    
    override func setupViews() {
        super.setupViews()
        
        self.titleLabel.text = "Welcome to UnsplashPhotos!"
        
        descriptionLabel = UILabel()
        descriptionLabel.text = """
        Welcome to UnsplashPhotos, your ultimate destination for stunning wallpapers to personalize your device! Whether you're seeking a serene landscape, a captivating abstract design, or a vibrant burst of color, we've got you covered. With our vast collection of high-quality wallpapers, you can effortlessly transform your screen into a work of art that reflects your unique style and personality.

        Join our community of wallpaper enthusiasts and elevate your device's aesthetics to new heights. Download [App Name] today and let your imagination run wild with endless possibilities for customization. Welcome to a world of inspiration, creativity, and endless beauty right at your fingertips.
        """
        descriptionLabel.font = UIFont.teko(size: 16)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        self.contentContainer.addSubview(descriptionLabel)
        
        proceedButton = RoundedTitleButton(title: "Start Scrolling!", backgroundColor: .systemGreen)
        self.contentContainer.addSubview(proceedButton)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleDivider.snp.bottom).offset(30)
            make.left.right.equalTo(self.contentContainer).inset(20)
            make.bottom.equalTo(proceedButton.snp.top).offset(-30)
        }
        
        proceedButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.contentContainer).inset(30)
            make.centerX.equalTo(self.contentContainer)
        }
    }
}
