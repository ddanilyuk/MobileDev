//
//  PixabayAPIClient.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 10.05.2021.
//

import Foundation
import enum Swift.Result
import FRIDAY
import Alamofire

// MARK: - PixabayAPIClientable

protocol PixabayAPIClientable {
    
    func getImages(page: Int, _ completion: @escaping (_ response: Result<PixabayPagination<PixabayImage>, APIError>) -> Void)
}

// MARK: - PixabayAPIClient

final class PixabayAPIClient {
    
    static var shared: PixabayAPIClientable = PixabayAPIClient()
    
    enum Route: PixabayAPIRequestDataProvider {
        
        case getImages(page: Int)
        
        var method: HTTP.Method {
            
            switch self {
            case .getImages:
                return .get
            }
        }
        
        var path: String {
            
            switch self {
            case .getImages:
                return "/"
            }
        }
        
        var parameters: Parameters? {
            
            switch self {
            case let .getImages(page):
                return [
                    "page": page
                ]
            }
        }
        
        var encoding: ParameterEncoding {
            
            switch self {
            case .getImages:
                return URLEncoding.default
            }
        }
    }
}


// MARK: - PixabayAPIClientable

extension PixabayAPIClient: PixabayAPIClientable {
    
    func getImages(page: Int, _ completion: @escaping (Result<PixabayPagination<PixabayImage>, APIError>) -> Void) {
        
        FRIDAY
            .request(Route.getImages(page: page))
            .responseJSON { (response: Response<PixabayPagination<PixabayImage>, APIError>) in
                completion(response.result)
            }
    }
}
