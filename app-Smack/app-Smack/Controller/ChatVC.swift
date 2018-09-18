//
//  ChatVC.swift
//  app-Smack
//
//  Created by James Ullom on 8/31/18.
//  Copyright © 2018 Hammer of the Gods Software. All rights reserved.
//

import UIKit

// USING SWRevealViewController
// To make this work, the front (this one) showing VC's segue from the root VC to this one MUST be named "sw_front" so that the SWRevealViewController knows it.

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var menuBtn: UIButton!
    @IBOutlet var channelNameLbl: UILabel!
    @IBOutlet var messageTxtbox: UITextField!
    @IBOutlet var sendBtn: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var typingUserLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.bindToKeyboard()

        // Addind the support to clear the keyboard when tapped outside of it
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTap))
        view.addGestureRecognizer(tap)
        
        // Required to support the TableView and the protocols UITableViewDelegate, UITableViewDataSource
        tableView.delegate = self
        tableView.dataSource = self
        
        // Added to support dynamically sized row based on the amount of text in the messageLbl
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        menuBtn.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        // The initial state of the send button should be Hidden
        sendBtn.isHidden = true
        
        // Allows for drag panning of the screen
        view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        // Allows for tapping the screen to close re-slide the screen back
        view.addGestureRecognizer(revealViewController().tapGestureRecognizer())

        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)


        SocketService.instance.getChatMessage { (newMessage) in
            
            if newMessage.channelID == MessageService.instance.selectedChannel?.id && AuthService.instance.isLoggedIn {

                // Add the message to the Messages app
                MessageService.instance.messages.append(newMessage)

                // Reload the data
                self.tableView.reloadData()
                
                // auto-scrolls the view so that the last message is visible at the bottom of the list
                if MessageService.instance.messages.count > 0 {
                    let endIndexPath = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
                    self.tableView.scrollToRow(at: endIndexPath, at: .bottom, animated: false)
                }
            }
        }

//        SocketService.instance.getChatMessage { (success) in
//            if success {
//                self.tableView.reloadData()
//
//                // auto-scrolls the view so that the last message is visible at the bottom of the list
//                if MessageService.instance.messages.count > 0 {
//                    let endIndexPath = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
//                    self.tableView.scrollToRow(at: endIndexPath, at: .bottom, animated: false)
//                }
//            }
//        }
        
        // Gets the users who are typing in their chat app
        SocketService.instance.getTypingUsers { (typingUsers) in
            
            guard let channelID = MessageService.instance.selectedChannel?.id else { return }
            var names = ""
            var numberOfTypers = 0
            
            // Loop through the returned dictionary to access the users and the channel they were tying on
            for (typingUser, channel) in typingUsers {
                // Only interested in people not me in my current channel
                if typingUser != UserDataService.instance.name && channel == channelID {
                    // Add the person to the list
                    if numberOfTypers == 0 {
                        names = typingUser
                    } else {
                        names += ", " + typingUser
                    }
                    numberOfTypers += 1
                }
            }
 
            // Formatting the typing user label text
            if numberOfTypers > 0 && AuthService.instance.isLoggedIn == true {
                var verb = "is"
                if numberOfTypers > 1 { verb = "are"}
                
                self.typingUserLbl.text = names + " " + verb + " typing a message"
            } else {
                self.typingUserLbl.text = ""
            }
        }

        if AuthService.instance.isLoggedIn {
            AuthService.instance.findUserByEmail(completion: { (success) in
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            })
        }
    }

    @objc func handleTap() {
        
        view.endEditing(true)
    }
 
    @objc func userDataDidChange(_ notif: Notification) {
        setupUserInfo()
    }
    
    @objc func channelSelected(_ notif: Notification) {
        updateWithChannel()
    }

    func setupUserInfo() {
        if AuthService.instance.isLoggedIn {
            onLoginGetMessages()
        } else {
            channelNameLbl.text = "Please Log In"
            tableView.reloadData()
        }
    }
    
    func onLoginGetMessages() {
        MessageService.instance.getAllChannels { (success) in
            if success {
                // Performing a retreival of channels. If there are any, retreive the messages of the first channel in the list
                // ** Dumb Workflow, it should save a last selected channel and update with that data
                if MessageService.instance.channels.count > 0 {
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    self.updateWithChannel()
                } else {
                    self.channelNameLbl.text = "No channels available"
                }
            }
        }
    }
    
    func updateWithChannel() {
        let channelName = MessageService.instance.selectedChannel?.channelTitle ?? ""
        channelNameLbl.text = "#" + channelName
        getMessages()
    }
    
    func getMessages() {
        guard let channelID = MessageService.instance.selectedChannel?.id else { return }
        MessageService.instance.findAllMessagesForChannel(channelID: channelID) { (success) in
            if success {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func sendMessagePressed(_ sender: Any) {
    
        if AuthService.instance.isLoggedIn {
            guard let channelID = MessageService.instance.selectedChannel?.id else { return }
            guard let message = messageTxtbox.text else { return }
            SocketService.instance.addMessage(messageText: message, userID: UserDataService.instance.id, channelID: channelID) { (success) in
                if success {
                    self.messageTxtbox.text = ""
                    self.messageTxtbox.resignFirstResponder()
                    
                    // Send the socket message that we have stopped typing due to having sent the message
                    SocketService.instance.socket.emit("stopType", UserDataService.instance.name, channelID)
                }
            }
            
        }
        
    }
    
    // Required to support the TableView and the protocols UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageCell {
            let message = MessageService.instance.messages[indexPath.row]
            cell.configureCell(messageItem: message)
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
    
    // Required to support the TableView and the protocols UITableViewDelegate, UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Required to support the TableView and the protocols UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }
    
    // Adding support to only show the Send button if the user is typing a message
    // Added the ability to emit the start and stop notifications to the server that we are typing (or not) so that it can be sent to other chatters
    @IBAction func messageBoxEditing(_ sender: Any) {
        
        guard let channelID = MessageService.instance.selectedChannel?.id else {return}
        
        if messageTxtbox.text == "" {
            sendBtn.isHidden = true
            SocketService.instance.socket.emit("stopType", UserDataService.instance.name, channelID)
        } else {
            sendBtn.isHidden = false
            SocketService.instance.socket.emit("startType", UserDataService.instance.name, channelID)
        }
    }
    
}
