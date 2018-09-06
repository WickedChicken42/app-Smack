//
//  LoginVC.swift
//  app-Smack
//
//  Created by James Ullom on 9/6/18.
//  Copyright © 2018 Hammer of the Gods Software. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
   

}
