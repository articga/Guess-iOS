//
//  NetworkService.swift
//  Guess
//
//  Created by Rene Dubrovski on 2/25/20.
//  Copyright © 2020 articga. All rights reserved.
//
// Required methods for network requests

import Alamofire

//let BASE_URL = "http://192.168.0.3:8080"
=let BASE_URL = "http://188.166.160.27"

class NetworkService {
    
    struct User: Decodable {
        var id: Int?
        var username: String?
        var email: String?
        var profileImageIdentifier: String?
    }
        
    //Authenticate user with the server
    func authenticateUser(email: String, password: String, completion: @escaping (Bool) -> ()) {
        AF.request("\(BASE_URL)/auth/login", method: .post, parameters: ["email": email, "password": password], encoder: JSONParameterEncoder.default).validate().responseData { (response) in
            print(response.data)
            switch response.result {
            case .success(_):
                completion(true)
                break
            case .failure(_):
                completion(false)
                break
            }
        }
    }
    
    func checkIfAuthenticated(completion: @escaping (Bool) -> ()) {
        AF.request("\(BASE_URL)/actions", method: .get).validate().responseData { (response) in
            switch response.result {
            case .success(_):
                completion(true)
                break
            case .failure(_):
                completion(false)
                break
            }
        }
    }
    
    //User object, success?
    func fetchLoggedInUser(completion: @escaping (User, Bool) -> ()) {
        AF.request("\(BASE_URL)/auth/me").validate().responseJSON { (response) in
            debugPrint(response)
            switch response.result {
            case .success:
                if let jsonData = response.data {
                    let jsonDecoder = JSONDecoder()
                    do {
                        let user = try jsonDecoder.decode(User.self, from: jsonData)
                        print("Done!")
                        completion(user, true)
                    } catch let err {
                        print(err)
                        completion(User(id: -1, username: "", email: "", profileImageIdentifier: ""), false)
                    }
                }
            case .failure:
                completion(User(id: -1, username: "", email: "", profileImageIdentifier: ""), false)
            }
        }
    }
    
    func logOut(completion: @escaping (Bool) -> ()) {
        AF.request("\(BASE_URL)/auth/logout").validate().responseJSON { (response) in
            switch response.result {
            case .success:
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
}
