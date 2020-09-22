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
        case login
        case createSessionId
        case webAuth
        case logout
        
        var stringValue: String {
            switch self {
            case .getRequestToken:
                return Endpoints.base + "/authentication/token/new" + Endpoints.apiKeyParam
            case .getWatchlist:
                return Endpoints.base + "/account/\(Auth.accountId)/watchlist/movies" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
            case .login:
                return Endpoints.base + "/authentication/token/validate_with_login" + Endpoints.apiKeyParam
            case .createSessionId:
                return Endpoints.base + "/authentication/session/new" + Endpoints.apiKeyParam
            case .webAuth:
                return "https://www.themoviedb.org/authenticate/" + Auth.requestToken + "?redirect_to=themoviemanager:authenticate"
            case .logout:
                return Endpoints.base + "/authentication/session" + Endpoints.apiKeyParam
            }
        }
        
        // generate a URL from the endpoint's associated string value
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    // MARK: - Network Requests
    
    // get an API request token
    class func getRequestToken(completionHandler: @escaping (Bool, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.getRequestToken.url) { data, response, error in
            guard let data = data else {
                completionHandler(false, error)
                return
            }
            let jsonDecoder = JSONDecoder()
            do {
                let responseObject = try jsonDecoder.decode(RequestTokenResponse.self, from: data)
                Auth.requestToken = responseObject.requestToken
                completionHandler(true, nil)
            } catch {
                completionHandler(false, error)
            }
        }
        task.resume()
    }
    
    // get the watchlist
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
    
    // 'GET' requests
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType, completionHandler: @escaping (ResponseType?, Error?) -> Void) {
        
    }
    
    // login request
    class func login(username: String, password: String, completionHandler: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.login.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = LoginRequest(username: username, password: password, requestToken: Auth.requestToken)
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error ) in
            guard let data = data else {
                completionHandler(false, error)
                return
            }
            // parse the data
            do {
                let jsonDecoder = JSONDecoder()
                let responseObject = try jsonDecoder.decode(RequestTokenResponse.self, from: data)
                Auth.requestToken = responseObject.requestToken
                completionHandler(true, nil)
            } catch {
                completionHandler(false, error)
            }
        }
        task.resume()
    }
    
    // create new session id
    class func createSessionId(completionHandler: @escaping (Bool, Error?) -> Void) {
        // prepare the session id request
        var request = URLRequest(url: Endpoints.createSessionId.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = PostSession(requestToken: Auth.requestToken)
        request.httpBody = try! JSONEncoder().encode(body)
        
        // initiate the session id request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completionHandler(false, error)
                return
            }
            // parse the data
            do {
                let jsonDecoder = JSONDecoder()
                let responseObject = try jsonDecoder.decode(SessionResponse.self, from: data)
                Auth.sessionId = responseObject.sessionId
                completionHandler(true, nil)
            } catch {
                completionHandler(false, error)
            }
        }
        task.resume()
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


