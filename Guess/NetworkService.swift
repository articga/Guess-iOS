//
//  NetworkService.swift
//  Guess
//
//  Created by Rene Dubrovski on 2/25/20.
//  Copyright © 2020 articga. All rights reserved.
//
// Required methods for network requests

import Alamofire

let BASE_URL = "http://192.168.0.3:8080"

class NetworkService {
        
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
    
}
