//
//  BE24MainBaseVC.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/25/16.
//  Copyright © 2016 LankaWebHouse. All rights reserved.
//

import UIKit

class BE24MainBaseVC: BE24TableViewController {
    
    weak var lblTitle: UILabel!
    weak var imgPageIcon: UIImageView!
    var btnNotification: ENMBadgedBarButtonItem!
    
    var pageType: PageType? {
        didSet {
            self.setPageTitle()
        }
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        addCustomNavigationBar()
        addCustomTitleView()
        
        self.tableView.allowsSelection = false
        self.tableView.backgroundColor = APPCOLOR.BACKGROUND_BLACK
        self.tableView.separatorStyle = .None
        
        
        //self.setPageTitle()
    }
    
    internal func addCustomNavigationBar() {
        let titleView = BE24View(frame: CGRectMake(0, 0, 180, 30))
        
        let imgIconLogo = UIImageView(frame: CGRectMake(0, 0, 30, 30))
        imgIconLogo.image = UIImage(named: "iconLogoBig")
        titleView.addSubview(imgIconLogo)
        
        let lblTitle = UILabel(frame: CGRectMake(CGRectGetMaxX(imgIconLogo.frame) + 10, imgIconLogo.frame.origin.y, 100, 30))
        lblTitle.text = "BeThere24™"
        lblTitle.font = UIFont.systemFontOfSize(20)
        lblTitle.textColor = UIColor.whiteColor()
        lblTitle.sizeToFit()
        var frame = lblTitle.frame
        frame.size.height = 30
        lblTitle.frame = frame
        titleView.addSubview(lblTitle)
        
        self.navigationItem.titleView = titleView
        
        let btnRefresh = UIBarButtonItem(image: UIImage(named: "iconRefresh"),
                                         style: .Plain,
                                         target: self,
                                         action: #selector(self.onPressRefresh(_:)))
        btnRefresh.tintColor = UIColor.whiteColor()
//        btnRefresh.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10)
        
        let btnNotificationBody = UIButton(type: .Custom)
        btnNotificationBody.setImage(UIImage(named: "iconAlert"), forState: .Normal)
        btnNotificationBody.frame = CGRectMake(0, 0, 30, 40)
        btnNotificationBody.addTarget(self, action: #selector(self.onPressNotification(_:)), forControlEvents: .TouchUpInside)
        
        let btnNotification = ENMBadgedBarButtonItem(customView: btnNotificationBody, value: "3")
        btnNotification.badgeBackgroundColor = UIColor.redColor()
        btnNotification.badgeTextColor = UIColor.whiteColor()
        self.btnNotification = btnNotification
        updateAlertBadgeCount()
//        btnNotificationBody.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10)
        
        self.navigationItem.rightBarButtonItems = [btnNotification, btnRefresh]
    }
    
    internal func addCustomTitleView() {
        let _titleView = BE24View(frame: CGRectMake(0, 0, self.tableView.frame.size.width, 40))
        _titleView.backgroundColor = UIColor.whiteColor()
        
        let _lblTitle = UILabel()
        _lblTitle.text = "Health Summary"
        _lblTitle.font = UIFont.boldSystemFontOfSize(14)
        _lblTitle.textColor = APPCOLOR.TEXTCOLOR_DARK
        _titleView.addSubview(_lblTitle)
        _lblTitle.snp_makeConstraints { (make) in
            make.centerX.equalTo(20)
            make.centerY.equalTo(0)
        }
        
        let _imgPageIcon = UIImageView()
        _titleView.addSubview(_imgPageIcon)
        _imgPageIcon.snp_makeConstraints { (make) in
            make.width.equalTo(_titleView.snp_height).offset(-10)
            make.height.equalTo(_imgPageIcon.snp_width).offset(0)
            make.centerY.equalTo(0)
            make.right.equalTo(_lblTitle.snp_left).offset(-15)
        }
        
        self.tableView.tableHeaderView = _titleView
        
        self.lblTitle = _lblTitle
        self.imgPageIcon = _imgPageIcon

    }
    
    private func setPageTitle() {
        var pageInfo: [String: String]?
        switch pageType! {
            case .HealthSummary:
                pageInfo = appManager().menuItems[0]
                break
            case .HealthScoreDetails:
                pageInfo = appManager().menuItems[1]
                break
            case .AlertSummary:
                pageInfo = appManager().menuItems[2]
                break
            case .HistoricalGraphs:
                pageInfo = appManager().menuItems[3]
                break
            case .ContactInfo:
                pageInfo = appManager().menuItems[4]
                break
            default:
                pageInfo = nil
                break
        }
        if pageInfo != nil {
            self.lblTitle.text = pageInfo![kMenuTitleKeyName]
            self.imgPageIcon.image = UIImage(named: pageInfo![kMenuIconKeyName]!)
        } else {
            self.lblTitle.text = nil
            self.imgPageIcon.image = nil
        }
    }
    
    func onPressRefresh(sender: AnyObject) -> Void {
        print (#function)
        
    }
    
    func onPressNotification(sender: AnyObject) -> Void {
        print (#function)
    }
    
    func updateAlertBadgeCount(count: Int? = nil) -> Void {
        if count == nil {
            if let stateData = appManager().stateData {
                if let alerts = stateData.first!.alert {
                    btnNotification.badgeValue = String(alerts.count)
                    return
                }
            }
            btnNotification.badgeValue = ""
        } else {
            btnNotification.badgeValue = String(count!)
        }
    }
}
