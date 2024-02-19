//
//  AddPhotoPopUpView.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 15.2.24.
//

import UIKit

class AddPhotoPopUpView: PopUpBaseView {
    
    var descriptionLabel: UILabel!
    var tableView: UITableView!
    
    var buttonsStack: UIStackView!
    var cancelButton: RoundedTitleButton!
    var proceedButton: RoundedTitleButton!
    
    override func setupViews() {
        super.setupViews()
        
        descriptionLabel = UILabel()
        descriptionLabel.textColor = .black
        descriptionLabel.numberOfLines = 2
        descriptionLabel.font = UIFont.teko(size: 13)
        self.contentContainer.addSubview(descriptionLabel)
        
        tableView = UITableView()
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        self.contentContainer.addSubview(tableView)
        
        cancelButton = RoundedTitleButton(title: "Cancel", backgroundColor: UIColor.init(hex: 0xADB6C2), width: 90)

        proceedButton = RoundedTitleButton(title: "Add", backgroundColor: .systemGreen, width: 90)
        disableProceedButton()
        
        buttonsStack = UIStackView(arrangedSubviews: [cancelButton, proceedButton])
        buttonsStack.axis = .horizontal
        buttonsStack.spacing = 10
        self.contentContainer.addSubview(buttonsStack)
        
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(30)
            make.left.right.equalTo(self.contentContainer).inset(25)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.left.right.equalTo(self.contentContainer).inset(20)
            make.bottom.equalTo(self.buttonsStack.snp.top).offset(-20)
            make.height.equalTo(200)
        }
        
        buttonsStack.snp.makeConstraints { make in
            make.bottom.equalTo(self.contentContainer).inset(30)
            make.centerX.equalTo(self.contentContainer)
        }
    }
    
    func disableProceedButton() {
        proceedButton.isEnabled = false
        proceedButton.backgroundColor = UIColor.init(hex: 0xADB6C2)
    }
    
    func enableProceedButton() {
        proceedButton.isEnabled = true
        proceedButton.backgroundColor = .systemGreen
    }
    
    func setup(_ title: String, _ description: String) {
        self.titleLabel.text = title
        self.descriptionLabel.text = description
    }
}
