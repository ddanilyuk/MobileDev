//
//  Pagination.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 11.02.2021.
//

import Foundation

struct Pagination<Parsable: Decodable>: Decodable {
    
    // var total: Int
    var items: [Parsable]
    
    enum CodingKeys: String, CodingKey {
        
        // case total = "totalResults"
        case items = "Search"
    }
}
