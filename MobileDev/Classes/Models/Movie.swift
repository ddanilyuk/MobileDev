//
//  Movie.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 11.02.2021.
//

import UIKit

struct Movie {
    
    struct FieldRepresenting {
        var field: String
        var value: String
    }
    
    let title: String
    let year: String
    let imdbID: String
    let type: String
    let poster: String
    
    let rated, released, production: String?
    let runtime, genre, director, writer: String?
    let actors, plot, language, country: String?
    let awards, imdbRating, imdbVotes: String?
    
    var posterImage: UIImage? {
        return poster.isEmpty ? UIImage(systemName: "film") : UIImage(named: poster)
    }
    
    func listPropertiesWithValues(reflect: Mirror? = nil) {
        
        let mirror = reflect ?? Mirror(reflecting: self)
        if mirror.superclassMirror != nil {
            listPropertiesWithValues(reflect: mirror.superclassMirror)
        }
        
        for (index, attr) in mirror.children.enumerated() {
            if let property_name = attr.label {
                //You can represent the results however you want here!!!
                print("\(mirror.description) \(index): \(property_name.capitalized) = \(attr.value)")
            }
        }
    }
    
    func reflex() -> [FieldRepresenting] {
        
        return Mirror(reflecting: self).children.enumerated().reduce(into: [FieldRepresenting]()) {
            $0.append(FieldRepresenting(field: $1.element.label?.capitalizingFirstLetter() ?? "",
                                        value: $1.element.value as? String ?? ""))
        }
    }
}

// MARK: - Codable

extension Movie: Codable {
    
    enum CodingKeys: String, CodingKey {
        
        case title = "Title"
        case year = "Year"
        case rated = "Rated"
        case released = "Released"
        case runtime = "Runtime"
        case genre = "Genre"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
        case plot = "Plot"
        case language = "Language"
        case country = "Country"
        case awards = "Awards"
        case poster = "Poster"
        case imdbRating, imdbVotes, imdbID
        case type = "Type"
        case production = "Production"
    }
}
