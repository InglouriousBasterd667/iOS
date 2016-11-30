

import UIKit

class CalculatorViewController: UIViewController {
    
    
    @IBOutlet private weak var display: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var graphButton: UIButton!
    
    private var userInMiddleOfTyping = false
    private var brain:CalculatorBrain!  
    private let formatter:NumberFormatter = NumberFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.maximumFractionDigits = 3
        self.brain = CalculatorBrain(formatter)
        graphButton.isEnabled = false
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationvc = segue.destination.childViewControllers[0]
        if let graphvc = destinationvc as? GraphViewController{
            graphvc.navigationItem.title = brain.description
            graphvc.graphFunc = {[weak weakSelf = self] x in
                weakSelf?.brain.variableValues["X"] = x
                return (weakSelf?.brain?.result)!
            }
        }
        
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
    
    
    @IBAction private func perform(_ sender: UIButton) {
        if userInMiddleOfTyping{
            if let numberOnScreen = displayValue{
                brain.setOperand(numberOnScreen)
                userInMiddleOfTyping = false
            }
        }
        if let mathematicalSymbol = sender.currentTitle{
            brain.perform(operation: mathematicalSymbol)
        }
        descriptionLabel.text = brain.description + (brain.isPartialResult ? "..." : "=")
        displayValue = brain.result
        graphButton.isEnabled = !brain.isPartialResult
    }
    
    var savedProgram: CalculatorBrain.PropertiesList?
    
    @IBAction func SetVariable(_ sender: UIButton) {
        brain.variableValues["X"] = displayValue
        displayValue = brain.result
        userInMiddleOfTyping = false
    }
    
    @IBAction func AddVariable(_ sender: UIButton) {
        brain.setOperand(variable: sender.currentTitle!)
        displayValue = brain.result
    }
    
    @IBAction func Save() {
        savedProgram = brain.program
    }

    @IBAction func Restore() {
        if savedProgram != nil{
            brain.program = savedProgram!
            displayValue = brain.result
            
        }
    }
    
    @IBAction func Delete(_ sender: AnyObject) {
        if userInMiddleOfTyping{
            Backspace()
        }
        else{
            brain.Undo()
            if brain.isPartialResult{
                descriptionLabel.text = brain.description + "..."
                
            }
            else{
                descriptionLabel.text = brain.description + "="
                brain.isPartialResult = true
            }
            displayValue = brain.result
        }
    }
    
    private func Backspace(){
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
        graphButton.isEnabled = false
    }
}

