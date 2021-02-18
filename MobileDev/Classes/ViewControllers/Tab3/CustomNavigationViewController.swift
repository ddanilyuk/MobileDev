//
//  CustomNavigationViewController.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 12.02.2021.
//

import UIKit

final class CustomNavigationViewController: UINavigationController {
    
    //    var backgroundImage: UIImage?
    //    var shadowImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        view.backgroundColor = .white
        //        navigationBar.clipsToBounds = false
        //        hide
        navigationBar.isTranslucent = true
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        
        let viewController = super.popViewController(animated: animated)
        
        if let coordinator = transitionCoordinator, animated {
            
            print("add")
            
            navigationBar.setBackgroundImage(nil, for: .default)
            navigationBar.shadowImage = nil
            navigationBar.tintColor = .accent
            //            navigationBar.updateConstraints()
            //            navigationBar.layoutIfNeeded()
            
            coordinator.animate(alongsideTransition: nil) { [weak self] context in
                
                
                if context.isCancelled {
                    
                    print("isCancelled")
                    self?.navigationBar.setBackgroundImage(UIImage(), for: .default)
                    self?.navigationBar.shadowImage = UIImage()
                    self?.navigationBar.tintColor = .white
                    
                    self?.navigationBar.layoutIfNeeded()
                }
            }
        } else {
            
            navigationBar.setBackgroundImage(nil, for: .default)
            navigationBar.shadowImage = nil
            navigationBar.layoutIfNeeded()
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
            navigationBar.layoutIfNeeded()
        }
        
    }
}


extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
    }
}
