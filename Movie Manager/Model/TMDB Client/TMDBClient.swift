//
//  TMDBClient.swift
//  Movie Manager
//
//  Created by Marky Jordan on 8/18/20.
//  Copyright © 2020 Marky Jordan. All rights reserved.
//

import Foundation

class TMDBClient {
    
    static let apiKey = myTmdbApiKey
    
    struct Auth {
        static var accountId = 0
        static var requestToken = ""
        static var sessionId = ""
    }
    
    enum Endpoints {
        static let base = "https://api.themoviedb.org/3"
        static let apiKeyParam = "?api_key=\(TMDBClient.apiKey)"
        
        case getRequestToken
        case getWatchlist
        case getFavorites
        case login
        case createSessionId
        case webAuth
        case logout
        case search(String)
        
        var stringValue: String {
            switch self {
            case .getRequestToken:
                return Endpoints.base + "/authentication/token/new" + Endpoints.apiKeyParam
            case .getWatchlist:
                return Endpoints.base + "/account/\(Auth.accountId)/watchlist/movies" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
            case .getFavorites:
                return Endpoints.base + "/account/\(Auth.accountId)/favorite/movies" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
            case .login:
                return Endpoints.base + "/authentication/token/validate_with_login" + Endpoints.apiKeyParam
            case .webAuth:
                return "https://www.themoviedb.org/authenticate/" + Auth.requestToken + "?redirect_to=themoviemanager:authenticate"
            case .createSessionId:
                return Endpoints.base + "/authentication/session/new" + Endpoints.apiKeyParam
            case .logout:
                return Endpoints.base + "/authentication/session" + Endpoints.apiKeyParam
            case .search(let query):
                return Endpoints.base + "/search/movie" + Endpoints.apiKeyParam + "&query=\(query)"
            }
        }
        
        // generate a URL from the endpoint's associated string value
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    
    // MARK: - Data Tasks
    
    // task for 'GET' request
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completionHandler: @escaping (ResponseType?, Error?) -> Void) {
        
        // create task to retrieve contents of specified url
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // check if data was returned by the server
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }
            // parse the retrieved data
            do {
                let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    // pass back the responseObject and nil for the error if data parsing is successful
                    completionHandler(responseObject, nil)
                }
                return
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }
        }
        task.resume()
    }
    
    // task for 'POST' request
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, requestBody: RequestType, responseType: ResponseType.Type, completionHandler: @escaping (ResponseType?, Error?) -> Void) {
        
        // create request body
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(requestBody)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // create task to submit POST request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // check if data was returned by the server
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }
            // parse the retrieved data
            do {
                let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    // pass back the responseObject and nil for the error if data parsing is successful
                    completionHandler(responseObject, nil)
                }
                return
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }
        }
        task.resume()
    }
    
    
    // MARK: - Network Requests
    
    // get an API request token
    class func getRequestToken(completionHandler: @escaping (Bool, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getRequestToken.url, responseType: RequestTokenResponse.self) { response, error in
            if let response = response {
                Auth.requestToken = response.requestToken
                completionHandler(true, nil)
            } else {
                completionHandler(false, error)
            }
        }
    }
    
    // get the watch list
    class func getWatchlist(completionHandler: @escaping ([Movie], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getWatchlist.url, responseType: MovieResults.self) { response, error in
            if let response = response {
                completionHandler(response.results, nil)
            } else {
                completionHandler([], error)
            }
        }
    }
    
    // get the favorites list
    class func getFavorites(completionHandler: @escaping ([Movie], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getFavorites.url, responseType: MovieResults.self) { (response, error) in
            if let response = response {
                completionHandler(response.results, nil)
            } else {
                completionHandler([], error)
            }
        }
    }
    
    // login request
    class func login(username: String, password: String, completionHandler: @escaping (Bool, Error?) -> Void) {
        
        // create the request body
        let body = LoginRequest(username: username, password: password, requestToken: Auth.requestToken)
        
        // create task to submit POST request
        taskForPOSTRequest(url: Endpoints.login.url, requestBody: body, responseType: RequestTokenResponse.self) { (response, error) in
            if let response = response {
                // set the requestToken in the Auth struct to the response object's requestToken property
                Auth.requestToken = response.requestToken
                completionHandler(true, nil)
            } else {
                completionHandler(false, nil)
            }
        }
    }
    
    // create new session id
    class func createSessionId(completionHandler: @escaping (Bool, Error?) -> Void) {
        
        // create the request body
        let body = PostSession(requestToken: Auth.requestToken)
        
        // create task to submit POST request
        taskForPOSTRequest(url: Endpoints.createSessionId.url, requestBody: body, responseType: SessionResponse.self) { (response, error) in
            if let response = response {
                // set the sessionId in the Auth struct to the response object's sessionId property
                Auth.sessionId = response.sessionId
                completionHandler(true, nil)
            } else {
                completionHandler(false, error)
            }
        }
    }
    
    // logout request
    class func logoutRequest(completionHandler: @escaping () -> Void) {
        
        // prepare the logout request
        var request = URLRequest(url: TMDBClient.Endpoints.logout.url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = LogoutRequest(sessionId: Auth.sessionId)
        request.httpBody = try! JSONEncoder().encode(body)
        
        // initiate the logout request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // set the current request token and session idea to an empty string
            Auth.requestToken = ""
            Auth.sessionId = ""
            completionHandler()
        }
        task.resume()
    }
}


