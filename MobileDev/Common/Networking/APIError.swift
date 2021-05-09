//
//  APIError.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 09.05.2021.
//

import Foundation
import FRIDAY

enum APIError: ResponseError {
    
    enum CustomError: String {
        
        case `default` = "Unexpected error"
        
        var message: String {
            switch self {
            case .default:
                return "Unexpected error"
            }
        }
    }
    
    case parsingFailed
    case noInternetConnection
    case networkError(HTTP.StatusCode, message: String?)
    case customError(CustomError)
    case failure(message: String?)
    
    var statusCode: HTTP.StatusCode? {
        
        switch self {
        case .networkError(let statusCode, _):
            return statusCode
        default:
            return nil
        }
    }
    
    var message: String? {
        
        switch self {
        case .parsingFailed:
            return "Parsing failed"
        case .noInternetConnection:
            return "No internet"
        case .failure(let message):
            return message
        case .customError(let customError):
            return customError.message
        case .networkError(let statusCode, let message):
            
            if let message = message {
                return message
            } else {
                switch statusCode {
                case .notFound:
                    return "Not found"
                case .internalServerError:
                    return "Something went wrong"
                default:
                    return "Something went wrong"
                }
            }
        }
    }
    
    init(response: HTTPURLResponse?, data: Data?, error: Error?) {
        
        if let error = error as NSError?, error.domain == NSURLErrorDomain && error.code == NSURLErrorNotConnectedToInternet {
            self = .noInternetConnection
            return
        }
        
        guard let httpResponse = response, let statusCode = HTTP.StatusCode(rawValue: httpResponse.statusCode) else {
            self = .parsingFailed
            return
        }
        
        self = APIError.errorMessage(for: response, data: data, error: error, statusCode: statusCode)
    }
    
    init(message: String) {
        
        self = .networkError(.multiStatus, message: message)
    }
    
    static func errorMessage(for response: HTTPURLResponse?, data: Data?, error: Error?, statusCode: HTTP.StatusCode) -> APIError {
        
        
        guard let json = data,
              let dictonary = try? JSONSerialization.jsonObject(with: json, options: []) as? [String: Any] else {
            
            return .parsingFailed
        }
        
        let message = (dictonary["violations"] as? [[String: Any]])?.first?["message"] as? String
        let code = (dictonary["violations"] as? [[String: Any]])?.first?["code"] as? String ?? ""
        
        if let customError = CustomError(rawValue: code) {
            
            return .customError(customError)
        } else {
            
            return .networkError(statusCode, message: message)
        }
    }
}

// MARK: - Equatable

extension APIError: Equatable {
    
}
