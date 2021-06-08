//
//  ViewController.swift
//  Tip Calculator
//
//  Created by Shane Talbert on 2/23/20.
//  Copyright © 2020 Shane Talbert. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var lblCheckAmount: UILabel!
    @IBOutlet weak var lblTipAmount: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblTipPercent: UILabel!
    
    var audioPlayer: AVAudioPlayer!
    
    var total: Double = 0.0
    var checkAmount: Double = 0.0
    var decHasBeenPressed: Bool = false
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lblCheckAmount.text = ""
        lblTotal.text = ""
        lblTipAmount.text = ""
        
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
    

    func roundUpNumber(originalNumber: Double) -> Double {
        
        var returnedNumber: Double = 0.0
        
        let roundedDownNumber = Int(originalNumber)
        let change = Int((originalNumber - Double(roundedDownNumber)) * 100)
        
        var roundedUpChange: Int = 0
        
        if change == 0 {
               roundedUpChange = 0
           }
           if change > 0 && change < 26 {
               roundedUpChange = 25
           }
           if change > 25 && change < 51 {
               roundedUpChange = 50
           }
           if change > 50 && change < 76 {
               roundedUpChange = 75
           }
           if change > 75 {
               roundedUpChange = 100
           }
        
        if roundedUpChange == 100 {
            //add 1$ to the rounded down tip amount and return with .00
            //4.99 , 4 + 1 = 5.00
            returnedNumber = Double(roundedDownNumber + 1)
        } else {
            //take the int and divide be 100 25 would be .25 and add to the rounded down tipAmt
            returnedNumber = Double(roundedDownNumber)  + ((Double(roundedUpChange)) / 100)
        }
        
        return returnedNumber
    }

    @IBAction func numberPressed(_ sender: UIButton) {
        
        //Will only allow 1 . to be pressed
        
        //need to add a sound when a key is pressed
        //let sound = AVPlayer
        
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
        
        let roundedUpTip = roundUpNumber(originalNumber: tipAmount)
        
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

