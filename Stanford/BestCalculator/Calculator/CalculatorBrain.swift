//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Mikhail Lyapich on 31.10.16.
//  Copyright © 2016 Mikhail Lyapich. All rights reserved.
//

import Foundation


class CalculatorBrain{
    
    private var accumulator = 0.0
    private var pending: PendingBinaryOperation?
    
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
        "=" : Operation.Equal
    ]

    private enum Operation{
        case Constant(Double)
        case Unary((Double)->Double)
        case Binary((Double, Double)->Double)
        case Equal
    }
    
    private struct PendingBinaryOperation{
        var binaryFunction: (Double,Double)->Double
        var firstOperand: Double
    }
    
    var result: Double{
        get{
            return accumulator
        }
    }
    
    var description: String = ""
    var isPartialResult: Bool = true
    
    func setOperand(_ operand:Double){
        accumulator = operand
//        description += String(operand)
        
    }
    
    private func executePendingOperation(){
        if pending != nil{
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    func performOperation(symbol:String)  {
        if let operation = operations[symbol]{
            switch operation{
            case .Constant(let value):
                accumulator = value
                description += symbol
            case .Unary(let function):
                if isPartialResult{
                    let toAdd = symbol + String(accumulator)
                    description += toAdd
                }
                else{
                    description = symbol + "(\(description))"
                }
                accumulator = function(accumulator)
                isPartialResult = false
            case .Binary(let function):
                if (isPartialResult){
                    description += String(accumulator)
                }
                if symbol == "×"{
                    description = "(\(description))"
                }
                description += symbol
                executePendingOperation()
                pending = PendingBinaryOperation(binaryFunction: function, firstOperand: accumulator)
                isPartialResult = true
            case .Equal:
                if (isPartialResult){
                    description += String(accumulator)
                }
                isPartialResult = false
                executePendingOperation()
            }
        }
    }
    

}
