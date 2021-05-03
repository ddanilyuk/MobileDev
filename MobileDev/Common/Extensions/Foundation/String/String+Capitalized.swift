//
//  String+Capitalized.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 19.02.2021.
//

import Foundation

extension String {
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
