//
//  GraphViewController.swift
//  Calculator
//
//  Created by Mikhail Lyapich on 28.11.16.
//  Copyright © 2016 Mikhail Lyapich. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {

    
    var graphFunc: ((Double) -> Double)?{ didSet{updateUI()}}
    
    
    @IBOutlet var graphView: GraphView!
   
    
    private func updateUI(){
        graphView.funcToDraw = graphFunc
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
