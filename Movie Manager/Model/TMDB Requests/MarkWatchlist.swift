//
//  MarkWatchlist.swift
//  Movie Manager
//
//  Created by Marky Jordan on 8/18/20.
//  Copyright © 2020 Marky Jordan. All rights reserved.
//

import Foundation

struct MarkWatchlist {
    
    let mediaType: String
    let mediaId: Int
    let watchList: Bool
    
    enum CodingKeys: String, CodingKey {
        
        case mediaType = "media_type"
        case mediaId = "media_id"
        case watchList = "watchlist"
    }
}
