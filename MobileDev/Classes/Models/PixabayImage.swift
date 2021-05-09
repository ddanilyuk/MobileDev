//
//  PixabayImage.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 10.05.2021.
//

import Foundation

struct PixabayImage {
    var id: Int
    var imageURL: String
}

// MARK: - Codable

extension PixabayImage: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case imageURL = "webformatURL"
    }
}

// MARK: - Hashable

extension PixabayImage: Hashable {
    
    
}
