//
//  ShadowRoundedImageView.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 26.02.2021.
//

import UIKit

final class ShadowRoundedImageView: UIImageView {
    
    lazy var shadowView: UIView = {
        let view = UIView(frame: frame)
        
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = .zero
        view.layer.shadowOpacity = 0.1
        view.layer.shadowColor = UIColor.accent.cgColor
        
        view.layer.cornerRadius = layer.cornerRadius
        view.layer.shadowPath = shadowPath
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        return view
    }()
    
    var shadowPath: CGPath {
        return UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 20
        layer.masksToBounds = true
        shadowView.layer.cornerRadius = 20
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        addShadowView()
    }
    
    func addShadowView() {
        
        if let superView = superview {
            
            superView.insertSubview(shadowView, belowSubview: self)
            
            NSLayoutConstraint.activate([
                shadowView.centerYAnchor.constraint(equalTo: centerYAnchor),
                shadowView.centerXAnchor.constraint(equalTo: centerXAnchor),
                shadowView.widthAnchor.constraint(equalTo: widthAnchor),
                shadowView.heightAnchor.constraint(equalTo: heightAnchor)
            ])
        }
    }
}
