//
//  BE24PieClockView.swift
//  Bethere24
//
//  Created by Prbath Neranja on 10/5/16.
//  Copyright © 2016 BeThere24. All rights reserved.
//

import UIKit
import SwiftyJSON

class BE24PieClockView: BE24PieBaseView {

    let timezoneSeconds = Double(NSTimeZone.localTimeZone().secondsFromGMT)
    
    var delegate: BE24PieClockViewDelegate?
    
    private var imgBackgroundView: UIImageView!
    
    private var selectedIndex: Int = 0
//    private var stateCount: Int = 0
    private var states: [BE24StateModel]?
    private let secondsOfOneDay: Double = 86400
    private let twoPI = 2.0 * CGFloat(M_PI)
    private let angleOfSecond = 2.0 * CGFloat(M_PI) / CGFloat(86400)
    
    private var originAngle: CGFloat = 0
    
    override func awakeFromNib() {
        
        imgBackgroundView = UIImageView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        imgBackgroundView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        imgBackgroundView.contentMode = .ScaleAspectFit
        imgBackgroundView.image = UIImage(named: "imgClockBackground")
        imgBackgroundView.makeBorder(UIColor.whiteColor(), borderWidth: 5)
//        self.addSubview(imgBackgroundView)
        
        super.awakeFromNib()
        
        arrangeSublayout()
        
    }

    override func arrangeSublayout() {
        super.arrangeSublayout()
        
        let width = self.bounds.height - 16 // UIScreen.mainScreen().bounds.size.width - 16
        imgBackgroundView.makeRoundView(radius: width / 2)

    }
    
    override func reloadData() -> Void {
//        super.reloadData()
        
        assert(delegate != nil, "BE24PieClockViewDelegate should be not nil")
        
        resetScore()
        states = delegate!.statesForPieCount(self)
        
        if states != nil {
            
            selectHealthState(0)
            
            /*
            if states!.count > selectedIndex {
                selectHealthState(selectedIndex)
            } else {
                selectHealthState(states!.count - 1)
            }
            */
            
            self.setNeedsDisplay()
            
        }
    }
    
    override func touchedOnAngle(angle: Int) -> Void {
        
        let aliasAngle = ((angle + 90) % 360)
        
//        print(aliasAngle)
        
        if states != nil {
            if states!.count == 1 {
                selectHealthState(0)
            } else if states!.count > 1 {
                for index in 0...(states!.count - 1) {
                    let state = states![index]
                    
                    let startSeconds = (state.startTime.timeIntervalSince1970 + timezoneSeconds) % secondsOfOneDay // seconds of a day
                    let endSeconds   = (state.endTime.timeIntervalSince1970   + timezoneSeconds) % secondsOfOneDay   // seconds of a day
                    let start = Int(360 / secondsOfOneDay * startSeconds + -1) % 360
                    let end   = Int(360 / secondsOfOneDay * endSeconds   + 1) % 360
                    
                    if  start <= aliasAngle && aliasAngle <= end
//                        || start >= aliasAngle && aliasAngle >= end
                    {
                        selectHealthState(index)
                        break
                    } else if start > end {
                        if start <= aliasAngle && aliasAngle < 360 || 0 <= aliasAngle && aliasAngle <= end {
                            selectHealthState(index)
                        }
                    }

                }

            } else {
                
            }
        }
    }

    override func drawRect(rect: CGRect) {
        
        if states != nil {
        
            //find the centerpoint of the rect
            let centerPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))
            
            //define the radius by the smallest side of the view
            var radius:CGFloat = 0.0
            if CGRectGetWidth(rect) < CGRectGetHeight(rect){
                radius = (CGRectGetWidth (rect) - arcWidth) / 2.0 + 3
            }else{
                radius = (CGRectGetHeight(rect) - arcWidth) / 2.0 + 3
            }
            
            /// Draw Pie
            //starting point for all drawing code is getting the context.
            let context = UIGraphicsGetCurrentContext()
            //set colorspace
            _ = CGColorSpaceCreateDeviceRGB()
            //set line attributes
            
