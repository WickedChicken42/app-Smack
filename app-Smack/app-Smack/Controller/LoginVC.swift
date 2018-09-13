//
//  LoginVC.swift
//  app-Smack
//
//  Created by James Ullom on 9/6/18.
//  Copyright © 2018 Hammer of the Gods Software. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet var userNameTxt: UITextField!
    @IBOutlet var passwordTxt: UITextField!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    }
    
    func setupView() {
        userNameTxt.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedStringKey.foregroundColor:SMACK_PURPLE_PLACEHOLDER])
                
        passwordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor:SMACK_PURPLE_PLACEHOLDER])
        
        spinner.isHidden = true
    }


}
