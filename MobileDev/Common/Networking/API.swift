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
            return URL(string: "https://pixabay.com/")!
        case .productionOMDB:
            return URL(string: "http://www.omdbapi.com/")!
        case .productionPixabay:
            return URL(string: "https://pixabay.com/")!
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
        
        var url = self.baseURL
        url.appendPathComponent(self.apiPath)
        return url
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
        
        return nil
    }
    
    var adapter: ((URLRequest) -> URLRequest)? {
        return { request in
            var urlRequest = request
            urlRequest.allHTTPHeaderFields = self.headers
            
            let apiKeyItem = URLQueryItem(name: "apikey",
                                          value: Constants.API.omdbAPIKey)
            
            
            var components = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: true)
            components?.queryItems?.append(apiKeyItem)
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
        
        return nil
    }
    
    var adapter: ((URLRequest) -> URLRequest)? {
        return { request in
            var urlRequest = request
            urlRequest.allHTTPHeaderFields = self.headers
            
            let apiKeyItem = URLQueryItem(name: "key",
                                          value: Constants.API.pixabayAPIKey)
            let perPageItem = URLQueryItem(name: "per_page",
                                           value: String(Constants.API.perPagePixabay))
            let requestTypeItem = URLQueryItem(name: "q",
                                               value: Constants.API.pixabayRequest)
            
            var components = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: true)
            components?.queryItems?.append(apiKeyItem)
            components?.queryItems?.append(perPageItem)
            components?.queryItems?.append(requestTypeItem)
            urlRequest.url = components?.url
            return urlRequest
        }
    }
}

protocol APIParametersConvertible {
    func toParameters() -> Parameters
}
