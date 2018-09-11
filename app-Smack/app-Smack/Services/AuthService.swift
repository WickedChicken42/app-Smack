//
//  AuthService.swift
//  app-Smack
//
//  Created by James Ullom on 9/11/18.
//  Copyright © 2018 Hammer of the Gods Software. All rights reserved.
//

import Foundation
import Alamofire

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

        let header = [
            "Content-type": "application/json; charset=utf-8"
        ]

        // Define the body of the JSON
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]

        // Create the web request
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseString { (response) in
            
            if response.result.error == nil {
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        
        
    }
    
}
