//
//  BE24HistoricalGraphsVC.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/25/16.
//  Copyright © 2016 LankaWebHouse. All rights reserved.
//

import UIKit
import Charts
import MZFormSheetPresentationController

class BE24HistoricalGraphsVC: BE24StateBaseVC, ChartViewDelegate, BE24HealthTypeMenuVCDelegate {

    @IBOutlet weak var imgHealthCategory: UIImageView!
    @IBOutlet weak var lblHealthCategory: UILabel!
    @IBOutlet weak var btnSelectHealthType: UIButton!
    @IBOutlet weak var lblMonthName: UILabel!
    @IBOutlet weak var btnHealthSummary: UIButton!
    @IBOutlet weak var btnHealthScore: UIButton!
    @IBOutlet weak var btnAlert: UIButton!
    @IBOutlet weak var chart: LineChartView!
    @IBOutlet weak var viewChartContainer: UIView!
    
    var selectedHealthType: HealthType = .InBathroom
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setData()
    }
    
    override func setupLayout() {
        super.setupLayout()
        self.pageType = .HistoricalGraphs
        
        self.viewChartContainer.makeRoundView()
        
        initChart()
        
        
    }
    
    private func initChart() {
        chart.delegate = self
        chart.descriptionText = ""
        chart.dragEnabled = false
        chart.pinchZoomEnabled = false
        chart.doubleTapToZoomEnabled = false
        
        let xAxis = chart.xAxis
        xAxis.gridLineDashLengths = [10.0, 2.0]
        xAxis.setLabelsToSkip(0)
        xAxis.drawLimitLinesBehindDataEnabled = true
        xAxis.avoidFirstLastClippingEnabled = true
        
//        chart.xAxis.gridLineDashPhase = 5
        let yAxis = chart.leftAxis
        yAxis.drawLimitLinesBehindDataEnabled = true
        yAxis.axisMaxValue = 24.0
        yAxis.axisMinValue = 0
        yAxis.gridLineDashLengths = [10.0, 2.0]
        
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .NoStyle
        yAxis.valueFormatter = numberFormatter

        chart.rightAxis.enabled = false
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Chart data
    func setData() -> Void {
        if statesData != nil {
            var xVals: [String?] = []
            var yVals: [ChartDataEntry] = []
            var dayIndex = statesData!.state.days.count
            var maxValue: Double = 0
            statesData!.state.days.forEach({ (dayString: String) in
//                xVals.append(dayString)
                dayIndex -= 1
                
                xVals.insert(dayString.substringToIndex(dayString.endIndex.advancedBy(-7)), atIndex: 0)
                var totalTime: Double = 0
                statesData!.state.statesByDay[dayString]!.forEach({ (state: BE24StateModel) in
                    if state.type() == selectedHealthType {
                        totalTime += Double(state.actualTime)
                    }
                })
                if selectedHealthType == .TakingMedication {
                    yVals.append(ChartDataEntry(value: totalTime, xIndex: dayIndex))
                    if totalTime > maxValue {
                        maxValue = totalTime
                    }
                } else {
                    yVals.append(ChartDataEntry(value: totalTime / 60.0, xIndex: dayIndex))

                }
                
                
            })

            let valueFormatter = NSNumberFormatter()
            valueFormatter.maximumFractionDigits = 2
            
            if selectedHealthType == .TakingMedication {
                chart.leftAxis.axisMaxValue = maxValue + 10
            } else {
                chart.leftAxis.axisMaxValue = 24.0
            }
            
            if chart.data?.dataSetCount > 0 {
                let set1 = chart.data!.dataSets[0] as! LineChartDataSet
                set1.yVals = yVals
                
                chart.data?.xVals = xVals
                chart.data?.notifyDataChanged()
                chart.notifyDataSetChanged()
            } else {
                let set1 = LineChartDataSet(yVals: yVals, label: nil)
                set1.lineDashLengths = [5.0, 2.5]
                set1.highlightLineDashLengths = [5.0, 2.5]
                set1.setColor(UIColor.blackColor())
                set1.setCircleColor(UIColor.blackColor())
                set1.lineWidth = 1
                set1.circleRadius = 3
                set1.drawCircleHoleEnabled = true
                set1.valueFont = UIFont.systemFontOfSize(9)
                set1.valueFormatter = valueFormatter
//                set1.axisDependency = .Right
                let data = LineChartData(xVals: xVals, dataSets: [set1])
                chart.data = data
                
            }
            chart.animate(xAxisDuration: 2, easingOption: .EaseOutBack)
        }
    }
    
    // MARK: - HealthType selecting
    @IBAction func onPressSelectHealthType(sender: AnyObject) -> Void {
        print("select Health type")
        
        let healthTypeMenuVC = self.storyboard!.instantiateViewControllerWithIdentifier("BE24HealthTypeMenuVC") as! BE24HealthTypeMenuVC
        healthTypeMenuVC.delegate = self
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: healthTypeMenuVC)
        formSheetController.presentationController?.portraitTopInset = 130
        var dialogSize = CGSizeMake(220, 360)
        if self.view.frame.height < dialogSize.height + 170 {
            dialogSize.height = self.view.frame.size.height - 190
        }
        formSheetController.presentationController?.contentViewSize = dialogSize  // or pass in UILayoutFittingCompressedSize to size automatically with auto-layout
        //        formSheetController.presentationController?.shouldApplyBackgroundBlurEffect = true
        formSheetController.presentationController?.blurEffectStyle = UIBlurEffectStyle.Dark
        formSheetController.presentationController?.shouldDismissOnBackgroundViewTap = true
        formSheetController.contentViewControllerTransitionStyle = .Fade
        
        self.presentViewController(formSheetController, animated: true, completion: nil)
        
    }
    
    func healthTypeSelected(index: Int) {
        selectedHealthType = healthTypeForIndex[index]
        
        let healthTypeData = appManager().categories[index]
        
        self.btnSelectHealthType.setImage(UIImage(named: healthTypeData[kMenuIconKeyName]!), forState: .Normal)
        self.btnSelectHealthType.setTitle(healthTypeData[kMenuTitleKeyName], forState: .Normal)
        self.btnSelectHealthType.setTitleColor(UIColor(rgba: healthTypeData[kMenuColorKeyName]!), forState: .Normal)

        setData()
    }

    // MARK: - UITableView datasource
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 1 {
            let screenSize = UIScreen.mainScreen().bounds.size
            return screenSize.height - 200
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }

    // MARK: - ChartView delegate
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
