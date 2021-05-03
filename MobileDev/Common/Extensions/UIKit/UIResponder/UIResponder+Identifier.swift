//
//  UIResponder+Identifier.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 12.02.2021.
//

import UIKit

extension UIResponder {
    
    class var identifier: String {
        
        return String(describing: self)
    }
}
