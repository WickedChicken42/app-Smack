//
//  CreateAccountVC.swift
//  app-Smack
//
//  Created by James Ullom on 9/6/18.
//  Copyright © 2018 Hammer of the Gods Software. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {

    @IBOutlet var userNameTxt: UITextField!
    @IBOutlet var userEmailTxt: UITextField!
    @IBOutlet var userPasswordTxt: UITextField!
    @IBOutlet var userImg: UIImageView!
    
    var avatarName: String = "profileDefault"
    var avatarColor: String = "[0.5,0.5,1]" // Default light gray color
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func viewDidAppear(_ animated: Bool) {
        if UserDataService.instance.avatarName != "" {
            userImg.image = UIImage(named: UserDataService.instance.avatarName)
            avatarName = UserDataService.instance.avatarName
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func closePressed(_ sender: Any) {
        // Created an unwind segue to take us back to the ChannelVC.  Call the performSegue instead of Dismiss to perform the unwind back.
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    
    @IBAction func chooseAvatarPressed(_ sender: Any) {
        
        performSegue(withIdentifier: TO_AVATAR_PICKER, sender: nil)

    }

    @IBAction func chooseBGColorPressed(_ sender: Any) {
    }

    @IBAction func createAccountPressed(_ sender: Any) {
 
        // Using Guard Let allows for protection against optional variables being nil (unwrapped as "" for string).  If the guard let is successful, the var is set and usable throughout the function.  If it is unsuccessful we perform a quick exit (return) from the function.  The guard let is an improvement on the older "if let" syntax.
        guard let name = userNameTxt.text, name != "" else { return }
        guard let email = userEmailTxt.text, email != "" else { return }
        guard let password = userPasswordTxt.text, password != "" else { return }
        
        // Calling thre AuthServoice's registerUser function with a completion function for "success"
        AuthService.instance.registerUser(email: email, password: password) { (success) in
            if success {
                print("registered user")
                AuthService.instance.loginUser(email: email, password: password, completion: { (success) in
                    if success {
                        print("logged in user!", AuthService.instance.authToken)
                        AuthService.instance.createUser(name: name, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor, completion: { (success) in
                            if success {
                                print(UserDataService.instance.name, UserDataService.instance.avatarName)
                                self.performSegue(withIdentifier: UNWIND, sender: nil)
                            }
                        })
                    }
                })
            }
        }
    }
    
    func loginUser() {
        
    }
    
}
