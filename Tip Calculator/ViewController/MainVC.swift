//
//  ViewController.swift
//  Tip Calculator
//
//  Created by Shane Talbert on 2/23/20.
//  Copyright © 2020 Shane Talbert. All rights reserved.
//

import UIKit
import AVFoundation

class MainVC: UIViewController, AVAudioPlayerDelegate, SettingsUpdate {
    

    //Funny thing Here is I changed the type to calculator Label after the fact. Not sure if it will cause issues.
    @IBOutlet weak var lblCheckAmount: UILabel!
    @IBOutlet weak var lblTipAmount: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblTipPercent: UILabel!
    @IBOutlet weak var lblSplitCheckInfo: CalculatorLabel!
    
    
    var audioPlayer: AVAudioPlayer!
    
    var total: Double = 0.0
    var checkAmount: Double = 0.0
    var decHasBeenPressed: Bool = false
    var checkSplit: Int = 1
    var currentTip: Double = 0.18
    
    
    //Will change based on Options in load and when returning from settings
    var roundBy: RoundedValue = .twentyFive
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearCalculation()
        
        loadUserSettings()
        
    }
    
    func loadUserSettings() {
        //Will load user settings only when the view did load
        let lastSelectedRoundingValue = UserDefaults.standard.object(forKey: "roundingUnits")
        
        if let verifiedLastRoundingValue = lastSelectedRoundingValue as? Int {
            roundBy = RoundedValue(rawValue: Int(verifiedLastRoundingValue))!
        }
        
        
    }
    
    
    func playSound() {
        //let soundURL = Bundle.main.url(forResource: "waterdrop", withExtension: "wav")
        let path = Bundle.main.path(forResource: "waterdrop", ofType: "wav")!
        let soundURL = URL(fileURLWithPath: path)
        //Bundle.main.url(forAuxiliaryExecutable: "waterdrop")
        //print(soundURL)
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer.play()
        } catch {
            print("the error is in the sound area \(error)")
        }
        
    }
    
    @IBAction func splitCheckValChanged(_ sender: UIStepper) {
        
        let stepper = Int(sender.value)
        print("Value of the stepper changed. Value is now \(stepper)")
        //Stepper can only go between 1 and 20 controlled by storyboard
        checkSplit = stepper
        calculateInfo(currentValue: currentTip)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //will send over the current setting so the wheel can start in appropriate position
        if segue.identifier == "settings" {
            if let destination = segue.destination as? SettingsVC {
                destination.startingRoundVal = roundBy
                
                //assign the delegagte
                destination.delegate = self
                
            }
        }
    }
    
    @IBAction func settingsPressed() {
        //Will need to seague from this screen to the settings.
        performSegue(withIdentifier: "settings", sender: self)
        
        //When the Settings VC is dismissed updateSettings will be called.
        
    }
    
    func updateSettings(value: RoundedValue) {
        //This is what will be called when the settings panel is dismissed.
        //Assign the value returned to the amount to round by
        roundBy = value
    }
    
    @IBAction func numberPressed(_ sender: UIButton) {
        
        let x = sender.titleLabel?.text
        
        //Will only allow One . to be pressed
        if x == "." {
            if decHasBeenPressed == false {
                lblCheckAmount.text = lblCheckAmount.text! + "."
                decHasBeenPressed = true
            }
            
        }
        
        //Building the check amount 1 digit at a time
        if let myNum = x {
            //Checking if the string value can convert the string to an int.
            if let actualNumber = Int(myNum) {
                lblCheckAmount.text = lblCheckAmount.text! + String(actualNumber)
                print(checkAmount)
                //See if the string value in text box can be converted to a Double?
                //if let properCheckAmount = Double(lblCheckAmount.text!) {
                 //   checkAmount = properCheckAmount
                //}
            }
        }
        // End function *************************
        
        checkAmount = ConverterHelper.stringConverter(startingString: lblCheckAmount.text!)
        calculateInfo(currentValue: currentTip)
        //Starts the tip value as close as 18% as possible while rounding to the nearest .25
        //calculateInfo(currentValue: currentTip)
        
        playSound()
   
        
    }
    
    @IBAction func clearPressed(_ sender: UIButton) {
        
        clearCalculation()

    }
    
    func clearCalculation() {
        
        lblCheckAmount.text = ""
        lblTipAmount.text = ""
        lblTotal.text = ""
        //This causes a weird bug, collapes the area to nothing.
        //lblSplitCheckInfo.text = ""
        total = 0
        checkAmount = 0
        decHasBeenPressed = false
        
    }
    
    
    @IBAction func tipChanged(_ sender: UISlider) {
        
        let sliderValue = Double(sender.value)
        currentTip = sliderValue
        calculateInfo(currentValue: sliderValue)
    
    }
    
    
    func calculateInfo(currentValue: Double){
        
        //calculate the tip
        let tipAmount = checkAmount * currentValue
        
        //now that we have the tip amount need to round up the amount and use this rounded up number for displaying new total and tip along with what the tip % would be...
        let roundedUpTip = RoundedTipHelper.roundUpValue(valueToRound: tipAmount, roundBy: roundBy)
        total = checkAmount + roundedUpTip
        
        //math to figure out how many ways bill gets split
        let splitRoundedUpTip = roundedUpTip / Double(checkSplit)
        total = total / Double(checkSplit)
        
        //Trying to make it so that it displays the current amount as a $ amount????
        //lblCheckAmount.text = String.init(format: "Check Amount $%.2f", checkAmount)
        
        lblTipAmount.text = String.init(format: "Tip $%.2f each", splitRoundedUpTip)
        lblTotal.text = String.init(format: "Total $%.2f each", total)
        //this isn't accurate, but close
        //calculate and then display the true tip percentage based on the rounded up value
        let tipPercentage = roundedUpTip / checkAmount
        
        lblTipPercent.text = String.init(format: "Tip %%%.1f", (tipPercentage * 100))
        
        //Now to work on splitting the check up. Will just keep it simple and divide the tip and the total by the amount each person should pay.
        lblSplitCheckInfo.text = "split check \(checkSplit) ways"
        
        
        
    }
    
    
}

