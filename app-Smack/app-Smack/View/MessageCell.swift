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
        
        // ISO 86-01
        // 2017-07-13T21:49:25.590Z
        // YYYY-MM-DDThh:mm:ss.mmm
        guard var isoDate = messageItem.messageTimeStamp else { return }
        // Getting the index starting from the end and backign up 5 spots (2017-07-13T21:49:25)
        let end = isoDate.index(isoDate.endIndex, offsetBy: -5)
        isoDate = isoDate.substring(to: end)
        
        let isoFormatter = ISO8601DateFormatter()
        // Formastting the date while appending the ending Z which is needed but was not included in our substring (2017-07-13T21:49:25Z)
        let chatDate = isoFormatter.date(from: isoDate.appending("Z"))
        
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "MMM d, h:mm a"
        
        if let finalDate = chatDate {
            let finalDate = newFormatter.string(from: finalDate)
            timeStampLbl.text = finalDate
        }
    }
}
