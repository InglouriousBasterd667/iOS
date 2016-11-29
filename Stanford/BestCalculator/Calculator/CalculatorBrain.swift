//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Mikhail Lyapich on 31.10.16.
//  Copyright © 2016 Mikhail Lyapich. All rights reserved.
//

import Foundation
import UIKit

class CalculatorBrain{
    
    private var accumulator = 0.0
    private var internalProgram = [AnyObject]()
    private var pending: PendingBinaryOperation?
    private var formatter: NumberFormatter
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "√" : Operation.Unary(sqrt),
        "cos" : Operation.Unary(cos),
        "sin" : Operation.Unary(sin),
        "tg" : Operation.Unary(tan),
        "arcsin" : Operation.Unary(asin),
        "arcos" : Operation.Unary(acos),
        "+" : Operation.Binary({ $0 + $1 }),
        "-" : Operation.Binary({ $0 - $1 }),
        "×" : Operation.Binary({ $0 * $1 }),
        "÷" : Operation.Binary({ $0 / $1 }),
        "pow" : Operation.Binary({ pow($0, $1) }),
        "rand" : Operation.Random,
        "X" : Operation.Variable,
        "y" : Operation.Variable,
        "M" : Operation.Variable,
        "=" : Operation.Equal
    ]

    private enum Operation{
        case Constant(Double)
        case Unary((Double)->Double)
        case Binary((Double, Double)->Double)
        case Variable
        case Random
        case Equal
    }
    
    private struct PendingBinaryOperation{
        var binaryFunction: (Double,Double)->Double
        var firstOperand: Double
    }
    
    var variableValues = [String:Double](){
        didSet{
            program = internalProgram as CalculatorBrain.PropertiesList
        }
    }
    
    var result: Double{
        get{
            return accumulator
        }
    }
    
    typealias PropertiesList = AnyObject
    
    var program: PropertiesList{
        get{
            return internalProgram as CalculatorBrain.PropertiesList
        }
        set{
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand)
                    } else if let symbol = op as? String {
                        if operations[symbol] != nil {
                            perform(operation: symbol)
                        } else {
                            setOperand(variable: symbol)
                        }
                        
                    }
                }
            }
        }
    }
    
    var description: String = ""
    var isPartialResult: Bool = true
    
    required init(_ formatter:NumberFormatter){
        self.formatter = formatter
    }
    
    func eval(x: CGFloat) -> CGFloat{
        return 0.0
    }
    
    func clear(){
        description = ""
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll(keepingCapacity: false)
    }
    
    func setOperand(_ operand:Double){
        accumulator = operand
        description += formatter.string(from:NSNumber (value: accumulator))!
        internalProgram.append(operand as AnyObject)
    }

    func setOperand(variable: String){
        accumulator = variableValues[variable] ?? 0.0
        description += variable
        internalProgram.append(variable as AnyObject)
    }
    
    
    
    private func executePendingOperation(){
        if pending != nil{
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    func Undo(){
        if internalProgram.count > 0{
            internalProgram.removeLast()
            program = internalProgram as CalculatorBrain.PropertiesList
        }
    }
    
    func perform(operation symbol:String)  {
        if let operation = operations[symbol]{
            internalProgram.append(symbol as AnyObject)
            switch operation{
            case .Constant(let value):
                accumulator = value
                description += symbol
            case .Unary(let function):
                if !isPartialResult{
                    //let toAdd = symbol + formatter.string(from:NSNumber (value: accumulator))!
                    //description += toAdd
                    description = symbol + "(\(description))"
                }
                accumulator = function(accumulator)
                isPartialResult = false
            case .Binary(let function):
                if symbol == "×"{
                    description = "(\(description))"
                }
                description += symbol
                executePendingOperation()
                pending = PendingBinaryOperation(binaryFunction: function, firstOperand: accumulator)
                isPartialResult = true
            case .Random:
                accumulator = drand48()
                description += formatter.string(from:NSNumber (value: accumulator))!
            case .Variable:
                accumulator = variableValues[symbol] ?? 0.0
            case .Equal:
                isPartialResult = false
                executePendingOperation()
            }
        }
    }
    

}
