//
//  ToastExtensions.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 6.12.23.
//

import Foundation
import Toaster

extension Toast {
    class func Success(text: String) -> Toast {
        let toast = Toast.BSFactory(text: text)
        toast.view.backgroundColor = UIColor.init(hex: 0x07D98C)
        toast.view.textColor = UIColor.init(hex: 0x323640)
        return toast
    }
    
    class func Info(text: String) -> Toast {
        let toast = Toast.BSFactory(text: text)
        toast.view.backgroundColor = UIColor.init(hex: 0x323640)
        toast.view.textColor = UIColor.white
        return toast
    }
    
    class func Error(text: String) -> Toast {
        let toast = Toast.BSFactory(text: text)
        toast.view.backgroundColor = UIColor.init(hex: 0xFF736A)
        toast.view.textColor = UIColor.white
        return toast
    }
    
    private class func BSFactory(text: String) -> Toast {
        let toast = Toast(text: text, duration: Delay.long)
        toast.view.layer.cornerRadius = 10
        toast.view.font = UIFont.montserrat(size: 12).bold
        toast.view.textInsets.top = 15
        toast.view.textInsets.bottom = 15
        toast.view.bottomOffsetPortrait = 60
        toast.view.maxWidthRatio = 1
        toast.view.layer.shadowRadius = 3
        toast.view.layer.shadowOffset = .init(width: 1, height: 2)
        toast.view.layer.shadowOpacity = 1
        toast.view.layer.shadowColor = UIColor.init(hex:0xADB6C2).withAlphaComponent(0.5).cgColor
        toast.view.useSafeAreaForBottomOffset = true
        return toast
    }
}

