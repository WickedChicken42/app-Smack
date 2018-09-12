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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    }

    @IBAction func chooseBGColorPressed(_ sender: Any) {
    }

    @IBAction func createAccountPressed(_ sender: Any) {
 
        // Using Guard Let allows for protection against optional variables being nil (unwrapped as "" for string).  If the guard let is successful, the var is set and usable throughout the function.  If it is unsuccessful we perform a quick exit (return) from the function.  The guard let is an improvement on the older "if let" syntax.
        guard let email = userEmailTxt.text, email != "" else { return }
        guard let password = userPasswordTxt.text, password != "" else { return }
        
        // Calling thre AuthServoice's registerUser function with a completion function for "success"
        AuthService.instance.registerUser(email: email, password: password) { (success) in
            if success {
                AuthService.instance.loginUser(email: email, password: password, completion: { (success) in
                    if success {
                        print("logged in user!", AuthService.instance.authToken)
                    }
                })
                print("registered user")
            }
        }
    }
    
    func loginUser() {
        
    }
    
}
