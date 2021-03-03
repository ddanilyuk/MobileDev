//
//  MoviesManager.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 11.02.2021.
//

import Foundation

final class MoviesManager {
    
    static var shared = MoviesManager()
    static var movieList = "MoviesList"
    
    private init () { }
    
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
}
