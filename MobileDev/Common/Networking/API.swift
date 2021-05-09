//
//  API.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 09.05.2021.
//

import Foundation
import FRIDAY
import Alamofire

enum API: String {
    
    case developmentOMDB
    case developmentPixabay
    case productionOMDB
    case productionPixabay
    
    var baseURL: URL {
        
        switch self {
        case .developmentOMDB:
            return URL(string: "http://www.omdbapi.com/")!
        case .developmentPixabay:
            return URL(string: "http://www.omdbapi.com/")!
        case .productionOMDB:
            return URL(string: "http://www.omdbapi.com/")!
        case .productionPixabay:
            return URL(string: "https://")!
        }
    }
    
    var apiVersion: String {
        switch self {
        case .developmentOMDB:
            return ""
        case .developmentPixabay:
            return ""
        case .productionOMDB:
            return ""
        case .productionPixabay:
            return ""
        }
    }
    
    var apiPath: String {
        switch self {
        case .developmentOMDB:
            return ""
        case .developmentPixabay:
            return "/api"
        case .productionOMDB:
            return ""
        case .productionPixabay:
            return "/api"
        }
    }
    
    var apiURL: URL {
        return baseURL
    }
    
    var clientID: String {
        switch self {
        case .developmentOMDB:
            return "0bef2c1f-2d28-4efd-9211-00241ed958cb"
        case .developmentPixabay:
            return ""
        case .productionOMDB:
            return ""
        case .productionPixabay:
            return "/api"
        }
    }
    
    var clientSecret: String {
        switch self {
        case .developmentOMDB:
            return "jLpOJ7S59U30MR9lPmAZmTktV4HGOcbXVYu7kVfYDKqpvN3S"
        case .developmentPixabay:
            return ""
        case .productionOMDB:
            return ""
        case .productionPixabay:
            return "/api"
        }
    }
    
    static var defaultTimeoutInterval: TimeInterval {
        return 20.0
    }
    
    func url(withPath path: String?) -> URL? {
        
        guard let path = path, !path.isEmpty else {
            return nil
        }
        
        return URL(string: path, relativeTo: baseURL)
    }
    
    static func setup() {
        
        let URLCache = Foundation.URLCache(memoryCapacity: 20 * 1024 * 1024, diskCapacity: 50 * 1024 * 1024, diskPath: nil)
        Foundation.URLCache.shared = URLCache
        
        let configuration = URLSessionConfiguration.default
        configuration.networkServiceType = .default
        configuration.allowsCellularAccess = true
        configuration.httpShouldUsePipelining = true
        configuration.requestCachePolicy = .useProtocolCachePolicy
        configuration.timeoutIntervalForRequest = defaultTimeoutInterval
        
        let serverTrustManager = ServerTrustManager(allHostsMustBeEvaluated: false,
                                                    evaluators: [App.OMDBAPI.baseURL.host!: DefaultTrustEvaluator()])
        
        let manager = Session(configuration: configuration,
                              serverTrustManager: serverTrustManager)
        
        Client.shared = Client(session: manager)
    }
}

protocol OMDBAPIRequestDataProvider: RequestDataProvider {}

extension OMDBAPIRequestDataProvider {
    
    var baseUrl: FRIDAY.URLConvertible {
        
        return App.OMDBAPI.apiURL
    }
    
    var headers: HTTP.Headers? {
        
        return [:]
    }
    
    var adapter: ((URLRequest) -> URLRequest)? {
        return { request in
            var urlRequest = request
            urlRequest.allHTTPHeaderFields = self.headers
            
            let apiKey = URLQueryItem(name: "apikey",
                                      value: Constants.API.omdbIDKey)
            var components = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: true)
            components?.queryItems?.append(apiKey)
            urlRequest.url = components?.url
            return urlRequest
        }
    }
}

protocol PixabayAPIRequestDataProvider: RequestDataProvider {}

extension PixabayAPIRequestDataProvider {
    
    var baseUrl: FRIDAY.URLConvertible {
        
        return App.pixabayAPI.apiURL
    }
    
    var headers: HTTP.Headers? {
        
        //        if let token = App.userSession.accessToken {
        //
        //            return ["Authorization": "Bearer \(token)"]
        //        }
        return [:]
    }
    
    var adapter: ((URLRequest) -> URLRequest)? {
        return { request in
            var urlRequest = request
            urlRequest.allHTTPHeaderFields = self.headers
            return urlRequest
        }
    }
}

protocol APIParametersConvertible {
    func toParameters() -> Parameters
}
