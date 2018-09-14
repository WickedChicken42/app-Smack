//
//  MessageService.swift
//  app-Smack
//
//  Created by James Ullom on 9/14/18.
//  Copyright © 2018 Hammer of the Gods Software. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService {
    // Setup as a singleton class
    static let instance = MessageService()
    
    // Define the array that will hold our loaded channels
    var channels = [Channel]()
    
    func getAllChannels(completion: @escaping CompletionHandler) {
        
        // Define the header to be used with the Register posting
        let header = [
            "Content-type": "application/json; charset=utf-8",
            "Authorization": "Bearer " + AuthService.instance.authToken
        ]
        
        // No body needed in the GET request
        
        // Create the web request using Alamofire
        // Using responseJSON this time because thats what the request will return JSON data
        Alamofire.request(URL_GET_ALL_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in

            // Handling the response given back and setting the completion handler to True/False as a result
            if response.result.error == nil {
                // *** The SwiftyJSON way to process JSON
                guard let data = response.data else { return }
// The classic Swift 3 way using Swifty
//                if let json = JSON(data: data).array {
//                    for item in json {
//                        let id = item["_id"].stringValue
//                        let name = item["name"].stringValue
//                        let description = item["description"].stringValue
//
//                        // Create the new Channel item, then append it to our array of channels
//                        let channel = Channel(channelTitle: name, chennelDescription: description, id: id)
//                        self.channels.append(channel)
//                    }
//                }

// The new Swift 4 Decodable way - using a model with the JSON elements and computer properites for nice coding
                do {
                    self.channels = try JSONDecoder().decode([Channel].self, from: data)
                } catch let error {
                    debugPrint(error as Any)
                }
                print(self.channels[0].channelTitle)
                
                completion(true)
            } else {

                completion(false)
                debugPrint(response.result.error as Any)
            }
        }

    }
}
