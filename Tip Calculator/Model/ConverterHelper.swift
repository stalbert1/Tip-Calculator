//
//  ConverterHelper.swift
//  Tip Calculator
//
//  Created by Shane Talbert on 7/5/21.
//  Copyright © 2021 Shane Talbert. All rights reserved.
//

import Foundation

class ConverterHelper {
    
    //This class will have one public static function that is designed
    //to take the output of the check and strip out everything except the decimal place and numbers
    
    public static func stringConverter(startingString: String) -> Double {
        
        var decString = ""
        
        for ch in startingString {
            if (ch == ".") {
                decString = decString + String(ch)
            }
            
            if Int(String(ch)) != nil {
                decString = decString + String(ch)
            }
            
        }
        
        //will need to now convert the decString to decimal
        //if nil will return 0
        let returnedDouble = Double(decString) ?? 0.0
        return returnedDouble
    }

}
