//
//  BE24PieClockView.swift
//  Bethere24
//
//  Created by Prbath Neranja on 10/5/16.
//  Copyright © 2016 LankaWebHouse. All rights reserved.
//

import UIKit

class BE24PieClockView: BE24PieBaseView {

    private var imgBackgroundView: UIImageView!
    
    override func awakeFromNib() {
        
        imgBackgroundView = UIImageView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        imgBackgroundView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        imgBackgroundView.contentMode = .ScaleAspectFit
        imgBackgroundView.image = UIImage(named: "imgClockBackground")
        self.addSubview(imgBackgroundView)
        
        super.awakeFromNib()
        
        arrangeSublayout()
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
