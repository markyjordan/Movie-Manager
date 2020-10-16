//
//  MarkFavorite.swift
//  Movie Manager
//
//  Created by Marky Jordan on 8/18/20.
//  Copyright © 2020 Marky Jordan. All rights reserved.
//

import Foundation

struct MarkFavorite: Codable {
    
    let mediaType: String
    let mediaId: Int
    let favorite: Bool
    
    enum CodingKeys: String, CodingKey {
        case mediaType = "media_type"
        case mediaId = "media_id"
        case favorite = "favorite"
    }
}
