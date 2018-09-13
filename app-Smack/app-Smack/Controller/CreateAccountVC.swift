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
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    var avatarName: String = "profileDefault"
    var avatarColor: String = "[0.5,0.5,1]" // Default light gray color
    var bgColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        if UserDataService.instance.avatarName != "" {
            userImg.image = UIImage(named: UserDataService.instance.avatarName)
            avatarName = UserDataService.instance.avatarName
            if avatarName.contains("light") && bgColor == nil {
                userImg.backgroundColor = UIColor.lightGray
            }
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
        
        let r = CGFloat(arc4random_uniform(255)) / 255
        let g = CGFloat(arc4random_uniform(255)) / 255
        let b = CGFloat(arc4random_uniform(255)) / 255
        bgColor = UIColor(red: r, green: g, blue: b, alpha: 1)

        // Animating the color transition from what was to the new bgColor value
        UIView.animate(withDuration: 0.2) {
            self.userImg.backgroundColor = self.bgColor
        }
        
        avatarColor = "[\(r),\(g),\(b)]"
    }

    @IBAction func createAccountPressed(_ sender: Any) {
 
        // Show the spinner and begin its animation
        startSpinner(isActive: true)
        
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
                                
                                // Needed to place this code here, if placed at the end it does not wait for the code calls to finish 
                                self.startSpinner(isActive: false)
                                
                                // Telling notification center that the user data has changed - added a N
                                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: UserNotificationType.login)
                            }
                        })
                    }
                })
            }
        }
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
    
    func loginUser() {
        
    }
    
    func setupView() {
        userNameTxt.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedStringKey.foregroundColor:SMACK_PURPLE_PLACEHOLDER])

        userEmailTxt.attributedPlaceholder = NSAttributedString(string: "email", attributes:
            [NSAttributedStringKey.foregroundColor:SMACK_PURPLE_PLACEHOLDER])

        userPasswordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor:SMACK_PURPLE_PLACEHOLDER])
 
        startSpinner(isActive: false)
        
        // Setup a gesture recognizer to allow us to react to a tap so that we can close the keyboard if open
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateAccountVC.handleTap))
        view.addGestureRecognizer(tap)
    }

    // Defined to hanlde the tap action and hides the keyboard if its open
    @objc func handleTap() {
        view.endEditing(true)
    }
}

