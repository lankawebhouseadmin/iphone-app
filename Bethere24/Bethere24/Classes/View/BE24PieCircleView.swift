//
//  BE24PieCircleView.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/29/16.
//  Copyright © 2016 LankaWebHouse. All rights reserved.
//

import UIKit
import CoreGraphics

class BE24PieCircleView: BE24PieBaseView {

    var delegate: BE24PieCircleViewDelegate?


    private var categoryIcons: [UIImageView] = []
    private var selectedIndex: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        BE24AppManager.sharedManager.categories.forEach { (category: [String : String]) in
            let iconName = category[kMenuIconKeyName]! + "White"
            let icon = UIImage(named: iconName)
            let imageView = UIImageView(image: icon)
            self.addSubview(imageView)
            self.categoryIcons.append(imageView)
        }
        
        
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
        let borderDt: CGFloat = 0.02
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
            if index == 7 {
                CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, start + borderDt, end - borderDt, 0)
            } else {
                CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, start + borderDt, end + borderDt, 0)
            }
            CGContextStrokePath(context)
            
            start = end
        }
        
    }
    

    
    override func arrangeSublayout() {
        super.arrangeSublayout()
        
        let width = UIScreen.mainScreen().bounds.size.width - 16
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
        
    }
    
    func reloadData() -> Void {
        setNeedsDisplay()
        selectCateogryIndex(selectedIndex)
    }
    
    override func touchedOnAlpha(alpha: Int) -> Void {
        let categoryCount = 8
        let tempIndex = (((alpha + 360 / categoryCount / 2) / (360 / categoryCount)) % categoryCount + 2) % categoryCount
        selectCateogryIndex(tempIndex)
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
            
            delegate!.pieCircleView(self, selectedIndex: selectedIndex)
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
