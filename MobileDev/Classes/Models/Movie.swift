//
//  Movie.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 11.02.2021.
//

import UIKit

struct Movie {
    
    let title: String
    let year: String
    let imdbID: String
    let type: String
    let poster: String
    
    var posterImage: UIImage? {
        
        return poster.isEmpty
            ? UIImage.filmPlaceholder
            : UIImage(named: poster)
    }
}

// MARK: - Codable

extension Movie: Codable {
    
    enum CodingKeys: String, CodingKey {
        
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
}
