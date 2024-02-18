//
//  ProfileView.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 13.10.23.
//

import UIKit
import Foundation
import SnapKit
import RxSwift
import RxCocoa

class ProfileView: ContentView {
    
    var containerScroll: UIScrollView!
    var containerElem: UIView!
    
    var stack: UIStackView!
    var headerSection: ProfileHeaderSection!
    var bioSection: BioSection!
    var nameSection: GenericSection!
    var locationSection: GenericSection!
    var emailSection: GenericSection!
    var instagramSection: GenericSection!
    var twitterSection: GenericSection!
    
    override func setupViews() {
        super.setupViews()
        self.backgroundColor = .black
        
        containerScroll = UIScrollView()
        containerScroll.keyboardDismissMode = .onDrag
        self.addSubview(containerScroll)
        
        containerElem = UIView()
        containerElem.isHidden = true
        containerScroll.addSubview(containerElem)
        
        stack = UIStackView()
        stack.distribution = .fill
        stack.axis = .vertical
        stack.spacing = 10
        containerElem.addSubview(stack)
        
        headerSection = ProfileHeaderSection()
        stack.addArrangedSubview(headerSection)
        
        bioSection = BioSection()
        stack.addArrangedSubview(bioSection)
        
        nameSection = GenericSection()
        stack.addArrangedSubview(nameSection)
        
        locationSection = GenericSection()
        stack.addArrangedSubview(locationSection)
        
        emailSection = GenericSection()
        stack.addArrangedSubview(emailSection)
        
        instagramSection = GenericSection()
        stack.addArrangedSubview(instagramSection)
        
        twitterSection = GenericSection()
        stack.addArrangedSubview(twitterSection)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        containerScroll.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        containerElem.snp.makeConstraints { make in
            make.edges.equalTo(containerScroll)
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        
        stack.snp.makeConstraints { make in
            make.top.equalTo(containerElem)
            make.left.right.bottom.equalTo(containerElem).inset(20)
        }
    }
    
    func setup(_ item: UserResponse) {
        containerElem.isHidden = false
        headerSection.setup(item)
        bioSection.setup(item.bio ?? "Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing industries for previewing layouts and visual mockups.")
        nameSection.setup(UIImage(systemName: "person.fill")!, "Name:", "\(item.first_name ?? "John") \(item.last_name ?? "Doe")")
        emailSection.setup(UIImage(systemName: "envelope.fill")!, "Email:", item.email ?? "johndoe@email.com")
        instagramSection.setup(UIImage(named: "insta")!, "Instagram:", item.instagram_username ?? "john_doe")
        twitterSection.setup(UIImage(named: "twitter")!, "Twitter:", item.twitter_username ?? "john_doe")
        locationSection.setup(UIImage(systemName: "location.fill")!, "Location:", item.location ?? "New York")
    }
}
