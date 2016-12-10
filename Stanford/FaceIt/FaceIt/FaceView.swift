//
//  FaceView.swift
//  FaceIt
//
//  Created by Mikhail Lyapich on 07.11.16.
//  Copyright © 2016 Mikhail Lyapich. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {
    
    @IBInspectable
    var scale: CGFloat = 0.9 { didSet {setNeedsDisplay()} }
    
    @IBInspectable
    var mouthCurvature: Float = 0.0 { didSet {setNeedsDisplay()} }
    
    @IBInspectable
    var coulor: UIColor = UIColor.blue { didSet {setNeedsDisplay()} }
    
    var skullRadius: CGFloat {
            return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    
    var skullCenter: CGPoint{
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private struct Ratios{
        static let SkullRadiusToEyeOffset: CGFloat = 3
        static let SkullRadiusToEyeRadius: CGFloat = 10
        static let SkullRadiusToMouthWidth: CGFloat = 1
        static let SkullRadiusToMouthHeight: CGFloat = 3
        static let SkullRadiusToMouthOffset: CGFloat = 3
    }
    
    private enum Eye{
        case Left
        case Right
    }
    
    private func pathForCircleCenteredAtPoint(_ midPoint:CGPoint, withRadius radius: CGFloat) ->UIBezierPath{
        let path =  UIBezierPath(
            arcCenter: midPoint,
            radius: radius,
            startAngle: 0.0,
            endAngle: CGFloat(2*M_PI),
            clockwise: true)
        path.lineWidth = 2.0
        return path
    }
    private func getEyeCenter(_ eye:Eye) -> CGPoint{
        let eyeOffset = skullRadius / Ratios.SkullRadiusToEyeOffset
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOffset
        switch eye{
        case .Left: eyeCenter.x -= eyeOffset
        case .Right: eyeCenter.x += eyeOffset
        }
        return eyeCenter
    }
    
    private func getPathForEye(_ eye:Eye) ->UIBezierPath{
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
        print(skullRadius)
        print(eyeRadius)
        let eyeCenter = getEyeCenter(eye)
        return pathForCircleCenteredAtPoint(eyeCenter, withRadius: eyeRadius)
    }
    
    private func getPathForMouth() -> UIBezierPath{
        let mouthWidth = skullRadius / Ratios.SkullRadiusToMouthWidth
        let mouthHeight = skullRadius / Ratios.SkullRadiusToMouthHeight
        let mouthOffset = skullRadius / Ratios.SkullRadiusToMouthOffset
        
        let mouthRect = CGRect(x: skullCenter.x - mouthWidth / 2, y: skullCenter.y + mouthOffset,
                               width: mouthWidth, height: mouthHeight)
        
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height
        let cp1 = CGPoint(x: mouthRect.minX + mouthRect.width / 3, y: mouthRect.minY + smileOffset)
        let cp2 = CGPoint(x: mouthRect.maxX - mouthRect.width / 3, y: mouthRect.minY + smileOffset)
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        return path
    }
    
    override func draw(_ rect: CGRect) {
        pathForCircleCenteredAtPoint(skullCenter, withRadius: skullRadius).stroke()
        getPathForEye(.Left).stroke()
        getPathForEye(.Right).stroke()
        getPathForMouth().stroke()
    }

}
