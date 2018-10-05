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

    let timezoneSeconds = Double(NSTimeZone.local.secondsFromGMT())
    
    var delegate: BE24PieClockViewDelegate?
    
    fileprivate var imgBackgroundView: UIImageView!
    
    fileprivate var selectedIndex: Int = 0
//    private var stateCount: Int = 0
    fileprivate var states: [BE24StateModel]?
    fileprivate let secondsOfOneDay: Double = 86400
    fileprivate let twoPI = 2.0 * .pi
    fileprivate let angleOfSecond = 2.0 * .pi / CGFloat(86400)
    
    fileprivate var originAngle: CGFloat = 0
    
    var testTimeArr = ["1:00 PM", "2:00 PM", "3:00 PM", "4:00 PM", "5:00 PM", "6:00 PM", "7:00 PM", "8:00 PM", "9:00 PM", "10:00 PM", "11:00 PM", "12:00 PM", "1:00 AM", "2:00 AM", "3:00 AM", "4:00 AM", "5:00 AM", "6:00 AM", "7:00 AM", "8:00 AM", "9:00 AM", "10:00 AM", "11:00 AM", "12:00 AM"]
    
    override func awakeFromNib() {
        
        imgBackgroundView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        imgBackgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imgBackgroundView.contentMode = .scaleAspectFit
        imgBackgroundView.image = UIImage(named: "imgClockBackground")
        imgBackgroundView.makeBorder(UIColor.white, borderWidth: 5)
//        self.addSubview(imgBackgroundView)
        
        super.awakeFromNib()
        
        arrangeSublayout()
        
    }

    override func arrangeSublayout() {
        super.arrangeSublayout()
        
        let width = self.bounds.height - 2 // UIScreen.mainScreen().bounds.size.width - 16
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
    
    override func touchedOnAngle(_ angle: Int) -> Void {
        
        let aliasAngle = ((angle + 90) % 360)
        
//        print(aliasAngle)
        
        if states != nil {
            if states!.count == 1 {
                selectHealthState(0)
            } else if states!.count > 1 {
                for index in 0...(states!.count - 1) {
                    let state = states![index]
                    
                    let startSeconds = (state.startTime.timeIntervalSince1970 + timezoneSeconds).truncatingRemainder(dividingBy: secondsOfOneDay) // seconds of a day
                    let endSeconds   = (state.endTime.timeIntervalSince1970   + timezoneSeconds).truncatingRemainder(dividingBy: secondsOfOneDay)   // seconds of a day
                    let start = Int(360 / secondsOfOneDay * startSeconds) % 360
                    let end   = Int(360 / secondsOfOneDay * endSeconds) % 360
                    
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
    
   

    override func draw(_ rect: CGRect) {
        
        if states != nil {
        
            //find the centerpoint of the rect
            let centerPoint = CGPoint(x: rect.midX, y: rect.midY)
            
            //define the radius by the smallest side of the view
            var radius:CGFloat = 0.0
            if rect.width < rect.height{
                radius = (rect.width - arcWidth) / 2.0 - 1
            }else{
                radius = (rect.height - arcWidth) / 2.0 - 1
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

                    
                    if(state.startTime == state.endTime)
                    {
                        state.endTime = state.endTime.addingTimeInterval(1) // To create white line for very less time interval i.e start time = end time
                    }
                    
                    let startSeconds = (state.startTime.timeIntervalSince1970 + timezoneSeconds).truncatingRemainder(dividingBy: secondsOfOneDay) // seconds of a day
                    let endSeconds   = (state.endTime.timeIntervalSince1970   + timezoneSeconds).truncatingRemainder(dividingBy: secondsOfOneDay)   // seconds of a day
                    let start: CGFloat = angleOfSecond * CGFloat(startSeconds) + CGFloat(M_PI * 1.5)
                    var end:CGFloat    = angleOfSecond * CGFloat(endSeconds )  + CGFloat(M_PI * 1.5)
                    if endSeconds > startSeconds && endSeconds - startSeconds < 60 {
                        end = start + angleOfSecond * 60
                    }
//                    let colorValue = BE24AppManager.sharedManager.categories[index][kMenuColorKeyName]!
                    let pieColor = colorWithHexString(hexString: "#ffff88")
                    context?.setFillColor(pieColor.cgColor)
                    context?.move(to: CGPoint(x: centerPoint.x, y: centerPoint.y))
                    context?.addArc(center: centerPoint, radius: radius, startAngle: start, endAngle: end, clockwise: false)
//                    CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, start, end, 0)
                    context?.fillPath()
                    
                }
            }
            
            /// draw green bar
            let stateData = BE24AppManager.sharedManager.stateData!.first!
            let time = DATE_FORMATTER.OnlyTime.date(from: stateData.clientInfo.virtualDayStartOriginal)!
            
//            for Ttime in testTimeArr {
//            
//            let testTime = DATE_FORMATTER.TimeA.dateFromString(Ttime)
            
            let component = (Calendar.current as NSCalendar).components([.hour, .minute, .second], from: time)
            
            let totalSeconds = component.hour! * 3600 + component.minute! * 60 + component.second!
            let angle: CGFloat = angleOfSecond * CGFloat(totalSeconds) + CGFloat(M_PI * 1.5)
            let bx = centerPoint.x + radius * cos(angle)
            let by = centerPoint.y + radius * sin(angle)
            
            let aPath = UIBezierPath()
            
            aPath.move(to: centerPoint)
            
            aPath.addLine(to: CGPoint(x: bx, y: by))
            aPath.lineWidth = 2
            aPath.close()
            
            //If you want to stroke it with a red color
            UIColor.blue.set()
            aPath.stroke()
            //If you want to fill it as well 
            aPath.fill()
            
            
            if delegate!.shouldShowLoginTimeClockView(self) {
                let component = (Calendar.current as NSCalendar).components([.hour, .minute, .second], from: stateData.clientInfo.currentTime as Date)
                
                let totalSeconds = component.hour! * 3600 + component.minute! * 60 + component.second!
                let angle: CGFloat = angleOfSecond * CGFloat(totalSeconds) + CGFloat(M_PI * 1.5)
                let bx = centerPoint.x + radius * cos(angle)
                let by = centerPoint.y + radius * sin(angle)
                
                let aPath = UIBezierPath()
                
                aPath.move(to: centerPoint)
                
                aPath.addLine(to: CGPoint(x: bx, y: by))
                aPath.lineWidth = 2
                aPath.close()
                
                //If you want to stroke it with a red color
                UIColor.green.set()
                aPath.stroke()
                //If you want to fill it as well
                aPath.fill()

            }

        }
    }

    fileprivate func selectHealthState(_ index: Int, directionToNext: Bool = true) {
        
        if let statesCount = states?.count {
            
            if index < statesCount && index >= 0 {
                
                selectedIndex = index
                var borderColor: UIColor!
                if delegate != nil {
                    let score = self.delegate!.pieClockView(self, stateForIndex: index).score
                    let scoreValueName = self.scoreValueAndName(score!)
                    self.viewScore.imgScore.image = UIImage(named: scoreValueName.0)
                    if let scoreName = scoreValueName.1 {
                        self.viewScore.imgScoreName.image = UIImage(named: scoreName)
                    } else {
                        self.viewScore.imgScoreName.image = nil
                    }

                    borderColor = BE24AppManager.colorForScore(score!)
                    
                    delegate!.pieClockView(self, selectedStateIndex: index)
                } else {
                    borderColor = BE24AppManager.colorForScore(0)
                }
                
                self.viewScore.layer.borderColor = borderColor.cgColor
                
                
                /// Animate pin
                let state = states![index]
                let startSeconds = CGFloat((state.startTime.timeIntervalSince1970 + timezoneSeconds).truncatingRemainder(dividingBy: secondsOfOneDay))   // seconds of a day
//                let endSeconds   = CGFloat((state.endTime.timeIntervalSince1970   + timezoneSeconds) % secondsOfOneDay)   // seconds of a day
//                let middleSeconds = startSeconds + (endSeconds - startSeconds) / 2
                
                var angle = angleOfSecond * CGFloat(startSeconds) // - twoPI / 4 - twoPI / 24
                if directionToNext == false {
//                    angle = angle - twoPI
                }
                let originTransform = CGAffineTransform(rotationAngle: originAngle)
                let newTransform = originTransform.rotated(by: (angle - originAngle).truncatingRemainder(dividingBy: CGFloat(secondsOfOneDay)))
//                print (angle)
                UIView.animate(withDuration: 0.3, animations: {
                    
                    self.imgviewArrow.transform = CGAffineTransform(rotationAngle: angle)
                }) 
                originAngle = angle
            }

        }
        
    }
    
    fileprivate func resetScore() {
        self.viewScore.imgScore.image = UIImage(named: "score")
        self.viewScore.imgScoreName.image = nil

        self.viewScore.layer.borderColor = UIColor.white.cgColor
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
    func statesForPieCount(_ view: BE24PieClockView) -> [BE24StateModel]?
//    func numberOfPieCount(view: BE24PieClockView) -> Int
    func pieClockView(_ view: BE24PieClockView, stateForIndex: Int) -> BE24StateModel
    func pieClockView(_ view: BE24PieClockView, selectedStateIndex: Int) -> Void
    func shouldShowLoginTimeClockView(_ view: BE24PieClockView) -> Bool
}
