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
let URL_LOGIN = BASE_URL + "account/login"
let URL_ADD_USER = BASE_URL + "user/add"
let URL_GET_USER_BY_EMAIL = BASE_URL + "/user/byEmail/"
let URL_GET_ALL_CHANNELS = BASE_URL + "channel"

let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let TO_AVATAR_PICKER = "toAvatarPicker"
let UNWIND = "unwindToChannel"

// User Defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"

// Colors
let SMACK_PURPLE_PLACEHOLDER = #colorLiteral(red: 0.01687073149, green: 0.1594210565, blue: 0.8048419356, alpha: 0.5)

// Notification Constants
let NOTIF_USER_DATA_DID_CHANGE = Notification.Name("notifUserDataChanged")
let NOTIF_CHANNELS_LOADED = Notification.Name("channelsLoaded")
let NOTIF_CHANNEL_SELECTED = Notification.Name("channelSelected")
