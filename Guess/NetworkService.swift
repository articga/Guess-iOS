//
//  NetworkService.swift
//  Guess
//
//  Created by Rene Dubrovski on 2/25/20.
//  Copyright © 2020 articga. All rights reserved.
//
// Required methods for network requests

import Alamofire
import KeychainAccess

let CDN_URL = "https://articga.fra1.digitaloceanspaces.com/guess/profile_img/"
var BASE_URL = "http://188.166.160.27"
var TOKEN = ""

class NetworkService {
    
    struct User: Decodable {
        var id: Int?
        var username: String?
        var email: String?
        var profileImageIdentifier: String?
    }
    
    struct LoginData: Decodable {
        var token: String?
    }
    
    struct ServerMessage: Decodable {
        var message: String?
    }
        
    //Authenticate user with the server
    func authenticateUser(email: String, password: String, completion: @escaping (Bool) -> ()) {
        AF.request("\(BASE_URL)/auth/login", method: .post, parameters: ["email": email, "password": password], encoder: JSONParameterEncoder.default).validate().responseData { (response) in
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
    
    //Authenticate using apple token
    func authenticateUser(token: String, completion: @escaping (Bool, LoginData) -> ()) {
        AF.request("\(BASE_URL)/auth/login/apple", method: .post, parameters: ["authToken": token], encoder: JSONParameterEncoder.default).validate().responseJSON { (response) in
            switch response.result {
            case .success(_):
                if let jsonData = response.data {
                    let jsonDecoder = JSONDecoder()
                    do {
                        let data = try jsonDecoder.decode(LoginData.self, from: jsonData)
                        let keychain = Keychain(service: "eu.dubrosvki.guess")
                        if let tokenG = data.token {
                            TOKEN = tokenG
                        }
                        if let refTKN = response.response?.allHeaderFields["rt"] as? String {
                            do {
                                try keychain.set("ref_token", key: refTKN)
                            } catch let err{
                                print("Ref Token set error: \(err)")
                            }
                        }
                        completion(true, data)
                    } catch let err {
                        print(err)
                        completion(false, LoginData())
                    }
                }
                break
            case .failure(_):
                completion(false, LoginData())
                break
            }
        }
    }
    
    func registerNewUser(username: String, email: String, password: String, completion: @escaping (Bool, String) -> ()) {
        AF.request("\(BASE_URL)/auth/signup", method: .post, parameters: ["username": username, "email": email, "password": password], encoder: JSONParameterEncoder.default).validate().responseJSON { (response) in
            switch response.result {
            case .success(_):
                completion(true, "Success")
                break
            case .failure(_):
                if let jsonData = response.data {
                    let jsonDecoder = JSONDecoder()
                    do {
                        let serverMessage = try jsonDecoder.decode(ServerMessage.self, from: jsonData)
                        print("Done!")
                        completion(false, serverMessage.message ?? "")
                    } catch let err {
                        print(err)
                        completion(false, "Failed to parse message")
                    }
                }
                break
            }
        }
    }
    
    func checkIfAuthenticated(token: String, completion: @escaping (Bool) -> ()) {
        AF.request("\(BASE_URL)/actions", method: .get, parameters: ["token": token], encoder: JSONParameterEncoder.default).validate().responseData { (response) in
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
    func fetchLoggedInUser(token: String,completion: @escaping (User, Bool) -> ()) {
        AF.request("\(BASE_URL)/auth/me", method: .get, parameters: ["token": token], encoder: JSONParameterEncoder.default).validate().responseJSON { (response) in
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
    
    func uploadProfileImage(image: Data,completion: @escaping (Bool, String) -> ()) {
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        AF.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(image, withName: "upload", fileName: "profilephotoios.jpeg", mimeType: "image/jpeg")
        }, to: "\(BASE_URL)/actions/profile/upload", headers: headers).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                completion(true, "Upload complete!")
            case .failure:
                if let jsonData = response.data {
                    let jsonDecoder = JSONDecoder()
                    do {
                        let serverMessage = try jsonDecoder.decode(ServerMessage.self, from: jsonData)
                        print("Done!")
                        completion(true, serverMessage.message ?? "")
                    } catch let err {
                        print(err)
                        completion(false, "Failed to parse message")
                    }
                }
                completion(false, "")
            }
        }
    }
    
    
}

extension Request {
    public func debugLog() -> Self {
        #if DEBUG
            debugPrint("=======================================")
            debugPrint(self)
            debugPrint("=======================================")
        #endif
        return self
    }
}
