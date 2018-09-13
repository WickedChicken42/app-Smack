//
//  AvatarCell.swift
//  app-Smack
//
//  Created by James Ullom on 9/12/18.
//  Copyright © 2018 Hammer of the Gods Software. All rights reserved.
//

import UIKit

enum AvatarType {
    case dark
    case light
}
class AvatarCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarImg: UIImageView!
    
    // Needed to be able to do things when this object first started up.  A call to SUPER is required first
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    // Defining the look of the cell
    func setupView() {
        self.layer.backgroundColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        avatarImg.contentMode = .scaleAspectFit
    }
    
    func configureCell(index: Int, type: AvatarType) {
        if type == AvatarType.dark {
            avatarImg.image = UIImage(named: "dark\(index)")
            self.layer.backgroundColor = UIColor.lightGray.cgColor
        } else {
            avatarImg.image = UIImage(named: "light\(index)")
            self.layer.backgroundColor = UIColor.gray.cgColor
        }
    }
}
