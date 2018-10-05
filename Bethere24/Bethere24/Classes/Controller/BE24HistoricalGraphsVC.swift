//
//  BE24HistoricalGraphsVC.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/25/16.
//  Copyright © 2016 BeThere24. All rights reserved.
//

import UIKit
import Charts
import MZFormSheetPresentationController

class BE24HistoricalGraphsVC: BE24HealthBaseVC, ChartViewDelegate, BE24HealthTypeMenuVCDelegate, IValueFormatter {

    @IBOutlet weak var imgHealthCategory: UIImageView!
    @IBOutlet weak var lblHealthCategory: UILabel!
    @IBOutlet weak var btnSelectHealthType: UIButton!
    @IBOutlet weak var lblMonthName: UILabel!
    @IBOutlet weak var btnHealthSummary: UIButton!
    @IBOutlet weak var btnHealthScore: UIButton!
//    @IBOutlet weak var btnAlert: UIButton!
    @IBOutlet weak var chart: LineChartView!
    @IBOutlet weak var viewChartContainer: UIView!
//    @IBOutlet weak var constraintCenter: NSLayoutConstraint!
    
//    var selectedHealthType: HealthType = .InBathroom
    
    var xValues: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Do any additional setup after loading the view.
        if appManager().selectedHealthType != nil {
//            selectedHealthType = appManager().selectedHealthType!
            self.healthTypeSelected(healthTypeForIndex.index(of: appManager().selectedHealthType!)!)
        } else {
            setData()
        }
        
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        self.pageType = .historicalGraphs
        
        self.viewChartContainer.makeRoundView()
        
