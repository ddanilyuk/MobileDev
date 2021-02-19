//
//  CustomNavigationViewController.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 12.02.2021.
//

import UIKit

final class CustomNavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.isTranslucent = true
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        
        let viewController = super.popViewController(animated: animated)
        
        if let coordinator = transitionCoordinator, animated {
                        
            navigationBar.setBackgroundImage(nil, for: .default)
            navigationBar.shadowImage = nil
            navigationBar.tintColor = .accent
            
            coordinator.animate(alongsideTransition: nil) { [weak self] context in
                
                if context.isCancelled {
                    
                    self?.navigationBar.setBackgroundImage(UIImage(), for: .default)
                    self?.navigationBar.shadowImage = UIImage()
                    self?.navigationBar.tintColor = .white
                }
            }
        } else {
            
            navigationBar.setBackgroundImage(nil, for: .default)
            navigationBar.shadowImage = nil
            navigationBar.tintColor = .accent
        }
        
        return viewController
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        
        if viewController is MovieDetailViewController {
            
            let backButton = UIBarButtonItem()
            backButton.title = ""
            
            navigationBar.topItem?.backBarButtonItem = backButton
            navigationBar.tintColor = .white
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
        }
    }
}
