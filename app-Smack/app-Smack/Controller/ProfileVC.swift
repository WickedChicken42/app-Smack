//
//  ProfileVC.swift
//  app-Smack
//
//  Created by James Ullom on 9/13/18.
//  Copyright © 2018 Hammer of the Gods Software. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet var profileImg: CircleImage!
    @IBOutlet var userNameTxt: UILabel!
    @IBOutlet var userEmailTxt: UILabel!
    @IBOutlet var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }

    @IBAction func logoutPressed(_ sender: Any) {
        AuthService.instance.logoutUser()
        
        // Telling notification center that the user data has changed - added a N
        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)

        self.dismiss(animated: true, completion: nil)

    }

    @IBAction func closeModalPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    func setupView() {
        
        userNameTxt.text = UserDataService.instance.name
        userEmailTxt.text = UserDataService.instance.email
        profileImg.image = UIImage(named: UserDataService.instance.avatarName)
        profileImg.backgroundColor = UserDataService.instance.avatarUIColor
     
        // Setup a gesture recognizer to allow us to react to a tap so that we can close the keyboard if open
        let tap = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.handleTap))
        bgView.addGestureRecognizer(tap)
    }
    
    // Defined to hanlde the tap action and hides the keyboard if its open
    @objc func handleTap() {
        self.dismiss(animated: true, completion: nil)
    }

}
