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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        menuBtn.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)

        // Allows for drag panning of the screen
        view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        // Allows for tapping the screen to close re-slide the screen back
        view.addGestureRecognizer(revealViewController().tapGestureRecognizer())
        
        if AuthService.instance.isLoggedIn {
            AuthService.instance.findUserByEmail(completion: { (success) in
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            })
        }
        MessageService.instance.getAllChannels { (success) in
            if success {
                
            }
        }
    }

}
