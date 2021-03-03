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
    
    enum Section: String, Comparable, CaseIterable {
        
        case information = "Information"
        case peoples = "Peoples"
        case ratings = "Ratings"
        case other = "Other"
        
        var order: Int {
            return Section.allCases.firstIndex(of: self) ?? 0
        }
        
        static func < (lhs: Movie.Section, rhs: Movie.Section) -> Bool {
            return lhs.order < rhs.order
        }
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
        return poster.isEmpty
            ? UIImage.filmPlaceholder
            : UIImage(named: poster)
    }
    
    func getSections() -> [(section: Section, values: [FieldRepresenting])] {
        
        let dict = Mirror(reflecting: self).children.enumerated().reduce(into: [Section: [FieldRepresenting]]()) { result, sequence in
            
            guard (sequence.element.label?.capitalizingFirstLetter() ?? "") != CodingKeys.title.stringValue.capitalizingFirstLetter() else {
                return
            }
            
            var section: Section = .other
            
            switch sequence.element.label?.capitalizingFirstLetter() {
            
            case CodingKeys.year.string,
                 CodingKeys.type.string,
                 CodingKeys.released.string,
                 CodingKeys.production.string:
                
                section = .information
            case CodingKeys.director.string,
                 CodingKeys.writer.string,
                 CodingKeys.actors.string:
                
                section = .peoples
            case CodingKeys.rated.string,
                 CodingKeys.imdbRating.string,
                 CodingKeys.imdbVotes.string,
                 CodingKeys.awards.string:
                
                section = .ratings
            default:
                section = .other
            }
            
            var array = result[section] ?? []
            let newElement = FieldRepresenting(field: "\(sequence.element.label?.capitalizingFirstLetter() ?? "")",
                                               value: "\(sequence.element.value as? String ?? "")")
            array.append(newElement)
            result[section] = array
        }
        
        return dict.map { (section: $0, values: $1) }.sorted { $0.section < $1.section }
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
        case imdbRating = "imdbRating"
        case imdbVotes = "imdbVotes"
        case imdbID = "imdbID"
        case type = "Type"
        case production = "Production"
        
        var string: String {
            return "\(self.stringValue.capitalizingFirstLetter())"
        }
    }
}
