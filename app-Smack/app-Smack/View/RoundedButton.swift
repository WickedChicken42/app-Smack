//
//  RoundedButton.swift
//  app-Smack
//
//  Created by James Ullom on 9/12/18.
//  Copyright © 2018 Hammer of the Gods Software. All rights reserved.
//

import UIKit

// Using @IBDesignable to make this button class play nice in the Designer so we can see the rounding in realtime
@IBDesignable
class RoundedButton: UIButton {
    
    // Using @IBInspectable enables the radius value to be set in the Designer
    @IBInspectable var cornerRadius: CGFloat = 5.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    // Required to implement
    override func awakeFromNib() {
        self.setupView()
    }
    
    // Required to implement
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupView()
    }
    
    // Defining the functiont that sets the button's frame radius that the other required class functions will call
    func setupView() {
        self.layer.cornerRadius = cornerRadius
    }
}
