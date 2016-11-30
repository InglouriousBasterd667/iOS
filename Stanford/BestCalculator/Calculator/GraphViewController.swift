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
            let tapRecognizer = UITapGestureRecognizer(target: graphView, action: #selector(GraphView.moveOrigin(gesture:)))
            tapRecognizer.numberOfTapsRequired = 2
            graphView.addGestureRecognizer(tapRecognizer)
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphView, action: #selector(GraphView.scale(gesture:))))
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target: graphView, action: #selector(GraphView.panningGraph(gesture:))))
            
            updateUI()
        }
    }
    
    private func updateUI(){
        graphView?.funcToDraw = graphFunc
    }

}
