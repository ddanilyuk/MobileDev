//
//  UIImage+Ext.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 03.03.2021.
//

import UIKit

extension UIImage {
    
    static var filmPlaceholder: UIImage {
        return UIImage(named: "filmPlaceholder")!
    }
    
    static var imagePlaceholder: UIImage {
        return UIImage(systemName: "leaf")!
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(.systemYellow)
    }

    
    static var trash: UIImage {
        return UIImage(systemName: "trash")!
    }
}
