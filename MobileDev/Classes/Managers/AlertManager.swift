//
//  AlertManager.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 04.05.2021.
//

import UIKit

final class AlertManager: NSObject {

    static var topViewController: UIViewController? {
        return UIApplication.topViewController()
    }
    

    static func showSettingsAlert(_ error: NSError? = nil) {
        
        let alert = UIAlertController(title: "Persmission required",
                                      message: "Please go to settings and enable access to your camera",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            
            let settingsUrl = URL(string: UIApplication.openSettingsURLString)
            if let url = settingsUrl {
                UIApplication.shared.open(url, options: [:]) { _ in }
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        topViewController?.present(alert, animated: true, completion: nil)
    }
    

    static func showAlert(withTitle title: String? = nil, message: String? = nil, actions: [UIAlertAction]? = nil, style: UIAlertController.Style = .alert) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        if actions != nil {
            for action in actions! {
                alert.addAction(action)
            }
        } else {
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        }
        topViewController?.present(alert, animated: true, completion: nil)
    }

}

