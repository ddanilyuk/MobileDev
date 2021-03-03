//
//  UIView+IBInspectable.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 26.02.2021.
//

import UIKit

extension UIView {
    
    @IBInspectable var layerCornerRadius: CGFloat {
        
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable var borderColor: UIColor? {
        
        get { return layer.borderColor != nil ? UIColor(cgColor: layer.borderColor!) : nil }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        
        get { return layer.shadowRadius }
        set {
            layer.masksToBounds = false
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        
        get { return layer.shadowOpacity }
        set {
            layer.masksToBounds = false
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        
        get { return layer.shadowColor != nil ? UIColor(cgColor: layer.shadowColor!) : nil }
        set {
            layer.masksToBounds = false
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        
        get { return layer.shadowOffset }
        set {
            layer.masksToBounds = false
            layer.shadowOffset = newValue
        }
    }
}
