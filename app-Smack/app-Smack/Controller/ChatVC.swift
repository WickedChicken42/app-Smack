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

class ChatVC: UIViewController {

    @IBOutlet var menuBtn: UIButton!
    @IBOutlet var channelNameLbl: UILabel!
    @IBOutlet var messageTxtbox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.bindToKeyboard()
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTap))
        view.addGestureRecognizer(tap)
        
        menuBtn.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)

        // Allows for drag panning of the screen
        view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        // Allows for tapping the screen to close re-slide the screen back
        view.addGestureRecognizer(revealViewController().tapGestureRecognizer())

        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)

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
            // Do Something
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
                }
            }
            
        }
        
    }
    
}
