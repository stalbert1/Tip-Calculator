//
//  BaseView.swift
//  Tip Calculator
//
//  Created by Shane Talbert on 7/3/21.
//  Copyright © 2021 Shane Talbert. All rights reserved.
//

import UIKit

class BaseView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = ColorSwatch.white
    }
    

}
