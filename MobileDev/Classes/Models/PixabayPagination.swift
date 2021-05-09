//
//  PixabayPagination.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 10.05.2021.
//

import Foundation

// TODO: Delete and add another CodingKeys to Pagination
struct PixabayPagination<Parsable: Decodable>: Decodable {
    
    // MARK: - Public properties
    
    var total: Int
    var items: [Parsable]
    
    // MARK: - Computed properties
    
    var perPage: Int {
        
        return Constants.API.perPagePixabay
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
        
        case total = "totalHits"
        case items = "hits"
    }
    
    // MARK: - Lifecycle
    
    init() {
        total = 0
        items = []
    }
    
    // MARK: - Public methods
    
    mutating func merge(with pagination: PixabayPagination<Parsable>) {
        
        total = pagination.total
        items.append(contentsOf: pagination.items)
    }
}
