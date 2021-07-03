//
//  ViewController.swift
//  Tip Calculator
//
//  Created by Shane Talbert on 2/23/20.
//  Copyright © 2020 Shane Talbert. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, SettingsUpdate {
    

    @IBOutlet weak var lblCheckAmount: UILabel!
    @IBOutlet weak var lblTipAmount: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblTipPercent: UILabel!
    
    var audioPlayer: AVAudioPlayer!
    
    var total: Double = 0.0
    var checkAmount: Double = 0.0
    var decHasBeenPressed: Bool = false
    
    //Will change based on Options in load and when returning from settings
    var roundBy: RoundedValue = .twentyFive
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        lblCheckAmount.text = ""
        lblTotal.text = ""
        lblTipAmount.text = ""
        
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
        print("Transfer to other screen")
        
        performSegue(withIdentifier: "settings", sender: self)
        
        //When the Settings VC is dismissed need to see if the settings have changed.
        print("When does this fire??? Settings pressed......")
        //Does not return here...
        
    }
    
    func updateSettings(value: RoundedValue) {
        //This is what will be called when the settings panel is dismissed.
        //Assign the value returned to the amount to round by
        
        print("Returned to main view controller value that I got back is \(value)")
        roundBy = value
    }
    
    @IBAction func numberPressed(_ sender: UIButton) {
        
        //Will only allow 1 . to be pressed
        
        let x = sender.titleLabel?.text
        
        if x == "." {
            if decHasBeenPressed == false {
                lblCheckAmount.text = lblCheckAmount.text! + "."
                decHasBeenPressed = true
            }
            
        }
        
        
        if let myNum = x {
            //have to convert the string to an int
            if let actualNumber = Int(myNum) {
                lblCheckAmount.text = lblCheckAmount.text! + String(actualNumber)
                //See if the string value in text box can be converted to a Double?
                if let properCheckAmount = Double(lblCheckAmount.text!) {
                    checkAmount = properCheckAmount
                }
            }
        }
        
        //Starts the tip value as close as 18% as possible while rounding to the nearest .25
        calculateInfo(currentValue: 0.18)
        
        playSound()
   
        
    }
    
    @IBAction func clearPressed(_ sender: UIButton) {
        
        lblCheckAmount.text = ""
        lblTipAmount.text = ""
        lblTotal.text = ""
        total = 0
        checkAmount = 0
        decHasBeenPressed = false

    }
    
    
    @IBAction func tipChanged(_ sender: UISlider) {
        
        let sliderValue = Double(sender.value)
        calculateInfo(currentValue: sliderValue)
    
    }
    
    
    func calculateInfo(currentValue: Double){
        
        //calculate the tip
        let tipAmount = checkAmount * currentValue
        
        //now that we have the tip amount need to round up the amount and use this rounded up number for displaying new total and tip along with what the tip % would be...
        
        //let roundedUpTip = roundUpNumber(originalNumber: tipAmount)
        let roundedUpTip = RoundedTipHelper.roundUpValue(valueToRound: tipAmount, roundBy: roundBy)
        
        //set the display based on the rounded up tip
        
        total = checkAmount + roundedUpTip
        
        lblTipAmount.text = String.init(format: "Tip $%.2f", roundedUpTip)
        lblTotal.text = String.init(format: "Total $%.2f", total)
        //this isn't accurate, but close
        //calculate and then display the true tip percentage based on the rounded up value
        let tipPercentage = roundedUpTip / checkAmount
        lblTipPercent.text = String.init(format: "Tip %%%.1f", (tipPercentage * 100))
        
    }
    
}

