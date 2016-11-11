

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet private weak var display: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var userInMiddleOfTyping = false
    private var brain:CalculatorBrain
    private let formatter:NumberFormatter = NumberFormatter()
    
    required init?(coder aDecoder: NSCoder) {
        self.brain = CalculatorBrain(formatter)
        super.init(coder: aDecoder)
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.maximumFractionDigits = 3
    }
    
    
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
            display.text = formatter.string(from: NSNumber(value: newValue!))
        }
    }
    
    
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
        brain = CalculatorBrain(formatter)
        userInMiddleOfTyping = false
        display.text = "0"
        descriptionLabel.text = ""
    }
}

