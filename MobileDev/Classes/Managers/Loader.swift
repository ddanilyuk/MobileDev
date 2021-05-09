//
//  Loader.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 09.05.2021.
//

import UIKit
import SVProgressHUD

struct Loader {
    
    static func show() {
        DispatchQueue.main.async {
            SVProgressHUD.show()
        }
    }
    
    static func hide() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
    
    static func show(with progress: Float) {
        DispatchQueue.main.async {
            SVProgressHUD.showProgress(progress)
        }
    }
    
    static func configureAppearance() {
        
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setBackgroundColor(.accent)
        SVProgressHUD.setForegroundColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        SVProgressHUD.setRingThickness(4.0)
    }
}
