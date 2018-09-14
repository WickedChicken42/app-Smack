//
//  AddChannelVC.swift
//  app-Smack
//
//  Created by James Ullom on 9/14/18.
//  Copyright © 2018 Hammer of the Gods Software. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {

    @IBOutlet var chanName: UITextField!
    @IBOutlet var chanDesc: UITextField!
    @IBOutlet var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
   
    @IBAction func closeModalPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createChannelPressed(_ sender: Any) {
        
        // Get the values we want to send to the server
        guard let channelName = chanName.text, chanName.text != "" else { return }
        guard let channelDesc = chanDesc.text, chanDesc.text != "" else { return }
        
        // Emit the new channel to be created on the server
        SocketService.instance.addChannel(channelName: channelName, channelDesc: channelDesc) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    func setupView() {
        
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(AddChannelVC.closeTap(_:)))
        bgView.addGestureRecognizer(closeTouch)
        
        // Set the placeholder text to the color purple
        chanName.attributedPlaceholder = NSAttributedString(string: "name", attributes: [NSAttributedStringKey.foregroundColor : SMACK_PURPLE_PLACEHOLDER])
        chanDesc.attributedPlaceholder = NSAttributedString(string: "description", attributes: [NSAttributedStringKey.foregroundColor : SMACK_PURPLE_PLACEHOLDER])

    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
