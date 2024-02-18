//
//  RoundedTitleButton.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 15.2.24.
//

import UIKit

final class RoundedTitleButton: UIButton {
    
    init(title: String, backgroundColor: UIColor, foreGroundColor: UIColor = .white, width: CGFloat? = nil) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont.teko(size: 17).bold
        self.setTitleColor(foreGroundColor, for: .normal)
        self.layer.cornerRadius = 10
        self.backgroundColor = backgroundColor
        self.snp.makeConstraints { make in
            make.width.equalTo(width ?? self.calculateWidth() + 20)
            make.height.equalTo(40)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func calculateWidth() -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [.font: self.titleLabel!.font!]
        let attributedString = NSAttributedString(string: self.titleLabel?.text ?? "", attributes: attributes)
        
        let size = attributedString.size()
        return size.width
    }
}
