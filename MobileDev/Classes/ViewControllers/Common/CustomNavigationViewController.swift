//
//  CustomNavigationViewController.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 12.02.2021.
//

import UIKit

final class CustomNavigationViewController: UINavigationController, UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactivePopGestureRecognizer?.delegate = self
        navigationBar.isTranslucent = true
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        
        let viewController = super.popViewController(animated: animated)
        
        if let coordinator = transitionCoordinator, animated {
            
            navigationBar.setBackgroundImage(nil, for: .default)
            navigationBar.shadowImage = nil
            navigationBar.tintColor = .accent
            navigationBar.isUserInteractionEnabled = true
            navigationBar.isHidden = false
            
            coordinator.animate(alongsideTransition: nil) { [weak self] context in
                
                if context.isCancelled {
                    
                    self?.navigationBar.setBackgroundImage(UIImage(), for: .default)
                    self?.navigationBar.shadowImage = UIImage()
                    self?.navigationBar.tintColor = .white
                    self?.navigationBar.isUserInteractionEnabled = false
                    self?.navigationBar.isHidden = true
                    
                }
            }
        } else {
            
            navigationBar.setBackgroundImage(nil, for: .default)
            navigationBar.shadowImage = nil
            navigationBar.tintColor = .accent
            navigationBar.isUserInteractionEnabled = true
            navigationBar.isHidden = false
            
        }
        
        return viewController
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        
        if viewController is MovieDetailViewController {
            
            navigationBar.tintColor = .white
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.isUserInteractionEnabled = false
        }
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return viewControllers.count > 1
    }
}
