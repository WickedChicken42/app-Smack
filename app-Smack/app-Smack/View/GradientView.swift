//
//  GradientView.swift
//  app-Smack
//
//  Created by James Ullom on 8/31/18.
//  Copyright © 2018 Hammer of the Gods Software. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {

    // The @IBInspectable allows the variable to be editable in the UI Designer
    @IBInspectable var topColor: UIColor = UIColor.blue {
        didSet {
            self.setNeedsLayout()
            
        }
    }
    
    // The @IBInspectable allows the variable to be editable in the UI Designer
    @IBInspectable var bottomColor: UIColor = UIColor.green  {
        didSet {
            self.setNeedsLayout()
            
        }
    }

    override func layoutSubviews() {
        // Define a gradiant layer to be added to the View
        let gradientLayer = CAGradientLayer()
        // Can add as many colors to the array as we want, not limited to two
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        // Defines a diagonal gradiant
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        // Defines a vertical gradiant
        //gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        //gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.frame = self.bounds
        
        // Adding our new Layer to the View
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
