//
//  GraphView.swift
//  Calculator
//
//  Created by Mikhail Lyapich on 28.11.16.
//  Copyright © 2016 Mikhail Lyapich. All rights reserved.
//

import UIKit


@IBDesignable
class GraphView: UIView {

    
    var funcToDraw: ((Double) -> Double)?{ didSet{ setNeedsDisplay() }}
    
    @IBInspectable
    var scale: CGFloat = 50.0 { didSet { setNeedsDisplay() } }
    
    private var originSet: CGPoint? { didSet { setNeedsDisplay() } }
    var origin: CGPoint {
        get {
            return originSet ?? CGPoint(x: bounds.midX, y: bounds.midY)
        }
        set {
            originSet = newValue
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        AxesDrawer(contentScaleFactor: contentScaleFactor)
            .drawAxesInRect(bounds: bounds, origin: origin, pointsPerUnit: scale)
        
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
