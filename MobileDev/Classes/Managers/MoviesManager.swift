//
//  MoviesManager.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 11.02.2021.
//

import Foundation

final class MoviesManager {
    
    static var shared = MoviesManager()
    
    private init () { }
    
    func fetchMovies(from file: String) -> [Movie] {
        
        do {
            if let path = Bundle.main.path(forResource: file, ofType: "txt"),
               let jsonData = try String(contentsOfFile: path, encoding: String.Encoding.utf8).data(using: .utf8) {
                
                let decodedData = try JSONDecoder().decode(Pagination<Movie>.self, from: jsonData)
                return decodedData.items
            }
        } catch {
            print("Error:", error.localizedDescription)
        }
        
        return []
    }
}
