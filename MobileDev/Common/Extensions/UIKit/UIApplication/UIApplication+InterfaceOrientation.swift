//
//  UIApplication+InterfaceOrientation.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 12.03.2021.
//

import UIKit

extension UIApplication {
    
    static var interfaceOrientation: UIInterfaceOrientation {
        guard let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation else {
            return .portrait
        }
        return orientation
    }
}
