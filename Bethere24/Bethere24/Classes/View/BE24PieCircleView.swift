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

    let arcWidth:CGFloat = 10.0
    var delegate: BE24PieCircleViewDelegate?

    private let stateColor = [
        "#ff0000",
        "#ffc800",
        "#68ff00",
    ]

    private var categoryIcons: [UIImageView] = []
    private var lblScoreNumber: UILabel!
    private var lblScoreName: UILabel!
    private var viewScore: UIView!
    private var underlineView: UIView!
    private var lblScoreTitle: UILabel!
    private var imgviewArrow: UIImageView!
    private var selectedIndex: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clearColor()
        
        BE24AppManager.sharedManager.categories.forEach { (category: [String : String]) in
            let iconName = category[kMenuIconKeyName]! + "White"
            let icon = UIImage(named: iconName)
            let imageView = UIImageView(image: icon)
            self.addSubview(imageView)
            self.categoryIcons.append(imageView)
        }
        
        imgviewArrow = UIImageView(image: UIImage(named: "iconPinArrow"))
        imgviewArrow.contentMode = .Top
        self.addSubview(imgviewArrow)
        
        let frame = CGRectMake(0, 0, 100, 100)
        viewScore = UIView(frame: frame)
        viewScore.makeBorder(UIColor.whiteColor(), borderWidth: 5)
        viewScore.makeRoundView(radius: 50)
        viewScore.backgroundColor = UIColor.whiteColor()
        self.addSubview(viewScore)
        
        let scoreNumberFrame = CGRectMake(0, 10, frame.width, 40)
        lblScoreNumber = UILabel(frame: scoreNumberFrame)
        lblScoreNumber.text = "10"
        lblScoreNumber.textColor = APPCOLOR.BACKGROUND_BLACK
//        lblScoreNumber.font = UIFont.systemFontOfSize(60)
        lblScoreNumber.textAlignment = .Center
//        lblScoreNumber.minimumScaleFactor = 0.3
//        lblScoreNumber.adjustsFontSizeToFitWidth = true
        
//        lblScoreNumber.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        viewScore.addSubview(lblScoreNumber)
        
        let scoreNameFrame = CGRectMake(0, CGRectGetMaxY(scoreNumberFrame), scoreNumberFrame.width, 30)
        lblScoreName = UILabel(frame: scoreNameFrame)
        lblScoreName.text = "Very good"
        lblScoreName.textColor = APPCOLOR.BACKGROUND_BLACK
//        lblScoreName.font = UIFont.boldSystemFontOfSize(26)
        lblScoreName.textAlignment = .Center
//        lblScoreNumber.minimumScaleFactor = 0.3
//        lblScoreNumber.adjustsFontSizeToFitWidth = true
//        lblScoreName.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        viewScore.addSubview(lblScoreName)

        let underlineFrame = CGRectMake(10, CGRectGetMaxY(scoreNameFrame), frame.width - 20, 2)
        underlineView  = UIView(frame: underlineFrame)
        underlineView.backgroundColor = APPCOLOR.BACKGROUND_BLACK
        underlineView.alpha = 0.6
//        underlineView.autoresizingMask = [.FlexibleWidth, .FlexibleTopMargin, .FlexibleBottomMargin]
        viewScore.addSubview(underlineView)
        
        let scoreTitleFrame = CGRectMake(0, CGRectGetMaxY(underlineFrame) + 5, frame.width, 20)
        lblScoreTitle = UILabel(frame: scoreTitleFrame)
        lblScoreTitle.text = "Score"
        lblScoreTitle.textAlignment = .Center
//        lblScoreTitle.font = UIFont.systemFontOfSize(20)
        lblScoreTitle.textColor = APPCOLOR.BACKGROUND_BLACK
