//
//  Message.swift
//  app-Smack
//
//  Created by James Ullom on 9/16/18.
//  Copyright © 2018 Hammer of the Gods Software. All rights reserved.
//

import Foundation

struct Message: Decodable {

    // Implemented to prevent property userAvatarUIColor from being serialized in the decoding by leaving it out of the enum below
    private enum CodingKeys: String, CodingKey {
        case _id
        case messageBody
        case userId
        case channelId
        case userName
        case userAvatar
        case userAvatarColor
        case timeStamp
        case __v
    }

    // Swift 4 Decodable version - need to mirror the json response EXACTLY
    // these internal vars hold the decoded JSON values
    private var _id: String!
    private var messageBody: String!
    private var userId: String!
    private var channelId: String!
    private var userName: String!
    private var userAvatar: String!
    private var userAvatarColor: String! {
        didSet{
            userAvatarUIColor = UserDataService.instance.returnUIColor(components: userAvatarColor)
        }
    }
    private var timeStamp: String!
    private var __v: Int?

    // Not part of the JSON data, for simpler use of the Avatar color value by pre-calcing the actual UIColor item
    private var userAvatarUIColor: UIColor!
    
    // freindly names using computed properties so that I don't have additional storage
    var id: String! { get { return _id } set { _id = newValue } }
    var message: String! { get { return messageBody} set {messageBody = newValue}}
    var userID: String! { get { return userId } set { userId = newValue } }
    var channelID: String! { get { return channelId } set { channelId = newValue } }
    var name: String! { get { return userName } set { userName = newValue } }
    var avatarName: String! { get { return userAvatar } set { userAvatar = newValue } }
    var avatarColor: String! { get { return userAvatarColor } set { userAvatarColor = newValue } }
    var messageTimeStamp: String! { get { return timeStamp } set { timeStamp = newValue } }

    // Precalculated UIColor value loaded when the data is loaded to the object
    var avatarUIColor: UIColor! { get { return userAvatarUIColor } set { userAvatarUIColor = newValue } }

    init(messageBody mText: String, userId uID: String, channelId cID: String, userName name: String, userAvatar avatarName: String, userAvatarColor avatarBGColor: String, mTimeStamp: String, id: String) {
        
        messageBody = mText
        userId = uID
        channelId = cID
        userName = name
        userAvatar = avatarName
        userAvatarColor = avatarBGColor
        timeStamp = mTimeStamp
        _id = id
        
        // No longer needed due to the didSet observer implemented above
        userAvatarUIColor = UserDataService.instance.returnUIColor(components: avatarBGColor)

    }

    
}
