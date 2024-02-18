//
//  CreateCollectionView.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 6.12.23.
//

import UIKit
import SnapKit

class CreateCollectionView: ContentView {
    
    let titleMaxCharCount = 60
    let descriptionMaxCharCount = 250
    var collectionResponse: CollectionResponse?
    
    var isCreatingNewCollection: Bool  {
        return collectionResponse == nil
    }
    
    var containerView: UIView!
    
    var titleLabel: UILabel!
    var titleTextField: UITextView!
    var titleCharCountLabel: UILabel!
    
    var descriptionLabel: UILabel!
    var descriptionTextView: UITextView!
    var descriptionCharCountLabel: UILabel!
    
    var createButton: UIButton!
    
    override func setupViews() {
        super.setupViews()
        self.backgroundColor = .black
        
        titleLabel = UILabel()
        titleLabel.text = "Title:"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.teko(size: 20).bold
        self.addSubview(titleLabel)
        
        titleTextField = UITextView()
        titleTextField.text = ""
        titleTextField.layer.cornerRadius = 10
        titleTextField.layer.borderWidth = 1
        titleTextField.layer.borderColor = UIColor.white.cgColor
        titleTextField.layer.backgroundColor = UIColor.init(hex: 0x202226).cgColor
        titleTextField.textColor = .white
        titleTextField.font = UIFont.teko(size: 16)
        titleTextField.delegate = self
        titleTextField.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        titleTextField.addDoneButtonOnKeyboard()
//        titleTextField.setLeftPaddingPoints(10)
        self.addSubview(titleTextField)
        
        titleCharCountLabel = UILabel()
        titleCharCountLabel.font = UIFont.teko(size: 15).bold
        titleCharCountLabel.text = "0/\(titleMaxCharCount)"
        titleCharCountLabel.textColor = .white
        self.addSubview(titleCharCountLabel)
        
        descriptionLabel = UILabel()
        descriptionLabel.text = "Description:"
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont.teko(size: 20).bold
        self.addSubview(descriptionLabel)
        
        descriptionTextView = UITextView()
        descriptionTextView.text = ""
        descriptionTextView.font = UIFont.teko(size: 16)
        descriptionTextView.textColor = .white
        descriptionTextView.layer.cornerRadius = 10
        descriptionTextView.layer.backgroundColor = UIColor.init(hex: 0x202226).cgColor
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.white.cgColor
        descriptionTextView.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        descriptionTextView.delegate = self
        descriptionTextView.addDoneButtonOnKeyboard()
        self.addSubview(descriptionTextView)
        
        descriptionCharCountLabel = UILabel()
        descriptionCharCountLabel.font = UIFont.teko(size: 15).bold
        descriptionCharCountLabel.text = "0/\(descriptionMaxCharCount)"
        descriptionCharCountLabel.textColor = .white
        self.addSubview(descriptionCharCountLabel)
        
        createButton = UIButton()
        createButton.setTitle("Create", for: .normal)
        createButton.setTitleColor(.white, for: .normal)
        createButton.titleLabel?.font = UIFont.teko(size: 20).bold
        createButton.layer.cornerRadius = 15
        disableCreateButton()
        self.addSubview(createButton)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.left.right.equalTo(self).inset(20)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalTo(self).inset(20)
            make.height.equalTo(40)
        }
        
        titleCharCountLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(5)
            make.right.equalTo(self).inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleCharCountLabel.snp.bottom).offset(10)
            make.left.right.equalTo(self).inset(20)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.left.right.equalTo(self).inset(20)
            make.height.equalTo(100)
        }
        
        descriptionCharCountLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextView.snp.bottom).offset(5)
            make.right.equalTo(self).inset(20)
        }
        
        createButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionCharCountLabel.snp.bottom).offset(20)
            make.centerX.equalTo(self)
            make.left.right.equalTo(self).inset(20)
            make.height.equalTo(40)
        }
    }
    
    func setup(_ collectionResponse: CollectionResponse?) {
        self.collectionResponse = collectionResponse
        titleTextField.text = collectionResponse == nil ? "" : collectionResponse!.title
        descriptionTextView.text = collectionResponse == nil ? "" : collectionResponse!.description
        createButton.setTitle(collectionResponse == nil ? "Create" : "Update", for: .normal)
    }
    
    private func enableCreateButton() {
        createButton.isEnabled = true
        createButton.backgroundColor = .systemGreen
    }
    
    private func disableCreateButton() {
        createButton.isEnabled = false
        createButton.backgroundColor = .systemGray
    }
    
    private func checkCreateButtonState(_ titleText: String) {
        if !titleText.isEmpty {
            enableCreateButton()
        } else {
            disableCreateButton()
        }
    }
    
    private func checkUpdateButtonState(_ titleText: String, _ descriptionText: String) {
        let titleChanged = !titleText.isEmpty && titleText != collectionResponse!.title
        let descriptionChanged = !descriptionText.isEmpty && descriptionText != collectionResponse!.description
        
        if titleChanged || descriptionChanged {
            enableCreateButton()
        } else {
            disableCreateButton()
        }
    }
    
    private func checkCreateOrUpdateButtonState(_ titleText: String, _ descriptionText: String) {
        if isCreatingNewCollection {
            checkCreateButtonState(titleText)
        } else {
            checkUpdateButtonState(titleText, descriptionText)
        }
    }
}

extension CreateCollectionView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let text = (textView.text as NSString)
            .replacingCharacters(in: range, with: text)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        if textView == titleTextField && text.count <= titleMaxCharCount {
            checkCreateOrUpdateButtonState(text, descriptionTextView.text)
            titleCharCountLabel.text = "\(text.count)/\(titleMaxCharCount)"
            return true
        } else if textView == descriptionTextView && text.count <= descriptionMaxCharCount {
            checkCreateOrUpdateButtonState(titleTextField.text, text)
            descriptionCharCountLabel.text = "\(text.count)/\(descriptionMaxCharCount)"
            return true
        }
        
        return false
    }
}
