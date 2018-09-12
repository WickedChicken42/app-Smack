//
//  AuthService.swift
//  app-Smack
//
//  Created by James Ullom on 9/11/18.
//  Copyright © 2018 Hammer of the Gods Software. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AuthService {
    // Creating the Singleton instance so that there is only ever one in the app
    static  let instance = AuthService()
    
    let defaults = UserDefaults.standard
    var isLoggedIn: Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    var authToken: String {
        get {
            return defaults.value(forKey: TOKEN_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    var userEmail: String {
        get {
            return defaults.value(forKey: USER_EMAIL) as! String
        }
        set {
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    // Using the Alamofire tools to make the JSON work easier
    func registerUser(email: String, password: String, completion: @escaping CompletionHandler) {
        
        // make sure there are no capital letter in the email address
        let lowerCaseEmail = email.lowercased()

        // Define the header to be used with the Register posting
        let header = [
            "Content-type": "application/json; charset=utf-8"
        ]

        // Define the body of the request
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]

        // Create the web request using Alamofire
        // Using responseString this time because thats what the request will return but normally we would use .responseJSON to handle returning JSON data
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseString { (response) in
            // Handling the response given back and setting the completion handler to True/False as a result
            if response.result.error == nil {
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping CompletionHandler) {
        
        // make sure there are no capital letter in the email address
        let lowerCaseEmail = email.lowercased()
        
        // Define the header to be used with the Register posting
        let header = [
            "Content-type": "application/json; charset=utf-8"
        ]
        
        // Define the body of the request
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        // Create the web request using Alamofire
        // Using responseJSON this time because thats what the request will return JSON data
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            // Handling the response given back and setting the completion handler to True/False as a result
            if response.result.error == nil {
                // *** Classic JSON handling
//                if let json = response.result.value as? Dictionary<String, Any> {
//                    if let email = json["user"] as? String {
//                        self.userEmail = email
//                    }
//                    if let token = json["token"] as? String {
//                        self.authToken = token
//                    }
//                }
                
                // *** The SwiftyJSON way to process JSON
                guard let data = response.data else { return }
                let json = JSON(data)
                self.userEmail = json["user"].stringValue
                self.authToken = json["token"].stringValue
                
                self.isLoggedIn = true
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }

    }
    
    func createUser(name: String, email: String, avatarName: String, avatarColor: String, completion: @escaping CompletionHandler) {
        
        // make sure there are no capital letter in the email address
        let lowerCaseEmail = email.lowercased()
        
        // Define the header to be used with the Register posting
        let header = [
            "Content-type": "application/json; charset=utf-8",
            "Authorization": "Bearer \(AuthService.instance.authToken)"
        ]
        
        // Define the body of the request
        let body: [String: Any] = [
            "name": name,
            "email": lowerCaseEmail,
            "avatarName": avatarName,
            "avatarColor": avatarColor
        ]

        Alamofire.request(URL_ADD_USER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            // Handling the response given back and setting the completion handler to True/False as a result
            if response.result.error == nil {
                // *** The SwiftyJSON way to process JSON
                guard let data = response.data else { return }
                let json = JSON(data)
                
                let id = json["_id"].stringValue
                let name = json["name"].stringValue
                let avatarColor = json["avatarColor"].stringValue
                let avatarName = json["avatarName"].stringValue
                let email = json["email"].stringValue

                // Set the User instance values via its function since the setters are all Private
                UserDataService.instance.setUserData(id: id, color: avatarColor, avatarName: avatarName, email: email, name: name)
                
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }

    }
}
