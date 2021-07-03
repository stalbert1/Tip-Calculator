//
//  CalculatorButton.swift
//  Tip Calculator
//
//  Created by Shane Talbert on 7/3/21.
//  Copyright © 2021 Shane Talbert. All rights reserved.
//

import UIKit

class CalculatorButton: UIButton {

    override func awakeFromNib() {
        
        self.layer.cornerRadius = 15.0
        self.backgroundColor = ColorSwatch.lightBrown
        self.setTitleColor(ColorSwatch.white, for: .normal)
        self.clipsToBounds = true
    }
     

}