        initChart()
        
//        self.btnAlert.hidden = true
    }
    
    fileprivate func initChart() {
        chart.delegate = self
        chart.chartDescription?.text = ""
        chart.dragEnabled = false
        chart.pinchZoomEnabled = false
        chart.doubleTapToZoomEnabled = false
        
        let xAxis = chart.xAxis
        xAxis.gridLineDashLengths = [10.0, 2.0]
//        xAxis.setLabelsToSkip(0)
        xAxis.drawLimitLinesBehindDataEnabled = true
        xAxis.avoidFirstLastClippingEnabled = true
        
//        chart.xAxis.gridLineDashPhase = 5
        let yAxis = chart.leftAxis
        yAxis.drawLimitLinesBehindDataEnabled = true
        yAxis.axisMaximum = 24.0
        yAxis.axisMinimum = 0
        yAxis.gridLineDashLengths = [10.0, 2.0]
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        yAxis.valueFormatter = numberFormatter as? IAxisValueFormatter

        let rightAxis = chart.rightAxis
        rightAxis.enabled = true
        rightAxis.axisMaximum = yAxis.axisMaximum
        rightAxis.axisMinimum = yAxis.axisMinimum
        rightAxis.drawGridLinesEnabled = false
        rightAxis.drawLabelsEnabled = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func refreshData() {
        super.refreshData()
        setData()
    }
    
    
//    // MARK: - Chart data
    func setData() -> Void {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        self.lblMonthName.text = dateFormatter.string(from: Date())
        if statesData != nil {
            var xVals: [String] = []
            var yVals: [ChartDataEntry] = []
            var dayIndex = statesData!.state.days.count
            var maxValue: Double = 0
            statesData!.state.days.forEach({ (dayString: String) in
//                xVals.append(dayString)
                xVals.insert(dayString.substring(to: dayString.characters.index(dayString.endIndex, offsetBy: -7)), at: 0)
                var totalTime: Double = 0.0
                statesData!.state.statesByDay[dayString]!.forEach({ (state: BE24StateModel) in
                    if state.type() == selectedHealthType {
                        totalTime += Double(state.actualTime)
                    }
                })
                if selectedHealthType == .TakingMedication {

                    yVals.insert(ChartDataEntry(x: Double(dayIndex), y: totalTime), at: 0)
                    if totalTime > maxValue {
                        maxValue = totalTime
                    }
                } else {
                    yVals.insert(ChartDataEntry(x: Double(dayIndex), y: totalTime/60.0), at: 0)
                }

                dayIndex -= 1

            })
            yVals.insert(ChartDataEntry(x: 0, y: -1), at: 0)
            yVals.append(ChartDataEntry(x: 9, y: -1))
            xVals.insert("", at: 0)
//            xVals.append("")
            chart.xAxis.setLabelCount(10, force: true)
            let valueFormatter = NumberFormatter()
            valueFormatter.maximumFractionDigits = 2

            if selectedHealthType == .TakingMedication {
                chart.leftAxis.axisMaximum = maxValue + 10
            } else {
                chart.leftAxis.axisMaximum = 24.0
            }

            //Needs to be checked
            if chart.data?.dataSetCount != nil {
                if (chart.data?.dataSetCount)! > 0 {
                    let set1 = chart.data!.dataSets[0] as! LineChartDataSet
                    set1.values = yVals
//                    set1.valueFormatter = valueFormatter as? IValueFormatter
                    chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: xVals )
//                    chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: xVals)
                    chart.data?.notifyDataChanged()
                    chart.notifyDataSetChanged()
                } else {
                    let set1 = LineChartDataSet(values: yVals, label: nil)
                    set1.lineDashLengths = [5.0, 2.5]
                    set1.highlightLineDashLengths = [5.0, 2.5]
                    set1.setColor(UIColor.black)
                    set1.setCircleColor(UIColor.black)
                    set1.lineWidth = 1
                    set1.circleRadius = 3
                    set1.drawCircleHoleEnabled = true
                    set1.formLineWidth = 1
                    set1.formSize = 15
                    set1.valueFont = UIFont.systemFont(ofSize: 9)
                    
//                    set1.valueFormatter = valueFormatter as? DefaultValueFormatter
                    //                set1.axisDependency = .Right
                    //                let data = LineChartData(xVals: xVals, dataSets: [set1])
                    chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: xVals)
                    let data = LineChartData(dataSets: [set1])
                    chart.data = data
                    chart.data?.notifyDataChanged()
                    chart.notifyDataSetChanged()
                }
            } else {
                let set1 = LineChartDataSet(values: yVals, label: nil)

                set1.lineDashLengths = [5.0, 2.5]
                set1.highlightLineDashLengths = [5.0, 2.5]
                set1.setColor(UIColor.black)
                set1.setCircleColor(UIColor.black)
                set1.lineWidth = 1
                set1.circleRadius = 3
                set1.drawCircleHoleEnabled = true
                set1.formLineWidth = 1
                set1.formSize = 15
                set1.valueFont = UIFont.systemFont(ofSize: 9)
//                set1.valueFormatter = valueFormatter as? IValueFormatter
//                set1.valueFormatter = xVals as? IValueFormatter
                //                set1.axisDependency = .Right
//                                let data = LineChartData(xVals: xVals, dataSets: [set1])
                chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: xVals)
                let data = LineChartData(dataSets: [set1])
                chart.data = data
                chart.data?.notifyDataChanged()
                chart.notifyDataSetChanged()
            }

            chart.animate(xAxisDuration: 2.0)

            showAlertCount()
        }
    }
    
    // MARK: - HealthType selecting
    @IBAction func onPressSelectHealthType(_ sender: AnyObject) -> Void {
//        print("select Health type")
        
        let healthTypeMenuVC = self.storyboard!.instantiateViewController(withIdentifier: "BE24HealthTypeMenuVC") as! BE24HealthTypeMenuVC
        healthTypeMenuVC.delegate = self
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: healthTypeMenuVC)
        formSheetController.presentationController?.portraitTopInset = 130
        var dialogSize = CGSize(width: 220, height: 360)
        if self.view.frame.height < dialogSize.height + 170 {
            dialogSize.height = self.view.frame.size.height - 190
        }
        formSheetController.presentationController?.contentViewSize = dialogSize  // or pass in UILayoutFittingCompressedSize to size automatically with auto-layout
        //        formSheetController.presentationController?.shouldApplyBackgroundBlurEffect = true
        formSheetController.presentationController?.blurEffectStyle = UIBlurEffectStyle.dark
        formSheetController.presentationController?.shouldDismissOnBackgroundViewTap = true
        formSheetController.contentViewControllerTransitionStyle = .fade
        
        self.present(formSheetController, animated: true, completion: nil)
        
    }
    
    func healthTypeSelected(_ index: Int) {
        selectedHealthType = healthTypeForIndex[index]
        
        let healthTypeData = appManager().categories[index]
        
        self.btnSelectHealthType.setImage(UIImage(named: healthTypeData[kMenuIconKeyName]!), for: UIControlState())
        self.btnSelectHealthType.setTitle(healthTypeData[kMenuTitleKeyName], for: UIControlState())
        self.btnSelectHealthType.setTitleColor(colorWithHexString(hexString: healthTypeData[kMenuColorKeyName]!), for: .normal)

        setData()
    }
    
    @IBAction func onPressHealthSummaryAndScore(_ sender: AnyObject) {
        appManager().selectedHealthType = selectedHealthType
        appManager().selectedDayIndex = nil
        if statesData != nil {
            if statesData!.state.days.count > 0 {
                appManager().selectedDayIndex = 0
            }
        }
        var segueName: String!
        if sender as? UIButton == self.btnHealthSummary {
            segueName = APPSEGUE_gotoHealthSummaryVC
        } else {
            segueName = APPSEGUE_gotoHealthScoreVC
        }
        sideMenuController?.performSegue(withIdentifier: segueName, sender: self)
    }

    // MARK: - UITableView datasource
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            let screenSize = UIScreen.main.bounds.size
            return screenSize.height - 200
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }

    // MARK: - ChartView delegate
    
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        
            return "test"
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
