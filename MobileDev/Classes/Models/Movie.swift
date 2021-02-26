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
        
        static func < (lhs: Movie.Section, rhs: Movie.Section) -> Bool {
            return lhs.order < rhs.order
        }
        
        case information = "Information"
        case peoples = "Peoples"
        case ratings = "Ratings"
        case other = "Other"
        
        var order: Int {
            return Section.allCases.firstIndex(of: self) ?? 0
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
        return poster.isEmpty ? UIImage(systemName: "film") : UIImage(named: poster)
    }
    
    func reflex() -> [FieldRepresenting] {
        
        return Mirror(reflecting: self).children.enumerated().reduce(into: [FieldRepresenting]()) {
            
            guard $1.element.label != "title" else  {
                return
            }
            
            $0.append(FieldRepresenting(field: "\($1.element.label?.capitalizingFirstLetter() ?? "")",
                                        value: "\($1.element.value as? String ?? "")"))
        }
    }
    
    func reflex2() -> [(section: Section, values: FieldRepresenting)] {
        
        let array = Mirror(reflecting: self).children.enumerated().reduce(into: [(section: Section, values: FieldRepresenting)]()) { res, seq in
            
            guard seq.element.label != CodingKeys.title.string else {
                return
            }
            
            switch seq.element.label {
            
            case CodingKeys.year.string,
                 CodingKeys.type.string,
                 CodingKeys.released.string,
                 CodingKeys.production.string:
                
                res.append((section: .information, values: FieldRepresenting(field: "\(seq.element.label?.capitalizingFirstLetter() ?? "")",
                                                                             value: "\(seq.element.value as? String ?? "")")))
            case CodingKeys.director.string,
                 CodingKeys.writer.string,
                 CodingKeys.actors.string:
                
                res.append((section: .peoples, values: FieldRepresenting(field: "\(seq.element.label?.capitalizingFirstLetter() ?? "")",
                                                                         value: "\(seq.element.value as? String ?? "")")))
                
            case CodingKeys.rated.string,
                 CodingKeys.imdbRating.string,
                 CodingKeys.imdbVotes.string,
                 CodingKeys.awards.string:
                
                res.append((section: .ratings, values: FieldRepresenting(field: "\(seq.element.label?.capitalizingFirstLetter() ?? "")",
                                                                         value: "\(seq.element.value as? String ?? "")")))
                
            default:
                
                res.append((section: .other, values: FieldRepresenting(field: "\(seq.element.label?.capitalizingFirstLetter() ?? "")",
                                                                       value: "\(seq.element.value as? String ?? "")")))
            }
            
        }
        
        return []
    }
    
    func reflex3() -> [(section: Section, values: [FieldRepresenting])] {
        
        //        var array2: [Section: [FieldRepresenting]] = [(section: .information, values: [])]
        
        let dict = Mirror(reflecting: self).children.enumerated().reduce(into: [Section: [FieldRepresenting]]()) { res, seq in
            
            guard (seq.element.label?.capitalizingFirstLetter() ?? "") != CodingKeys.title.stringValue.capitalizingFirstLetter() else {
                return
            }
            
            var section: Section = .other
            
            switch seq.element.label?.capitalizingFirstLetter() {
            
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
            
            var prevArray = res[section] ?? []
            
            let newElement = FieldRepresenting(field: "\(seq.element.label?.capitalizingFirstLetter() ?? "")",
                                               value: "\(seq.element.value as? String ?? "")")
            
            prevArray.append(newElement)
            res[section] = prevArray
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
