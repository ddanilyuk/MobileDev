//
//  MoviesManager.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 11.02.2021.
//

import Foundation
import Alamofire

final class MoviesManager {
    
    static var shared = MoviesManager()
    static var movieList = "MoviesList"
    static let moviesListName = "MoviesList"
    
    private init () { }
    
    private let omdbIDApiClient: OMDBAPIClientable = OMDBAPIClient.shared
    
    // MARK: - Public methods
    
    func fetchMovies(from file: String = MoviesManager.movieList) -> [Movie] {
        
        do {
            if let path = Bundle.main.path(forResource: file, ofType: "txt"),
               let jsonData = try String(contentsOfFile: path, encoding: String.Encoding.utf8).data(using: .utf8) {
                
                let decodedData = try JSONDecoder().decode(Pagination<Movie>.self, from: jsonData)
                return decodedData.items
            }
        } catch {
            print("Error: ", error.localizedDescription)
        }
        
        return []
    }
    
    func getMovies(title: String, page: Int, completion: ((Result<Pagination<Movie>, APIError>) -> Void)?) {

        omdbIDApiClient.getMovies(with: title, page: page) { result in
            
            // TODO: Save to DB if needed
            completion?(result)
        }
    }
    
    func getMovieDetail(with id: String, completion: ((Result<Movie, APIError>) -> Void)?) {
        
        omdbIDApiClient.getMovieDetails(with: id) { result in
            
            // TODO: Save to DB if needed
            completion?(result)
        }
    }

    func getMovie(with id: String) -> Movie? {
        
        guard !id.isEmpty else {
            return nil
        }
        
        do {
            if let path = Bundle.main.path(forResource: id, ofType: "txt"),
               let jsonData = try String(contentsOfFile: path, encoding: String.Encoding.utf8).data(using: .utf8) {
                
                let decodedData = try JSONDecoder().decode(Movie.self, from: jsonData)
                return decodedData
            }
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }
}
