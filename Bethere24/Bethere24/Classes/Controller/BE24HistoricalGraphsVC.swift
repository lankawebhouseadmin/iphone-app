//
//  BE24HistoricalGraphsVC.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/25/16.
//  Copyright © 2016 LankaWebHouse. All rights reserved.
//

import UIKit
import Charts

class BE24HistoricalGraphsVC: BE24MainBaseVC, ChartViewDelegate {

    @IBOutlet weak var imgHealthCategory: UIImageView!
    @IBOutlet weak var lblHealthCategory: UILabel!
    @IBOutlet weak var lblMonthName: UILabel!
    @IBOutlet weak var btnHealthSummary: UIButton!
    @IBOutlet weak var btnHealthScore: UIButton!
    @IBOutlet weak var btnAlert: UIButton!
    @IBOutlet weak var chart: LineChartView!
    @IBOutlet weak var viewChartContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setupLayout() {
        super.setupLayout()
        self.pageType = .HistoricalGraphs
        
        self.viewChartContainer.makeRoundView()
        
        initChart()
        
        setData()
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

//        chart.xAxis.gridLineDashPhase = 5
        let yAxis = chart.leftAxis
        yAxis.axisMaxValue = 24.0
        yAxis.axisMinValue = 0
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .NoStyle
        yAxis.valueFormatter = numberFormatter
        yAxis.gridLineDashLengths = [10.0, 2.0]
        yAxis.drawZeroLineEnabled = true
        yAxis.drawLimitLinesBehindDataEnabled = true
        
        chart.rightAxis.enabled = false
        
        chart.animate(xAxisDuration: 3, easingOption: .EaseOutBack)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Chart data
    func setData() -> Void {
        let xVals: [String?] = [
            "9/23",
            "9/24",
            "9/25",
            "9/26",
            "9/27",
            "9/28",
            "9/29",
        ]
        let yVals = [
            ChartDataEntry(value: 4.6, xIndex: 0),
            ChartDataEntry(value: 5.0, xIndex: 1),
            ChartDataEntry(value: 1.3, xIndex: 2),
            ChartDataEntry(value: 3.3, xIndex: 3),
            ChartDataEntry(value: 9.6, xIndex: 4),
            ChartDataEntry(value: 6.9, xIndex: 5),
            ChartDataEntry(value: 9.4, xIndex: 6),
        ]
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
            
            let data = LineChartData(xVals: xVals, dataSets: [set1])
            chart.data = data
            
        }
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
