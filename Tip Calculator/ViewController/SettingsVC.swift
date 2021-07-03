//
//  SettingsVC.swift
//  Tip Calculator
//
//  Created by Shane Talbert on 6/29/21.
//  Copyright © 2021 Shane Talbert. All rights reserved.
//

import UIKit

protocol SettingsUpdate {
    func updateSettings(value: RoundedValue)
}

class SettingsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    @IBOutlet weak var pickerTipRound: UIPickerView!
    
    let tipRoundingUnits = ["5", "10", "25", "50", "100"]
    
    //This value will be passed in and will be the starting value
    var startingRoundVal: RoundedValue?
    var delegate: SettingsUpdate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("SettingsVC did load")
        pickerTipRound.delegate = self
        pickerTipRound.dataSource = self
        
        //Set picker wheel to starting value
        //print("The starting value is \(String(describing: startingRoundVal))")
        //need to determine if starting value is not nil
        if startingRoundVal != nil {
            for i in 0 ..< tipRoundingUnits.count {
                if startingRoundVal!.rawValue == Int(tipRoundingUnits[i]) {
                    pickerTipRound.selectRow(i, inComponent: 0, animated: true)
                }
                
            }
            
        }
        
        
    }
    
    
    @IBAction func returnSelected() {
        
        //Need to store the selection as a default
        
        
        //will dismiss this view controller
        dismiss(animated: true, completion: nil)
    }
    
    
    //Picker View boilerplate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        // Would like to use the amount of items in the Rounded Value Enum, but hard coding for now RoundedValue.dollar
        //RoundedValue.allCases.count
        
        return tipRoundingUnits.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return tipRoundingUnits[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        print("Did select row \(row). The value is \(tipRoundingUnits[row])")
        
        //let possiblePlanet = Planet(rawValue: 7)
        //force unwrapped here ????
        
        //How to go from Int value to actual Enum
        let possibleValue = RoundedValue(rawValue: Int(tipRoundingUnits[row])!)
        
        
        let numChoices = RoundedValue.allCases.count
        print("The value would be \(String(describing: possibleValue))There are \(numChoices) number of choices in RoundedValue Enum")
        //Now the key becomes how to save this to defaults. Defaults dont save custom types.
        //Can save the default as an int. Then when decoding can use the raw value as above.
        
        //Storing the selection in User Defaults
        let selectedVal = Int(tipRoundingUnits[row])
        print("The selected value to store is \(String(describing: selectedVal))")
        UserDefaults.standard.set(selectedVal, forKey: "roundingUnits")
        
        //If its nill will round by twenty five
        delegate?.updateSettings(value: possibleValue ?? RoundedValue.twentyFive)
    }
    
    
}
