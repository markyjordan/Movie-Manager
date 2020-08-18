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
    
    enum Endpoints {
        static let base = "https://api.themoviedb.org/3"
        static let apiKeyParam = "?api_key=\(TMDBClient.apiKey)"
        
        case getWatchlist
        
        var stringValue: String {
            switch self {
            case .getWatchlist:
                return Endpoints.base + "/account/\(Auth.accountId)/watchlist/movies" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
            }
        }
        
        // generate a URL from the endpoint's associated string value
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func getWatchlist(completionHandler: @escaping ([Movie], Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.getWatchlist.url) { data, response, error in
            guard let data = data else {
                completionHandler([], error)
                return
            }
            let jsonDecoder = JSONDecoder()
            do {
                let responseObject = try jsonDecoder.decode(MovieResults.self, from: data)
                completionHandler(responseObject.results, nil)
            } catch {
                completionHandler([], error)
            }
        }
        task.resume()
    }
}