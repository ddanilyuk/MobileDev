//
//  UITableView+Placeholder.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 28.03.2021.
//

import UIKit

extension UITableView {
    
    func addPlaceholder(image: UIImage = .filmPlaceholder) {
        
        let image = UIImageView(image: image)
        image.contentMode = .scaleAspectFit
        backgroundView = image
    }
    
    func removePlaceholder() {
        
        backgroundView = nil
    }
}
