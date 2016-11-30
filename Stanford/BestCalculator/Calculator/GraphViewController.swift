//
//  GraphViewController.swift
//  Calculator
//
//  Created by Mikhail Lyapich on 28.11.16.
//  Copyright © 2016 Mikhail Lyapich. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {
    
    var graphFunc: ((Double) -> Double)? { didSet{ updateUI()}}
    
    @IBOutlet weak var graphView: GraphView!{
        didSet{
            updateUI()
        }
    }
    
    private func updateUI(){
        graphView?.funcToDraw = graphFunc
    }

}
