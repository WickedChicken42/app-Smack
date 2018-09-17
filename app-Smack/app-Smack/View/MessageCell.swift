//
//  MessageCell.swift
//  app-Smack
//
//  Created by James Ullom on 9/17/18.
//  Copyright © 2018 Hammer of the Gods Software. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet var userImage: CircleImage!
    @IBOutlet var userNameLbl: UILabel!
    @IBOutlet var timeStampLbl: UILabel!
    @IBOutlet var messageLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(messageItem: Message) {
        
        messageLbl.text =   messageItem.message
        userNameLbl.text = messageItem.name
        userImage.image = UIImage(named: messageItem.avatarName) 
        userImage.backgroundColor = UserDataService.instance.returnUIColor(components: messageItem.avatarColor)
        // Need to find out why this didn't work
        //userImage.backgroundColor = messageItem.avatarUIColor
    }
}
