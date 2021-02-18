//
//  UIView+FromNib.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 12.02.2021.
//

import UIKit

extension UIView {
    
    @discardableResult
    func fromNib<T: UIView>() -> T? {
        
        guard let contentView = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)),
                                                                         owner: self,
                                                                         options: nil)?.first as? T else {
            // xib not loaded, or its top self is of the wrong type
            return nil
        }
        backgroundColor = .clear
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            contentView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            contentView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0)
        ])
        
        return contentView
    }
}
