//
//  LoginVC.swift
//  app-Smack
//
//  Created by James Ullom on 9/6/18.
//  Copyright © 2018 Hammer of the Gods Software. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet var emailTxt: UITextField!
    @IBOutlet var passwordTxt: UITextField!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    @IBAction func closePressed(_ sender: Any) {
        // Closes the current VC and returns to the VC that called it
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccountBtnPressed(_ sender: Any) {
        // Enacts the segue to show the CreateAccountVC
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }
   
    @IBAction func loginBtnPressed(_ sender: Any) {
    
        // Show the spinner and begin its animation
        startSpinner(isActive: true)
        
        // Using Guard Let allows for protection against optional variables being nil (unwrapped as "" for string).  If the guard let is successful, the var is set and usable throughout the function.  If it is unsuccessful we perform a quick exit (return) from the function.  The guard let is an improvement on the older "if let" syntax.
        guard let email = emailTxt.text, emailTxt.text != "" else { return }
        guard let password = passwordTxt.text, passwordTxt.text != "" else { return }
        
        // Calling thre AuthServoice's registerUser function with a completion function for "success"
        AuthService.instance.loginUser(email: email, password: password, completion: { (success) in
            if success {
                print("logged in user!", AuthService.instance.authToken)
                AuthService.instance.findUserByEmail(completion: { (success) in
                    if success {

                        // Needed to place this code here, if placed at the end it does not wait for the code calls to finish
                        self.startSpinner(isActive: false)
                        
                        // Telling notification center that the user data has changed - added a N
                        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                        
                        // Close this window as it was opened by the ChannelVC
                        self.dismiss(animated: true, completion: nil)

                    }
                })
            }
        })
    }
    
    func setupView() {
        emailTxt.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedStringKey.foregroundColor:SMACK_PURPLE_PLACEHOLDER])
                
        passwordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor:SMACK_PURPLE_PLACEHOLDER])
        
        spinner.isHidden = true
    }

func startSpinner(isActive: Bool) {
    
    if isActive {
        spinner.isHidden = false
        spinner.startAnimating()
    } else {
        spinner.stopAnimating()
        spinner.isHidden = true
    }
}

}
