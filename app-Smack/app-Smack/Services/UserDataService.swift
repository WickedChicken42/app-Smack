//
//  UserDataService.swift
//  app-Smack
//
//  Created by James Ullom on 9/12/18.
//  Copyright © 2018 Hammer of the Gods Software. All rights reserved.
//

import Foundation

class UserDataService {
    static let instance = UserDataService()
    
    // Define the variables to match the data being set in the User requests
    // Creating a public GET but a private SET variable
    public private(set) var id = ""
    public private(set) var avatarColor = ""
    public private(set) var avatarName = ""
    public private(set) var email = ""
    public private(set) var name = ""

    func setUserData(id: String, color: String, avatarName: String, email: String, name: String) {
        self.id = id
        self.avatarColor = color
        self.avatarName = avatarName
        self.email = email
        self.name = name
    }
    
    func setAvatarName(avatarName: String) {
        self.avatarName = avatarName
    }
}