            let stateCount = states!.count
            if stateCount > 0 {
                for index in 0...(stateCount - 1) {
                    let state = states![index]

                    let startSeconds = (state.startTime.timeIntervalSince1970 + timezoneSeconds) % secondsOfOneDay // seconds of a day
                    let endSeconds   = (state.endTime.timeIntervalSince1970   + timezoneSeconds) % secondsOfOneDay   // seconds of a day
                    let start: CGFloat = angleOfSecond * CGFloat(startSeconds) + CGFloat(M_PI * 1.5)
                    var end:CGFloat    = angleOfSecond * CGFloat(endSeconds )  + CGFloat(M_PI * 1.5)
                    if endSeconds > startSeconds && endSeconds - startSeconds < 60 {
                        end = start + angleOfSecond * 60
                    }
        //            let colorValue = BE24AppManager.sharedManager.categories[index][kMenuColorKeyName]!
                    let pieColor = UIColor(rgba: "#ffffff88")
                    CGContextSetFillColorWithColor(context, pieColor.CGColor)
                    CGContextMoveToPoint(context, centerPoint.x, centerPoint.y)
                    CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, start, end, 0)
                    CGContextFillPath(context)
                    
                }
            }
            
            /// draw green bar
            let stateData = BE24AppManager.sharedManager.stateData!.first!
            let time = DATE_FORMATTER.OnlyTime.dateFromString(stateData.clientInfo.virtualDayStartOriginal)!
            let component = NSCalendar.currentCalendar().components([.Hour, .Minute, .Second], fromDate: time)
            
            let totalSeconds = component.hour * 3600 + component.minute * 60 + component.second
            let angle: CGFloat = angleOfSecond * CGFloat(totalSeconds) + CGFloat(M_PI * 1.5)
            let bx = centerPoint.x + radius * cos(angle)
            let by = centerPoint.y + radius * sin(angle)
            
            let aPath = UIBezierPath()
            
            aPath.moveToPoint(centerPoint)
            
            aPath.addLineToPoint(CGPoint(x: bx, y: by))
            aPath.lineWidth = 2
            aPath.closePath()
            
            //If you want to stroke it with a red color
            UIColor.blueColor().set()
            aPath.stroke()
            //If you want to fill it as well 
            aPath.fill()
            
            if delegate!.shouldShowLoginTimeClockView(self) {
                let component = NSCalendar.currentCalendar().components([.Hour, .Minute, .Second], fromDate: stateData.clientInfo.currentTime)
                
                let totalSeconds = component.hour * 3600 + component.minute * 60 + component.second
                let angle: CGFloat = angleOfSecond * CGFloat(totalSeconds) + CGFloat(M_PI * 1.5)
                let bx = centerPoint.x + radius * cos(angle)
                let by = centerPoint.y + radius * sin(angle)
                
                let aPath = UIBezierPath()
                
                aPath.moveToPoint(centerPoint)
                
                aPath.addLineToPoint(CGPoint(x: bx, y: by))
                aPath.lineWidth = 2
                aPath.closePath()
                
                //If you want to stroke it with a red color
                UIColor.greenColor().set()
                aPath.stroke()
                //If you want to fill it as well
                aPath.fill()

            }

        }
    }

    private func selectHealthState(index: Int, directionToNext: Bool = true) {
        
        if let statesCount = states?.count {
            
            if index < statesCount && index >= 0 {
                
                selectedIndex = index
                var borderColor: UIColor!
                if delegate != nil {
                    let score = self.delegate!.pieClockView(self, stateForIndex: index).score
                    let scoreValueName = self.scoreValueAndName(score)
                    self.viewScore.imgScore.image = UIImage(named: scoreValueName.0)
                    if let scoreName = scoreValueName.1 {
                        self.viewScore.imgScoreName.image = UIImage(named: scoreName)
                    } else {
                        self.viewScore.imgScoreName.image = nil
                    }

                    borderColor = BE24AppManager.colorForScore(score)
                    
                    delegate!.pieClockView(self, selectedStateIndex: index)
                } else {
                    borderColor = BE24AppManager.colorForScore(0)
                }
                
                self.viewScore.layer.borderColor = borderColor.CGColor
                
                
                /// Animate pin
                let state = states![index]
                let startSeconds = CGFloat((state.startTime.timeIntervalSince1970 + timezoneSeconds) % secondsOfOneDay)   // seconds of a day
//                let endSeconds   = CGFloat((state.endTime.timeIntervalSince1970   + timezoneSeconds) % secondsOfOneDay)   // seconds of a day
//                let middleSeconds = startSeconds + (endSeconds - startSeconds) / 2
                
                var angle = angleOfSecond * CGFloat(startSeconds) // - twoPI / 4 - twoPI / 24
                if directionToNext == false {
//                    angle = angle - twoPI
                }
                let originTransform = CGAffineTransformMakeRotation(originAngle)
                let newTransform = CGAffineTransformRotate(originTransform, (angle - originAngle) % CGFloat(secondsOfOneDay))
//                print (angle)
                UIView.animateWithDuration(0.3) {
                    self.imgviewArrow.transform = CGAffineTransformMakeRotation(angle)
                }
                originAngle = angle
            }

        }
        
    }
    
    private func resetScore() {
        self.viewScore.imgScore.image = UIImage(named: "score")
        self.viewScore.imgScoreName.image = nil

        self.viewScore.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    func nextSelect() -> Void {
        if let statesCount = states?.count {
            if statesCount > 0 {
                self.selectHealthState((selectedIndex + 1) % statesCount, directionToNext: false)
            }
        }
    }
    
    func prevSelect() -> Void {
        if let statesCount = states?.count {
            if statesCount > 0 {
                if selectedIndex == 0 {
                    selectedIndex = statesCount
                }
                self.selectHealthState((selectedIndex - 1) % statesCount)
            }
        }
    }
}

@objc
protocol BE24PieClockViewDelegate {
    func statesForPieCount(view: BE24PieClockView) -> [BE24StateModel]?
//    func numberOfPieCount(view: BE24PieClockView) -> Int
    func pieClockView(view: BE24PieClockView, stateForIndex: Int) -> BE24StateModel
    func pieClockView(view: BE24PieClockView, selectedStateIndex: Int) -> Void
    func shouldShowLoginTimeClockView(view: BE24PieClockView) -> Bool
}