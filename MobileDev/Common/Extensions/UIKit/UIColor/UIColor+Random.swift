//
//  UIColor+Random.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 04.05.2021.
//

import UIKit

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
            red:   .random(),
            green: .random(),
            blue:  .random(),
            alpha: 1.0
        )
    }
}
