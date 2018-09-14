//
//  Channel.swift
//  app-Smack
//
//  Created by James Ullom on 9/14/18.
//  Copyright © 2018 Hammer of the Gods Software. All rights reserved.
//

import Foundation

// Adding the new Swift 4 Decodbable capability to give it a whirl
struct Channel : Decodable {
// Swift 3 version used with Swifty
//    public private(set) var channelTitle: String
//    public private(set) var chennelDescription: String
//    public private(set) var id: String

// Swift 4 Decodable version - need to mirror the json response EXACTLY
    // these internal vars hold the decoded JSON values
    private var name: String!
    private var description: String!
    private var _id: String!
    private var __v: Int?

    // freindly names using computed properties so that I don't have additional storage
    var channelTitle: String! { get { return name } set { name = newValue } }
    var channelDescription: String! { get { return description } set { description = newValue } }
    var id: String! { get { return _id } set { _id = newValue } }

    init(channelTitle title: String, channelDescription desc: String, id: String) {
        
        name = title
        description = desc
        _id = id
    }

}
