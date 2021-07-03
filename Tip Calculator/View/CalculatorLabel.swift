//
//  CalculatorLabel.swift
//  Tip Calculator
//
//  Created by Shane Talbert on 7/3/21.
//  Copyright © 2021 Shane Talbert. All rights reserved.
//
//  This label is to be used anywhere in the calculator window where
//  a traditional calculator would display output

import UIKit

class CalculatorLabel: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    //Want to use to change background color of the label to...
    //Light green = 5F939A = cal area

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = ColorSwatch.darkGreen
        self.textColor = ColorSwatch.white
        self.font = UIFont(name: "Courier", size: 24.0)
    }
    
    
    
    

}
