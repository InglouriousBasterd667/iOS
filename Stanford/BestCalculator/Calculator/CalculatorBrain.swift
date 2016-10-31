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
    
    func setOperand(_ operand:Double){
        accumulator = operand
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "√" : Operation.Unary(sqrt),
        "cos" : Operation.Unary(cos),
        "+" : Operation.Binary({ $0 + $1 }),
        "-" : Operation.Binary({ $0 - $1 }),
        "×" : Operation.Binary({ $0 * $1 }),
        "÷" : Operation.Binary({ $0 / $1 }),
        "=" : Operation.Equal
    ]

    private enum Operation{
        case Constant(Double)
        case Unary((Double)->Double)
        case Binary((Double, Double)->Double)
        case Equal
    }
    
    private var pending: PendingBinaryOperation?
    
    private struct PendingBinaryOperation{
        var binaryFunction: (Double,Double)->Double
        var firstOperand: Double
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
            case .Unary(let function):
                accumulator = function(accumulator)
            case .Binary(let function):
                executePendingOperation()
                pending = PendingBinaryOperation(binaryFunction: function, firstOperand: accumulator)
            case .Equal:
                executePendingOperation()

            }
        }
    }
    
    var result: Double{
        get{
            return accumulator
        }
    }
    
}
