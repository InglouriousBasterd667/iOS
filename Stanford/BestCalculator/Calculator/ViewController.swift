

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet private weak var display: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
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
        if displayValue == nil{
            display.text = ""
            userInMiddleOfTyping = false
        }
        else{
            userInMiddleOfTyping = true
        }
        
    }
    
    private var displayValue: Double? {
        get{
            return Double(display.text!)
        }
        set{
            var formatter:NumberFormatter = NumberFormatter()
            formatter.usesSignificantDigits = true
            
            display.text = String(newValue!)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(_ sender: AnyObject) {
        
        if userInMiddleOfTyping{
            if let numberOnScreen = displayValue{
                brain.setOperand(numberOnScreen)
                userInMiddleOfTyping = false
            }
        }
        if let mathematicalSymbol = sender.currentTitle{
            brain.performOperation(symbol: mathematicalSymbol!)
        }
        if brain.isPartialResult{
            descriptionLabel.text = brain.description + "..."
            
        }
        else{
            descriptionLabel.text = brain.description + "="
            brain.description = ""
            brain.isPartialResult = true
        }
        
        displayValue = brain.result
    }
    
    var savedProgram: CalculatorBrain.PropertiesList?
    
    @IBAction func Save() {
        savedProgram = brain.Program
    }

    @IBAction func Restore() {
        if savedProgram != nil{
            brain.Program = savedProgram!
            displayValue = brain.result
        }
    }
    
    @IBAction func Delete(_ sender: AnyObject) {
        if var displayText = display.text{
            displayText.remove(at: displayText.index(before: displayText.endIndex))
            if displayText.characters.count == 0{
                display.text = "0"
                userInMiddleOfTyping = false
            }
            else{
                display.text = displayText
            }
        }
    }
    
    @IBAction func Clear(_ sender: UIButton) {
        brain = CalculatorBrain()
        userInMiddleOfTyping = false
        display.text = "0"
        descriptionLabel.text = ""
    }
}

