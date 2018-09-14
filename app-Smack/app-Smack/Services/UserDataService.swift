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
    public private(set) var avatarUIColor = UIColor.lightGray
    
    func setUserData(id: String, color: String, avatarName: String, email: String, name: String) {
        self.id = id
        self.avatarColor = color
        self.avatarName = avatarName
        self.email = email
        self.name = name
        
        // Convert the color string into a UIColor propery for easy retreval
        avatarUIColor = returnUIColor(components: color)
    }
    
    func setAvatarName(avatarName: String) {
        self.avatarName = avatarName
    }

    func returnUIColor(components: String) -> UIColor {

        // Define a scanner to read through the text to extract the color values we want
        let scanner = Scanner(string: components)
        let skipped = CharacterSet(charactersIn: "[], ")
        let comma = CharacterSet(charactersIn: ",")
        scanner.charactersToBeSkipped = skipped

        // Run the scanner from comma to comma.  It will not return the charatcers we have told it to skip
        var r, b, g, a : NSString?
        scanner.scanUpToCharacters(from: comma, into: &r)
        scanner.scanUpToCharacters(from: comma, into: &g)
        scanner.scanUpToCharacters(from: comma, into: &b)
        scanner.scanUpToCharacters(from: comma, into: &a)

        // Define a default color we can return if anything goes wrong
        let defaultColor = UIColor.lightGray
        
        // Unwrap the newly scanned strings to make sure we have happy values
        guard let rUnwrapped = r else { return defaultColor }
        guard let gUnwrapped = g else { return defaultColor }
        guard let bUnwrapped = b else { return defaultColor }
        guard let aUnwrapped = a else { return defaultColor }

        // Convert the NSString values into CGFloats for use with UIColor
        let rFloat = CGFloat(rUnwrapped.doubleValue)
        let gFloat = CGFloat(gUnwrapped.doubleValue)
        let bFloat = CGFloat(bUnwrapped.doubleValue)
        let aFloat = CGFloat(aUnwrapped.doubleValue)

        // Define the new UIColor from the CGFloat values
        let newUIColor = UIColor(red: rFloat, green: gFloat, blue: bFloat, alpha: aFloat)

        return newUIColor
    }
}
