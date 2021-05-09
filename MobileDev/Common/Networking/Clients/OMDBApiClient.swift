//
//  OMDBApiClient.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 09.05.2021.
//

import Foundation
import enum Swift.Result
import FRIDAY
import Alamofire

// MARK: - OMDBAPIClientable

protocol OMDBAPIClientable {
    
    func getMovies(with title: String, page: Int, _ completion: @escaping (_ response: Result<Pagination<Movie>, APIError>) -> Void)
    func getMovieDetails(with id: String, _ completion: @escaping (_ response: Result<Movie, APIError>) -> Void)
}

// MARK: - OMDBAPIClient

final class OMDBAPIClient {
    
    static var shared: OMDBAPIClient = OMDBAPIClient()
    
    enum Route: OMDBAPIRequestDataProvider {
        
        case getMovies(title: String, page: Int)
        case getMovieDetails(id: String)
        
        var method: HTTP.Method {
            
            switch self {
            case .getMovies, .getMovieDetails:
                return .get
            }
        }
        
        var path: String {
            
            switch self {
            case .getMovies, .getMovieDetails:
                return "/"
            }
        }
        
        var parameters: Parameters? {
            
            switch self {
            case let .getMovies(title, page):
                return [
                    "s": title,
                    "page": page
                ]
            case let .getMovieDetails(id):
                return ["i": id]
            }
        }
        
        var encoding: ParameterEncoding {
            
            switch self {
            case .getMovies, .getMovieDetails:
                return URLEncoding.default
            }
        }
    }
}


// MARK: - OMDBAPIClientable

extension OMDBAPIClient: OMDBAPIClientable {
    
    func getMovies(with title: String, page: Int, _ completion: @escaping (Result<Pagination<Movie>, APIError>) -> Void) {
        
        FRIDAY
            .request(Route.getMovies(title: title, page: page))
            .responseJSON { (response: Response<Pagination<Movie>, APIError>) in
                completion(response.result)
            }
    }
    
    func getMovieDetails(with id: String, _ completion: @escaping (Result<Movie, APIError>) -> Void) {
        
        FRIDAY
            .request(Route.getMovieDetails(id: id))
            .responseJSON { (response: Response<Movie, APIError>) in
                completion(response.result)
            }
    }
}
