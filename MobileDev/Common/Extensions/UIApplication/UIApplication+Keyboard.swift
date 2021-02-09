//
//  UIApplication+Keyboard.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 09.02.2021.
//

import UIKit

extension UIApplication {
    
    static func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
