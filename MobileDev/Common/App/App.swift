//
//  App.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 09.05.2021.
//

import Foundation
import IQKeyboardManagerSwift
import FRIDAY
import SDWebImage

struct App {
    
    static let OMDBAPI: API = {
        
        guard let value = Bundle.main.object(forInfoDictionaryKey: "ServerEnvironmentOMDB") as? String else {
            return .developmentOMDB
        }
        return API(rawValue: value) ?? .developmentOMDB
    }()
    
    static let pixabayAPI: API = {
        
        guard let value = Bundle.main.object(forInfoDictionaryKey: "ServerEnvironmentOMDB") as? String else {
            return .developmentPixabay
        }
        return API(rawValue: value) ?? .developmentPixabay
    }()

    
    static func setup() {
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        API.setup()
        
        FRIDAY.isLoggingEnabled = true
        
//        App.userSession.onActivation = {
//            if let token = App.userSession.accessToken {
//                SDWebImageDownloader.shared.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//            }
//        }
//
//        App.userSession.onDeactivation = {
//            SDWebImageDownloader.shared.setValue("", forHTTPHeaderField: "Authorization")
//        }
//
//        if let token = App.userSession.accessToken {
//            SDWebImageDownloader.shared.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        }
    }
}


func IMPLEMENT_ME(TODO: String? = nil, file: String = #file, line: Int = #line) {
    print("\n⚠️⚠️⚠️ IMPLEMENT ME \(TODO ?? "")\n\(file) \(line)\n")
}
