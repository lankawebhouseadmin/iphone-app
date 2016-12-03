//
//  BE24PieBaseView.swift
//  Bethere24
//
//  Created by Prbath Neranja on 10/3/16.
//  Copyright © 2016 BeThere24. All rights reserved.
//

import UIKit
import SnapKit

class BE24PieBaseView: BE24View {
    
    let arcWidth:CGFloat = 10.0

//    internal var lblScoreNumber: UILabel!
//    internal var lblScoreName: UILabel!
    internal var viewScore: BE24ScoreView!
//    internal var underlineView: UIView!
//    internal var lblScoreTitle: UILabel!
    internal var imgviewArrow: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clearColor()

        imgviewArrow = UIImageView(image: UIImage(named: "iconPinArrow"))
        imgviewArrow.contentMode = .Top
        self.addSubview(imgviewArrow)
        imgviewArrow.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.snp_centerX).offset(0)
            make.centerY.equalTo(self.snp_centerY).offset(0)
            make.width.equalTo(20)
            make.height.equalTo(self.snp_height).offset(30).multipliedBy(0.4)
        }
        
//        let frame = CGRectMake(0, 0, 100, 100)
        viewScore = UINib(nibName: "ScoreView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as! BE24ScoreView
        self.addSubview(viewScore)
        viewScore.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.snp_centerX).offset(0)
            make.centerY.equalTo(self.snp_centerY).offset(0)
            make.height.equalTo(self.snp_height).offset(0).multipliedBy(0.4)
            make.width.equalTo(viewScore.snp_height).offset(0)
        }
        viewScore.makeBorder(UIColor.whiteColor(), borderWidth: 5)
        viewScore.makeRoundView(radius: viewScore.frame.width * 0.5)

    }
    
    internal func scoreValueAndName(score: Int) -> (String, String?) {
        if 0 < score && score <= 2 {
            return ("score" + String(score), "scoreNamePoor")
        } else if 2 < score && score <= 7 {
            return ("score" + String(score), "scoreNameGood")
        } else if 7 < score && score <= 10 {
            return ("score" + String(score), "scoreNameVeryGood")
        } else {
            return ("score", nil)
        }
    }

    func arrangeSublayout() {
        
        viewScore.makeRoundView(radius: viewScore.frame.width * 0.5)

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
                
                var angle = Int(atanf(ty / tx).radiansToDegrees.double)
                
                if CGRectContainsPoint(area2, position) || CGRectContainsPoint(area3, position){
                    angle = 180 + angle
                } else if CGRectContainsPoint(area4, position) {
                    angle = 360 + angle
                }
                
                
                touchedOnAngle(angle)

            }
            
        }
    }
    
    func touchedOnAngle(alpha: Int) -> Void {
        
    }

    func reloadData() -> Void {
        setNeedsDisplay()
    }

}
