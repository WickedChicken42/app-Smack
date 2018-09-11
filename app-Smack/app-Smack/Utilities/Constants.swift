//
//  Constants.swift
//  app-Smack
//
//  Created by James Ullom on 9/6/18.
//  Copyright © 2018 Hammer of the Gods Software. All rights reserved.
//

import Foundation

// Remaps a type to a new name for use in the code
// This is a custom closure - a first class function that can be passed around
typealias CompletionHandler = (_ Success: Bool) -> ()

// URLs
let BASE_URL = "https://chattychatchat42.herokuapp.com/v1/"
let URL_REGISTER = BASE_URL + "account/register"

let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND = "unwindToChannel"

// User Defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"
