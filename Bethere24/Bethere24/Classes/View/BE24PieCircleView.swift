//
//  BE24PieCircleView.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/29/16.
//  Copyright © 2016 LankaWebHouse. All rights reserved.
//

import UIKit
import CoreGraphics

class BE24PieCircleView: BE24View {

    var endArc:CGFloat = 0.0{   // in range of 0.0 to 1.0
        didSet{
            setNeedsDisplay()
        }
    }
    var arcWidth:CGFloat = 10.0
    var arcColor = UIColor.yellowColor()
    var arcBackgroundColor = UIColor.blackColor()
    var isPie = false
    
    override func drawRect(rect: CGRect) {
        
        //Important constants for circle
        let fullCircle = 2.0 * CGFloat(M_PI)
        let start:CGFloat = -0.25 * fullCircle
        let end:CGFloat = endArc * fullCircle + start
        
        //find the centerpoint of the rect
        let centerPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))
        
        //define the radius by the smallest side of the view
        var radius:CGFloat = 0.0
        if CGRectGetWidth(rect) > CGRectGetHeight(rect){
            radius = (CGRectGetWidth(rect) - arcWidth) / 2.0
        }else{
            radius = (CGRectGetHeight(rect) - arcWidth) / 2.0
        }
        
        //starting point for all drawing code is getting the context.
        let context = UIGraphicsGetCurrentContext()
        //set colorspace
        _ = CGColorSpaceCreateDeviceRGB()
        //set line attributes
        CGContextSetLineWidth(context, arcWidth)
        CGContextSetLineCap(context, .Round)
        
        //make the circle background
        
        CGContextSetStrokeColorWithColor(context, arcBackgroundColor.CGColor)
        CGContextSetFillColorWithColor(context, arcBackgroundColor.CGColor)
        CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, 0, fullCircle, 0)
        CGContextStrokePath(context)
        
        //draw the arc or pie
        
        if isPie {
            CGContextSetFillColorWithColor(context, arcColor.CGColor)
            CGContextMoveToPoint(context, centerPoint.x, centerPoint.y)
            CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, start, end, 0)
            CGContextFillPath(context)
        }else{
            CGContextSetStrokeColorWithColor(context, arcColor.CGColor)
            CGContextSetLineWidth(context, arcWidth * 0.8 )
            CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, start, end, 0)
            CGContextStrokePath(context)
        }
        
    }
}
