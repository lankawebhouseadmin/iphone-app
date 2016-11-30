//
//  BE24SideMenuController.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/25/16.
//  Copyright © 2016 BeThere24. All rights reserved.
//

import SideMenuController

class BE24SideMenuController: SideMenuController {

    required init?(coder aDecoder: NSCoder) {
        SideMenuController.preferences.drawing.menuButtonImage = UIImage(named: "iconMenu")
        SideMenuController.preferences.drawing.sidePanelPosition = .UnderCenterPanelLeft
        SideMenuController.preferences.drawing.sidePanelWidth = 240
        SideMenuController.preferences.drawing.centerPanelShadow = true
        SideMenuController.preferences.animating.statusBarBehaviour = .HorizontalPan
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.performSegueWithIdentifier(APPSEGUE_gotoMenuVC, sender: self)
        self.performSegueWithIdentifier(APPSEGUE_gotoHealthSummaryVC, sender: self)
//        self.performSegueWithIdentifier(APPSEGUE_gotoHistoricalGraphsVC, sender: self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }

}
