//
//  BE24PieClockView.swift
//  Bethere24
//
//  Created by Prbath Neranja on 10/5/16.
//  Copyright © 2016 LankaWebHouse. All rights reserved.
//

import UIKit

class BE24PieClockView: BE24PieBaseView {

    var delegate: BE24PieClockViewDelegate?
    
    private var imgBackgroundView: UIImageView!
    
    private var stateCount: Int = 0
    
    private let secondsOfOneDay: Double = 86400
    private let twoPI = 2.0 * CGFloat(M_PI)
    private let angleOfSecond = 2.0 * CGFloat(M_PI) / CGFloat(86400)
    
    override func awakeFromNib() {
        
        imgBackgroundView = UIImageView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        imgBackgroundView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        imgBackgroundView.contentMode = .ScaleAspectFit
        imgBackgroundView.image = UIImage(named: "imgClockBackground")
        imgBackgroundView.makeBorder(UIColor.whiteColor(), borderWidth: 5)
        self.addSubview(imgBackgroundView)
        
        super.awakeFromNib()
        
        arrangeSublayout()
    }

    override func arrangeSublayout() {
        super.arrangeSublayout()
        imgBackgroundView.makeRoundView(radius: imgBackgroundView.frame.size.width / 2)

    }
    
    override func reloadData() -> Void {
        super.reloadData()

    }
    
    override func touchedOnAngle(angle: Int) -> Void {

    }

    override func drawRect(rect: CGRect) {
        
        assert(delegate != nil, "BE24PieClockViewDelegate should be not nil")
        
        //find the centerpoint of the rect
        let centerPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))
        
        //define the radius by the smallest side of the view
        var radius:CGFloat = 0.0
        if CGRectGetWidth(rect) > CGRectGetHeight(rect){
            radius = (CGRectGetWidth(rect) - arcWidth) / 2.0
        }else{
            radius = (CGRectGetHeight(rect) - arcWidth) / 2.0
        }
        
        /// Draw border
        //starting point for all drawing code is getting the context.
        let context = UIGraphicsGetCurrentContext()
        //set colorspace
        _ = CGColorSpaceCreateDeviceRGB()
        //set line attributes
        CGContextSetLineWidth(context, arcWidth)
        CGContextSetLineCap(context, .Square)
        
        
        stateCount = delegate!.numberOfPieCount(self)
        
        for index in 0...stateCount {
            let state = delegate!.pieClockView(self, stateForIndex: index)
            let startSeconds = state.startTime.timeIntervalSince1970 % secondsOfOneDay // seconds of a day
            let endSeconds   = state.endTime.timeIntervalSince1970 % secondsOfOneDay   // seconds of a day
            let start: CGFloat = angleOfSecond * CGFloat(startSeconds)
            let end:CGFloat    = angleOfSecond * CGFloat(endSeconds)
            
//            let colorValue = BE24AppManager.sharedManager.categories[index][kMenuColorKeyName]!
            let pieColor = UIColor(rgba: "#ffffff88")
            CGContextSetFillColorWithColor(context, pieColor.CGColor)
            CGContextMoveToPoint(context, centerPoint.x, centerPoint.y)
            CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, start, end, 0)
            CGContextFillPath(context)
            
        }
        
    }

}

protocol BE24PieClockViewDelegate {
    func numberOfPieCount(view: BE24PieClockView) -> Int
    func pieClockView(view: BE24PieClockView, stateForIndex: Int) -> BE24StateModel
    func pieClockView(view: BE24PieClockView, selectedStateIndex: Int) -> Void
}