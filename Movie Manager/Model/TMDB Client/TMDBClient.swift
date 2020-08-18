//
//  TMDBClient.swift
//  Movie Manager
//
//  Created by Marky Jordan on 8/18/20.
//  Copyright © 2020 Marky Jordan. All rights reserved.
//

import Foundation

class TMDBClient {
    
    static let apiKey = "YOUR_TMDB_API_KEY"
    
    struct Auth {
        static var accountId = 0
        static var requestToken = ""
        static var sessionId = ""
    }
}
