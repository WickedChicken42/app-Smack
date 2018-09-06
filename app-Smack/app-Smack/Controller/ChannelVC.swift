//
//  ChannelVC.swift
//  app-Smack
//
//  Created by James Ullom on 8/31/18.
//  Copyright © 2018 Hammer of the Gods Software. All rights reserved.
//

import UIKit

// USING SWRevealViewController
// To make this work, the rear (this one) showing VC's segue from the root VC to this one MUST be named "sw_rear" so that the SWRevealViewController knows it.

class ChannelVC: UIViewController {

    @IBOutlet var loginBtn: UIButton!
    // Defined this function so that we could unwind from the CreateAccountVC back to here.  After this line is added you need to Contrl-drag from the VC's yellow dot to the Exit square and select this func
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        revealViewController().rearViewRevealWidth = view.frame.size.width - 60
    }

  
    @IBAction func loginBtnPressed(_ sender: Any) {
        // Enacts the segue to show the LoginVC
        performSegue(withIdentifier: TO_LOGIN, sender: nil)
        
    }
    
}
