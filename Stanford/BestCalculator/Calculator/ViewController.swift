//
//  ViewController.swift
//  Calculator
//
//  Created by Mikhail Lyapich on 28.10.16.
//  Copyright © 2016 Mikhail Lyapich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet private weak var display: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    
    private var userInMiddleOfTyping = false
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if(userInMiddleOfTyping){
            let textOnDisplay = display.text!
            if !(textOnDisplay.contains(".") && digit == ".") {
                display.text = textOnDisplay + digit
            }
        }
        else{
            display.text = digit
        }
        userInMiddleOfTyping = true
        
    }
    
    private var displayValue: Double {
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(_ sender: AnyObject) {
        if userInMiddleOfTyping{
            brain.setOperand(displayValue)
            userInMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle{
            brain.performOperation(symbol: mathematicalSymbol!)
        }
        if brain.isPartialResult{
            DescriptionLabel.text = brain.description + "..."
            
        }
        else{
            DescriptionLabel.text = brain.description + "="
            brain.description = ""
            brain.isPartialResult = true
        }
        
        displayValue = brain.result
    }
    
}

