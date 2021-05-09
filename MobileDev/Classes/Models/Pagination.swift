//
//  Pagination.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 11.02.2021.
//

import Foundation

struct Pagination<Parsable: Decodable>: Decodable {
    
    // MARK: - Public properties
    
    var total: Int
    var items: [Parsable]
        
    // MARK: - Computed properties
    
    var perPage: Int {
        
        return Constants.API.perPageOMDB
    }
    
    var nextPage: Int? {
        
        guard items.count < total else {
            return nil
        }
        let page = items.count / perPage + 1
        return page
    }
    
    // MARK: - CodingKeys
    
    enum CodingKeys: String, CodingKey {
        
        case total = "totalResults"
        case items = "Search"
    }
    
    // MARK: - Lifecycle
    
    init() {
        total = 0
        items = []
    }
    
    init(from decoder: Decoder) throws {
        
        let containier = try decoder.container(keyedBy: CodingKeys.self)
        
        total = Int(try containier.decode(String.self, forKey: .total)) ?? 0
        items = try containier.decode([Parsable].self, forKey: .items)
    }
    
    // MARK: - Public methods
    
    mutating func merge(with pagination: Pagination<Parsable>) {
        
        total = pagination.total
        items.append(contentsOf: pagination.items)
    }
}
