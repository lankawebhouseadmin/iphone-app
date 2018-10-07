//
//  BE24PieCircleView.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/29/16.
//  Copyright © 2016 BeThere24. All rights reserved.
//

import UIKit
import CoreGraphics

class BE24PieCircleView: BE24PieBaseView {

    var delegate: BE24PieCircleViewDelegate?


    fileprivate var categoryIcons: [UIImageView] = []
    fileprivate var selectedIndex: Int = 0
    
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
    
    override func draw(_ rect: CGRect) {
        

        //find the centerpoint of the rect
        let twoPI = 2.0 * .pi
        
        let centerPoint = CGPoint(x: rect.midX, y: rect.midY)
        
        //define the radius by the smallest side of the view
        var radius:CGFloat = 0.0
        if rect.width < rect.height{
            radius = (rect.width - arcWidth) / 2.0
        }else{
            radius = (rect.height - arcWidth) / 2.0
        }

        /// Draw border
        var start:CGFloat = CGFloat(-(twoPI / 16 + twoPI / 4));
        let borderDt: CGFloat = 0.02
        //starting point for all drawing code is getting the context.
        let context = UIGraphicsGetCurrentContext()
        //set colorspace
        _ = CGColorSpaceCreateDeviceRGB()
        //set line attributes
        context?.setLineWidth(arcWidth)
        context?.setLineCap(.square)

        for index in 0...7 {
            let end:CGFloat = start + CGFloat(twoPI / 8)
            
            let colorValue = BE24AppManager.sharedManager.categories[index][kMenuColorKeyName]!
            let pieColor = colorWithHexString(hexString: colorValue)
            context?.setFillColor(pieColor.cgColor)
            //print("\(pieColor.getRed(UnsafeMutablePointer<CGFloat>?, green: <#T##UnsafeMutablePointer<CGFloat>?#>, blue: <#T##UnsafeMutablePointer<CGFloat>?#>, alpha: <#T##UnsafeMutablePointer<CGFloat>?#>))")
//            do {
//                let pieColor = try UIColor(rgba_throws: colorValue)
//                context?.setFillColor(pieColor.cgColor)
//            }
//            catch {
//                print("throws error")
//            }
            context?.move(to: CGPoint(x: centerPoint.x, y: centerPoint.y))
            context?.addArc(center: centerPoint, radius: radius, startAngle: start, endAngle: end, clockwise: false
            )
//            CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, start, end, 0)
            context?.fillPath()

            var borderColor: UIColor!
            if delegate != nil {
                let score = self.delegate!.pieCircleView(self, categoryScoreForIndex: index)
                borderColor = BE24AppManager.colorForScore(score)
            } else {
                borderColor = BE24AppManager.colorForScore(0)
            }
            context?.setStrokeColor(borderColor.cgColor)
            context?.setLineWidth(arcWidth * 0.8 )
            if index == 7 {
                context?.addArc(center: centerPoint, radius: radius, startAngle: start + borderDt, endAngle: end - borderDt, clockwise: false)
//                CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, start + borderDt, end - borderDt, 0)
            } else {
//                CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, start + borderDt, end + borderDt, 0)
                context?.addArc(center: centerPoint, radius: radius, startAngle: start + borderDt, endAngle: end + borderDt, clockwise: false)
            }
            context?.strokePath()
            
            start = end
        }
        
    }
    

    
    override func arrangeSublayout() {
        super.arrangeSublayout()
        
        let width = UIScreen.main.bounds.size.width - 16
        let selfBounds = CGRect(x: 0, y: 0, width: width, height: self.bounds.height)
        let centerPoint = CGPoint(x: selfBounds.midX, y: selfBounds.midY)
        let radius:CGFloat = min(selfBounds.width, selfBounds.height) / 4.0 + 30
        
        let twoPI = 2.0 * .pi
        let angleDelta = twoPI / 8
        var start:CGFloat = -CGFloat((twoPI / 4))
        
        self.categoryIcons.forEach { (imageView: UIImageView) in
            let ox = centerPoint.x + cos(start) * radius
            let oy = centerPoint.y + sin(start) * radius
            imageView.center = CGPoint(x: ox, y: oy)
            start += CGFloat(angleDelta)
        }
        
    }
    
    override func reloadData() -> Void {
        super.reloadData()
        selectCateogryIndex(selectedIndex)
    }
    
    override func touchedOnAngle(_ angle: Int) -> Void {
        let categoryCount = 8
        let tempIndex = (((angle + 360 / categoryCount / 2) / (360 / categoryCount)) % categoryCount + 2) % categoryCount
        selectCateogryIndex(tempIndex)
    }

    
    fileprivate func selectCateogryIndex(_ index: Int) {
        selectedIndex = index
        var borderColor: UIColor!
        if delegate != nil {
            let score = self.delegate!.pieCircleView(self, categoryScoreForIndex: index)
            let scoreValueName = self.scoreValueAndName(score)
//            self.lblScoreNumber.text = scoreValueName.0
//            self.lblScoreName.text = scoreValueName.1
            self.viewScore.imgScore.image = UIImage(named: scoreValueName.0)
            if let scoreName = scoreValueName.1 {
                self.viewScore.imgScoreName.image = UIImage(named: scoreName)
            } else {
                self.viewScore.imgScoreName.image = nil
            }
            

            
            borderColor = BE24AppManager.colorForScore(score)
            
            delegate!.pieCircleView(self, selectedIndex: selectedIndex)
        } else {
            borderColor = BE24AppManager.colorForScore(0)
        }
        self.viewScore.layer.borderColor = borderColor.cgColor
        
        /// Animate pin
        let angle = 2 * .pi / 8 * CGFloat(selectedIndex)
        UIView.animate(withDuration: 0.3, animations: { 
            self.imgviewArrow.transform = CGAffineTransform(rotationAngle: angle)
        }) 
        
    }
    
    func nextSelect(_ step: Int = 1) -> Void {
        self.selectCateogryIndex((selectedIndex + step) % 8)
    }
    
    func prevSelect(_ step: Int = 1) -> Void {
        if selectedIndex == 0 {
            selectedIndex = 8
        }
        self.selectCateogryIndex((selectedIndex - step) % 8)
    }
    
    func selectCategoryType(_ type: HealthType) -> Void {
        self.selectCateogryIndex(BE24AppManager.sharedManager.healthTypeForIndex.index(of: type)!)
    }
}

protocol BE24PieCircleViewDelegate {
    func pieCircleView(_ view: BE24PieCircleView, selectedIndex: Int) -> Void
    func pieCircleView(_ view: BE24PieCircleView, categoryScoreForIndex: Int) -> Int
}