//        lblScoreNumber.minimumScaleFactor = 0.3
//        lblScoreNumber.adjustsFontSizeToFitWidth = true
//        lblScoreTitle.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        viewScore.addSubview(lblScoreTitle)
        
        arrangeSublayout()
    }
    
    override func drawRect(rect: CGRect) {
        

        //find the centerpoint of the rect
        let twoPI = 2.0 * CGFloat(M_PI)
        
        let centerPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))
        
        //define the radius by the smallest side of the view
        var radius:CGFloat = 0.0
        if CGRectGetWidth(rect) > CGRectGetHeight(rect){
            radius = (CGRectGetWidth(rect) - arcWidth) / 2.0
        }else{
            radius = (CGRectGetHeight(rect) - arcWidth) / 2.0
        }

        /// Draw border
        var start:CGFloat = -(twoPI / 16 + twoPI / 4);
        let borderDt: CGFloat = 0.028
        //starting point for all drawing code is getting the context.
        let context = UIGraphicsGetCurrentContext()
        //set colorspace
        _ = CGColorSpaceCreateDeviceRGB()
        //set line attributes
        CGContextSetLineWidth(context, arcWidth)
        CGContextSetLineCap(context, .Square)

        for index in 0...7 {
            let end:CGFloat = start + twoPI / 8
            
            let colorValue = BE24AppManager.sharedManager.categories[index][kMenuColorKeyName]!
            let pieColor = UIColor(rgba: colorValue)
            CGContextSetFillColorWithColor(context, pieColor.CGColor)
            CGContextMoveToPoint(context, centerPoint.x, centerPoint.y)
            CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, start, end, 0)
            CGContextFillPath(context)

            var borderColor: UIColor!
            if delegate != nil {
                let score = self.delegate!.pieCircleView(self, categoryScoreForIndex: index)
                borderColor = self.colorForScore(score)
            } else {
                borderColor = self.colorForScore(0)
            }
            CGContextSetStrokeColorWithColor(context, borderColor.CGColor)
            CGContextSetLineWidth(context, arcWidth * 0.8 )
            CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, start + borderDt, end + borderDt, 0)
            CGContextStrokePath(context)
            
            start = end
        }
        
    }
    
    private func colorForScore(score: Int) -> UIColor {
        var colorValueIndex = 0
        if 3 < score && score <= 7 {
            colorValueIndex = 1
        } else if 7 < score {
            colorValueIndex = 2
        }
        let colorValue = stateColor[colorValueIndex]
        return UIColor(rgba: colorValue)
    }
    
    private func scoreValueAndName(score: Int) -> (String?, String?) {
        if score == 0 {
            return ("-", nil)
        } else if 0 < score && score <= 3 {
            return (String(score), "Poor")
        } else if 3 < score && score <= 7 {
            return (String(score), "Good")
        } else {
            return (String(score), "Very good")
        }
    }

    
    func arrangeSublayout() {
        var width = UIScreen.mainScreen().bounds.size.width - 16
        let selfBounds = CGRectMake(0, 0, width, width)
        let centerPoint = CGPointMake(CGRectGetMidX(selfBounds), CGRectGetMidY(selfBounds))
        let radius:CGFloat = width / 4.0 + 30
        
        let twoPI = 2.0 * CGFloat(M_PI)
        let angleDelta = twoPI / 8
        var start:CGFloat = -(twoPI / 4);
        
        self.categoryIcons.forEach { (imageView: UIImageView) in
            let ox = centerPoint.x + cos(start) * radius
            let oy = centerPoint.y + sin(start) * radius
            imageView.center = CGPointMake(ox, oy)
            start += angleDelta
        }
        
        width = width * 0.4
        let scoreFrame = CGRectMake(0, 0, width, width)
        self.viewScore.frame = scoreFrame
        self.viewScore.center = centerPoint
        self.viewScore.makeRoundView(radius: scoreFrame.width * 0.5)
        
        let scoreNumberFrame = CGRectMake(0, 10, width, width * 0.35)
        lblScoreNumber.frame = scoreNumberFrame
        lblScoreNumber.font  = UIFont.systemFontOfSize(width * 0.4)
        
        let scoreNameFrame  = CGRectMake(0, CGRectGetMaxY(scoreNumberFrame), width, width * 0.25)
        lblScoreName.frame  = scoreNameFrame
        lblScoreName.font   = UIFont.boldSystemFontOfSize(width * 0.15)
        
        let underlineFrame  = CGRectMake(width * 0.1, CGRectGetMaxY(scoreNameFrame), width - width * 0.2, 2)
        underlineView.frame = underlineFrame
        
        let scoreTitleFrame = CGRectMake(0, CGRectGetMaxY(underlineFrame) + 5, width, width * 0.2)
        lblScoreTitle.frame = scoreTitleFrame
        lblScoreTitle.font  = UIFont.systemFontOfSize(width * 0.1)
        
        let pinFrame = CGRectMake(0, 0, 20, width + 30)
        self.imgviewArrow.frame = pinFrame
        self.imgviewArrow.center = centerPoint
    }
    
    func reloadData() -> Void {
        setNeedsDisplay()
        selectCateogryIndex(selectedIndex)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first {
            let position = touch.locationInView(self)
            
            let outRadius = Float(self.bounds.width * 0.5)
            let inRadius  = Float(self.viewScore.frame.width * 0.5)
            
            let ox = Float(self.bounds.width * 0.5)
            let oy = Float(self.bounds.height * 0.5)
            let tx = (Float(position.x) - ox) == 0 ? 0.00001 : Float(position.x) - ox
            let ty = Float(position.y) - oy
            
            let radius = sqrt(pow(tx, 2) + pow(ty, 2))
            
            if inRadius <= radius && radius <= outRadius {
                
                
                let area1 = CGRectMake(CGFloat(ox), CGFloat(oy), self.bounds.width * 0.5, self.bounds.height * 0.5)
                let area2 = CGRectOffset(area1, -area1.width, 0)
                let area3 = CGRectOffset(area1, -area1.width, -area1.height)
                let area4 = CGRectOffset(area1, 0, -area1.height)
                
                var alpha = Int(atanf(ty / tx).radiansToDegrees.double)
                
                if CGRectContainsPoint(area2, position) || CGRectContainsPoint(area3, position){
                    alpha = 180 + alpha
                } else if CGRectContainsPoint(area4, position) {
                    alpha = 360 + alpha
                }

                let categoryCount = 8
                let tempIndex = (((alpha + 360 / categoryCount / 2) / (360 / categoryCount)) % categoryCount + 2) % categoryCount
                self.selectCateogryIndex(tempIndex)
            }
            
            
        }
    }
    
    private func selectCateogryIndex(index: Int) {
        selectedIndex = index
        var borderColor: UIColor!
        if delegate != nil {
            let score = self.delegate!.pieCircleView(self, categoryScoreForIndex: index)
            let scoreValueName = self.scoreValueAndName(score)
            self.lblScoreNumber.text = scoreValueName.0
            self.lblScoreName.text = scoreValueName.1
            
            borderColor = self.colorForScore(score)
            
        } else {
            borderColor = self.colorForScore(0)
        }
        self.viewScore.layer.borderColor = borderColor.CGColor
        
        /// Animate pin
        let angle = CGFloat(M_PI * 2) / 8 * CGFloat(selectedIndex)
        UIView.animateWithDuration(0.3) { 
            self.imgviewArrow.transform = CGAffineTransformMakeRotation(angle)
        }
    }
    
    func nextSelect(step: Int = 1) -> Void {
        self.selectCateogryIndex((selectedIndex + step) % 8)
    }
    
    func prevSelect(step: Int = 1) -> Void {
        if selectedIndex == 0 {
            selectedIndex = 8
        }
        self.selectCateogryIndex((selectedIndex - step) % 8)
    }
}

protocol BE24PieCircleViewDelegate {
    func pieCircleView(view: BE24PieCircleView, selectedIndex: Int) -> Void
    func pieCircleView(view: BE24PieCircleView, categoryScoreForIndex: Int) -> Int
}
