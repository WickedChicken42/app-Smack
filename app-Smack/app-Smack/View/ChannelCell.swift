//
//  ChannelCell.swift
//  app-Smack
//
//  Created by James Ullom on 9/14/18.
//  Copyright © 2018 Hammer of the Gods Software. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell {

    @IBOutlet var channelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if selected {
            // Set the background of the selected cell with nearly clear white color
            self.layer.backgroundColor = UIColor(white: 1, alpha: 0.2).cgColor
        } else {
            // Set the background of the not selected cell with completley clear color
            self.layer.backgroundColor = UIColor.clear.cgColor
        }
    }

    func configureCell(channel: Channel) {
        
        let title = channel.channelTitle ?? ""
        channelName.text = "#" + title
        
        // Checking to see of this channel is in the unreadChannels list, if so change the font to indicaste there are unread messages
        channelName.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        for id in MessageService.instance.unreadChannels {
            if id == channel.id {
                channelName.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
            }
            
        }
    }
}
