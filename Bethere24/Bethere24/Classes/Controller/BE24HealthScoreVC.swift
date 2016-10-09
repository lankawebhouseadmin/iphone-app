//
//  BE24HealthScoreVC.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/25/16.
//  Copyright © 2016 LankaWebHouse. All rights reserved.
//

import UIKit
import MZFormSheetPresentationController

class BE24HealthScoreVC: BE24HealthBaseVC, BE24HealthTypeMenuVCDelegate, BE24PieClockViewDelegate {

    @IBOutlet weak var btnSelectHealthType: UIButton!
    @IBOutlet weak var viewMainPieCircleView: BE24PieClockView!
    
    private var categories: [[String: String]]!
    
    private var currentSelectedDateIndex: Int = 0
    private var currentSelectedHealthTypeIndex: Int = 0
    private var currentStatesForHealtyType: [BE24StateModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categories = appManager().categories

        selectHealthType(currentSelectedHealthTypeIndex, dateIndex: currentSelectedDateIndex)
    }

    override func setupLayout() {
        super.setupLayout()
        self.pageType = .HealthScoreDetails
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func graphCellIndex() -> Int {
        return 2
    }
    
    // MARK: - HealthType selecting
    @IBAction func onPressSelectHealthType(sender: AnyObject) -> Void {
        print("select Health type")
        
        let dialogSize = CGSizeMake(220, 360)
        let healthTypeMenuVC = self.storyboard!.instantiateViewControllerWithIdentifier("BE24HealthTypeMenuVC") as! BE24HealthTypeMenuVC
        healthTypeMenuVC.delegate = self
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: healthTypeMenuVC)
        formSheetController.presentationController?.portraitTopInset = self.view.frame.size.height - dialogSize.height - 40
        formSheetController.presentationController?.contentViewSize = dialogSize  // or pass in UILayoutFittingCompressedSize to size automatically with auto-layout
//        formSheetController.presentationController?.shouldApplyBackgroundBlurEffect = true
        formSheetController.presentationController?.blurEffectStyle = UIBlurEffectStyle.Dark
        formSheetController.presentationController?.shouldDismissOnBackgroundViewTap = true
        formSheetController.contentViewControllerTransitionStyle = .Fade
        
        self.presentViewController(formSheetController, animated: true, completion: nil)

    }

    func healthTypeSelected(index: Int) {
        self.selectHealthType(index, dateIndex: currentSelectedDateIndex)
    }
    
    // MARK: - Select Date and health type
    override func selectDateIndex(index: Int) {
        super.selectDateIndex(index)
        if statesData != nil {
            
            if statesData!.state.days.count > 0 {
                let dateString = statesData!.state.days[index]
                currentStateData = statesData!.state.statesByDay[dateString]
                
                self.selectHealthType(currentSelectedHealthTypeIndex, dateIndex: index)
                
//                viewMainPieCircleView.reloadData()
            }
        }

    }
    
    func selectHealthType(index: Int, dateIndex: Int) -> Void {
        
        currentSelectedHealthTypeIndex = index
        currentSelectedDateIndex       = dateIndex
        
        let healthTypeData = appManager().categories[index]
        self.lblHealthTitle.text = healthTypeData[kMenuTitleKeyName]
        self.lblHealthTitle.textColor = UIColor(rgba: healthTypeData[kMenuColorKeyName]!)
        self.imgHealthIcon.image = UIImage(named: healthTypeData[kMenuIconKeyName]!)
        
        self.btnSelectHealthType.setImage(self.imgHealthIcon.image, forState: .Normal)
        self.btnSelectHealthType.setTitle(self.lblHealthTitle.text, forState: .Normal)
        self.btnSelectHealthType.setTitleColor(self.lblHealthTitle.textColor, forState: .Normal)
        
        self.viewMainPieCircleView.reloadData()
    }
    
    // MARK: BE24PieClockView delegate
    func numberOfPieCount(view: BE24PieClockView) -> Int {
        
    }

    func pieClockView(view: BE24PieClockView, stateForIndex: Int) -> BE24StateModel {
        
    }
    
    func pieClockView(view: BE24PieClockView, selectedStateIndex: Int) {
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
