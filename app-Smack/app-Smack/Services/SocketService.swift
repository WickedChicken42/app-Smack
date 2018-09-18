//
//  SocketService.swift
//  app-Smack
//
//  Created by James Ullom on 9/14/18.
//  Copyright © 2018 Hammer of the Gods Software. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {
    static let instance = SocketService()
    
    override init() {
        super.init()
    }
    
    // Change in code from SocketIO v1.2 to 1.3
    //var socket : SocketIOClient = SocketIOClient(socketURL: URL(string: BASE_URL)!)
    let manager = SocketManager(socketURL: URL(string: BASE_URL)!)
    lazy var socket: SocketIOClient = manager.defaultSocket
    
    // Used to make a connection to our server
    // It is being called from the AppDelegate file in the DidBecomeActive function
    func establishConnection() {
        socket.connect()
    }
    
    // Used to end the connection to our server
    // It is being called from the AppDelegate file in the WillTerminate function
    func closeConnection() {
        socket.disconnect()
    }
    
    func addChannel(channelName: String, channelDesc: String, completion: @escaping CompletionHandler) {
        
        socket.emit("newChannel", channelName, channelDesc)
        completion(true)
    }
    
    func getChannel(completion: @escaping CompletionHandler) {
        
        socket.on("channelCreated") { (dataArray, ack) in
            guard let channelName = dataArray[0] as? String else { return }
            guard let channelDesc = dataArray[1] as? String else { return }
            guard let channelID = dataArray[2] as? String else { return }
            
            let newChannel = Channel(channelTitle: channelName, channelDescription: channelDesc, id: channelID)
            MessageService.instance.channels.append(newChannel)
            completion(true)
        }
    }
    
    // Sends a new message to the server via Sockets
    func addMessage(messageText: String, userID: String, channelID: String, completion: @escaping CompletionHandler) {

        let user = UserDataService.instance
        socket.emit("newMessage", messageText, userID, channelID, user.name, user.avatarName, user.avatarColor)

        completion(true)

    }

    // Receives any new messages from the server via sockets and send the newMessage object into the Completion Handler
    func getChatMessage(completion: @escaping (_ newMessage: Message) -> Void) {
        
        socket.on("messageCreated") { (dataArray, ack) in
            guard let msgBody = dataArray[0] as? String else {return}
            guard let channelID = dataArray[2] as? String else {return}
            guard let userName = dataArray[3] as? String else {return}
            guard let userAvatar = dataArray[4] as? String else {return}
            guard let userAvatarColor = dataArray[5] as? String else {return}
            guard let messageID = dataArray[6] as? String else {return}
            guard let msgTimeStamp = dataArray[7] as? String else {return}

            let newMessage = Message(messageBody: msgBody, userId: "", channelId: channelID, userName: userName, userAvatar: userAvatar, userAvatarColor: userAvatarColor, mTimeStamp: msgTimeStamp, id: messageID)

            completion(newMessage)
        }
    }
    
    // Function to handle the retreival of users who are typing with a Dictionary of Username and ChannelID being passed in the Closure
    func getTypingUsers(_ completiionHandler: @escaping (_ typingUsers: [String:String]) -> Void) {
        
        // Open the socket to receive the userTypingUpdate notifications from the server
        socket.on("userTypingUpdate") { (dataArray, ack) in
            guard let typingUsers = dataArray[0] as? [String:String] else {return}
            completiionHandler(typingUsers)
            
        }
    }
    
}
