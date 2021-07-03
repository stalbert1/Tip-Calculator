//
//  RoundedTipHelper.swift
//  Tip Calculator
//
//  Created by Shane Talbert on 6/28/21.
//  Copyright © 2021 Shane Talbert. All rights reserved.
//

import Foundation

enum RoundedValue: Int, CaseIterable {
    case five = 5
    case ten = 10
    case twentyFive = 25
    case fifty = 50
    case dollar = 100
}

class RoundedTipHelper {
    
    //The only use of this class will be to create a static function that accepts a double and chose what to round by, which is the enum RoundedValue
    //7.23 round up 25 would be 7.25
    //7.26 would be 7.50
    //7.77 would be 8.00
    public static func roundUpValue(valueToRound: Double, roundBy: RoundedValue) -> Double {
        
        var returnedAmount: Double = 0.0
        let roundedDownWholeNumber = Int(valueToRound)
        let change = Int((valueToRound - Double(roundedDownWholeNumber)) * 100)
        var roundedUpChange: Int = 0
        
        let loopsNeeded: Int = 100 / roundBy.rawValue
        
        for i in 1 ... loopsNeeded {
            let roundedNum: Int = roundBy.rawValue * i
            let algoVal = roundedNum - change
            //Looking for the first number that is not negative.
            if algoVal > 0 {
                if i == 1 {
                    if algoVal == roundedNum {
                        roundedUpChange = 0
                        break
                    }
                    
                }
                roundedUpChange = roundedNum
                break
            }
        }
        
        //Now the change should be handled, The question is, if it is 100 need to round up to the nearest dollar.
        if roundedUpChange == 100 {
            returnedAmount = Double(roundedDownWholeNumber + 1)
        } else {
            returnedAmount = Double(roundedDownWholeNumber) + ((Double(roundedUpChange)) / 100)
        }
        
        return returnedAmount
        
    }
    
    
    
}
