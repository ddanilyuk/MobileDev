//
//  CGFloat+Random.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 04.05.2021.
//

import UIKit

extension CGFloat {
    
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
