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
import UIKit

let CDN_URL = "https://articga.fra1.digitaloceanspaces.com/guess/profile_img/"
#if DEBUG
    var BASE_URL = "http://192.168.0.3:8080"
#else
    var BASE_URL = "http://188.166.160.27"
#endif

protocol NetworkServiceDelegate {
    func loginRequired() //call sharedInstance.showLogin(self)
}

class NetworkService {
    
    static let sharedInstance = NetworkService()
    static var reqToken = ""
    private var session: Session!
    var delegate: NetworkServiceDelegate?

    init() {
        let config = Session.default.session.configuration
        session = Session(configuration: config, interceptor: self)
    }
    
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
        
    
    /// Authenticate user
    /// - Parameters:
    ///   - email: Users email
    ///   - password: Users password
    ///   - onCompletion: Was successful
    ///   - onFailure: Invalid request returns error reason as string
    func authenticateUser(email: String, password: String, onCompletion: @escaping () -> (), onFailure: @escaping (String) -> ()) {
        AF.request("\(BASE_URL)/auth/login", method: .post, parameters: ["email": email, "password": password], encoder: JSONParameterEncoder.default).validate().responseJSON { (response) in
            switch response.result {
            case .success(_):
                if let jsonData = response.data {
                    let jsonDecoder = JSONDecoder()
                    do {
                        if let token = try jsonDecoder.decode(LoginData.self, from: jsonData).token {
                            NetworkService.reqToken = token
                            if let refTKN = response.response?.allHeaderFields["rt"] as? String {
                                self.saveOrUpdateRefreshToken(token: refTKN)
                                onCompletion()
                            }
                        }
                    } catch let err {
                        print("Error authenticating user: \(err)")
                        onFailure("Auth error")
                    }
                }
                
                break
            case .failure(_):
                onFailure("Error contacting server")
                break
            }
        }
    }
    
    
    /// Authenticate user with appleID
    /// - Parameters:
    ///   - token: appleToken
    ///   - completion: Data
    func authenticateUser(token: String, completion: @escaping (Bool, LoginData) -> ()) {
        AF.request("\(BASE_URL)/auth/login/apple", method: .post, parameters: ["authToken": token], encoder: JSONParameterEncoder.default).validate().responseJSON { (response) in
            switch response.result {
            case .success(_):
                if let jsonData = response.data {
                    let jsonDecoder = JSONDecoder()
                    do {
                        let dd = try jsonDecoder.decode(LoginData.self, from: jsonData)
                        NetworkService.reqToken = dd.token ?? ""
                        if let refTKN = response.response?.allHeaderFields["rt"] as? String {
                            self.saveOrUpdateRefreshToken(token: refTKN)
                            completion(true, dd)
                        }
                        
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
    
    
    /// Create new user account
    /// - Parameters:
    ///   - username: Username
    ///   - email: Email
    ///   - password: Password
    ///   - completion: Completion
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
    
    func logOut() {
        let kC = Keychain(service: "eu.dubrovski.guess")
        kC["refreshToken"] = nil
        NetworkService.reqToken = ""
        //TODO: Implement in server
    }
    
//    func checkIfAuthenticated(token: String, completion: @escaping (Bool) -> ()) {
//        AF.request("\(BASE_URL)/actions", method: .get, parameters: ["token": token], encoder: JSONParameterEncoder.default).validate().responseData { (response) in
//            switch response.result {
//            case .success(_):
//                completion(true)
//                break
//            case .failure(_):
//                completion(false)
//                break
//            }
//        }
//    }
    
    
    /// Fetch users details
    /// - Parameters:
    ///   - onCompletion: Fetching details was succesful, return user object
    ///   - onFailure: There was an error, returns error string
    func fetchLoggedInUser(onCompletion: @escaping (User) -> (), onFailure: @escaping (String) -> ()) {
        session.request("\(BASE_URL)/auth/me", method: .get).validate().responseJSON { (response) in
            debugPrint(response)
            switch response.result {
            case .success:
                if let jsonData = response.data {
                    let jsonDecoder = JSONDecoder()
                    do {
                        let user = try jsonDecoder.decode(User.self, from: jsonData)
                        onCompletion(user)
                    } catch let err {
                        print(err)
                        onFailure("Token may be expired")
                    }
                }
            case .failure:
                onFailure("Failures contacting server")
            }
        }
    }
    
    
//    private func logOut(completion: @escaping (Bool) -> ()) {
//        AF.request("\(BASE_URL)/auth/logout").validate().responseJSON { (response) in
//            switch response.result {
//            case .success:
//                completion(true)
//            case .failure:
//                completion(false)
//            }
//        }
//    }
    
    
    /// Upload Profile Image To Server
    /// - Parameters:
    ///   - image: imageData as Data
    ///   - completion: didComplete: Bool; Error: String
    func uploadProfileImage(image: Data,completion: @escaping (Bool, String) -> ()) {
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        session.upload(multipartFormData: { (multipartFormData) in
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
    
    
    /// Save refresh token to keychain
    /// - Parameter token: refresh token provided by server
    private func saveOrUpdateRefreshToken(token: String) {
        let keychain = Keychain(service: "eu.dubrovski.guess")
        keychain["refreshToken"] = token
        print("Token saved")
    }
        
    /// GET new token and refresh token
    /// - Parameters:
    ///   - onCompletion: success, returns token
    ///   - onFailure: error :(
    func refreshToken(onCompletion: @escaping (String) -> Void, onFailure: @escaping () -> Void) {
        //Get from keychain
        let keychain = Keychain(service: "eu.dubrovski.guess")
        
        if let refToken = keychain["refreshToken"] {
            let headers: HTTPHeaders = ["rt": refToken]
            AF.request("\(BASE_URL)/auth/refresh_token", method: .get, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<420).responseJSON
                { (response) in
                switch response.result {
                case .success:
                    if response.response?.statusCode == 418 {
                        //Refreshtoken expired or doesn't exist
                        self.delegate?.loginRequired()
                    } else if response.response?.statusCode == 200 {
                        if let jsonData = response.data {
                            let jsonDecoder = JSONDecoder()
                            do {
                                let serverMessage = try jsonDecoder.decode(LoginData.self, from: jsonData)
                                if let refTKN = response.response?.allHeaderFields["rt"] as? String {
                                    self.saveOrUpdateRefreshToken(token: refTKN)
                                    if let token = serverMessage.token {
                                        onCompletion(token)
                                    }
                                }
                                
                            } catch let err {
                                print(err)
                                onFailure()
                            }
                        
                        } else {
                            onFailure()
                        }
                    } else {
                        //Unknow error code from server
                        self.delegate?.loginRequired()
                    }
                case .failure(_):
                    onFailure()
                }
                    
            }
        } else {
            //No refreshtoken in keychain
            delegate?.loginRequired()
        }
        
    }
    
    
    /// Show login screen
    /// - Parameter targetVC: ViewController for the view to be shown
    func showLogin(targetVC: UIViewController) {
        DispatchQueue.main.async {
            let vc = InitialLoadViewController()
            vc.modalPresentationStyle = .fullScreen
            targetVC.present(vc, animated: true, completion: nil)
        }
    }
}

extension NetworkService: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        urlRequest.headers.add(.init(name: "token", value: NetworkService.reqToken))
        if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix(BASE_URL), !urlString.hasSuffix("/refresh_token") {
            let keychain = Keychain(service: "eu.dubrovski.guess")
            if let token = keychain["refreshToken"] {
                urlRequest.headers.add(.init(name: "rt", value: token))
            }
        }
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        //401 means token expired or invalid, 403 means no token at all
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 403 {
            NetworkService.sharedInstance.refreshToken(onCompletion: { (token) in
                //Assign new token
                NetworkService.reqToken = token
                //Retry request immidiately, when new token received
                completion(.retry)
            }) {
                //Fetching failed perform login
                completion(.doNotRetry)
            }
        } else {
            //Other requests do not need to be retryed
            completion(.doNotRetry)
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
