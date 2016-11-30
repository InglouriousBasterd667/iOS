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

    
    var funcToDraw: ((Double) -> Double)? { didSet{ setNeedsDisplay() }}
    
    @IBInspectable
    var scale: CGFloat = 50.0 { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var lineWidth: CGFloat = 5.0 { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var color: UIColor = UIColor.blue { didSet { setNeedsDisplay() } }
    
    var originRelativeToCenter = CGPoint.zero { didSet { setNeedsDisplay() } }
    private var graphCenter:CGPoint {
        return convert(center, from: superview)
    }
    
    var origin: CGPoint {
        get {
            var origin = originRelativeToCenter
            origin.x += graphCenter.x
            origin.y += graphCenter.y
            return origin
        }
        set {
            var origin = newValue
            origin.x -= graphCenter.x
            origin.y -= graphCenter.y
            originRelativeToCenter = origin
        }
    }
    
    
    override func draw(_ rect: CGRect) {
        AxesDrawer(contentScaleFactor: contentScaleFactor)
            .drawAxesInRect(bounds: bounds, origin: origin, pointsPerUnit: scale)
        drawFuncInRect(bounds: bounds, origin: origin, scale: scale)
    }
    
    func drawFuncInRect(bounds: CGRect, origin: CGPoint, scale: CGFloat){
        color.set()
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        var x,y: CGFloat
        var X: Double {return Double((x - origin.x) / scale)}
        
        var oldPoint = PrevPoint (yGraph: 0.0, normal: false)
        var disContinuity:Bool {
            return abs( y - oldPoint.yGraph) >
                max(bounds.width, bounds.height) * 1.5}
        
        for xCoordinate in 0...Int(bounds.size.width * contentScaleFactor){
            x = CGFloat(xCoordinate) / contentScaleFactor
            if let f = funcToDraw{
                let res = f(X)
                y = origin.y - CGFloat(res) * scale
                if oldPoint.normal{
                    guard !disContinuity else {
                        oldPoint =  PrevPoint ( yGraph: y, normal: false)
                        continue }
                    path.addLine(to: CGPoint(x: x, y: y))
                } else {
                    path.move(to: CGPoint(x: x, y: y))
                }
                oldPoint =  PrevPoint (yGraph: y, normal: true)
            }
        }
        path.stroke()
    }
    
    private struct PrevPoint {
        var yGraph: CGFloat
        var normal: Bool
    }
    
    
//    func drawFuncInRect(_ bounds: CGRect, origin: CGPoint, scale: CGFloat){
//        color.set()
//        var xGraph, yGraph :CGFloat
//        
//        var x: Double {return Double ((xGraph - origin.x) / scale)}
//        
//        // ---Разрывные точки----
//        var oldPoint = OldPoint (yGraph: 0.0, normal: false)
//        var disContinuity:Bool {
//            return abs( yGraph - oldPoint.yGraph) >
//                max(bounds.width, bounds.height) * 1.5}
//        //-----------------------
//        let path = UIBezierPath()
//        path.lineWidth = lineWidth
//        
//        for i in 0...Int(bounds.size.width * contentScaleFactor){
//            
//            xGraph = CGFloat(i) / contentScaleFactor
//            
//            guard let y = (funcToDraw)?(x), y.isFinite
//                else { oldPoint.normal = false;  continue}
//            yGraph = origin.y - CGFloat(y) * scale
//            
//            if !oldPoint.normal{
//                path.move(to: CGPoint(x: xGraph, y: yGraph))
//            } else {
//                guard !disContinuity else {
//                    oldPoint =  OldPoint ( yGraph: yGraph, normal: false)
//                    continue }
//                path.addLine(to: CGPoint(x: xGraph, y: yGraph))
//            }
//            oldPoint =  OldPoint (yGraph: yGraph, normal: true)
//        }
//        path.stroke()
//    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
