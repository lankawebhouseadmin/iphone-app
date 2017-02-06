//
//  BE24MainBaseVC.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/25/16.
//  Copyright © 2016 BeThere24. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
import SnapKit

class BE24MainBaseVC: BE24TableViewController {
    
    weak var lblTitle: UILabel!
    weak var imgPageIcon: UIImageView!
    var btnNotification: ENMBadgedBarButtonItem!
    
    var pageType: PageType? {
        didSet {
            self.setPageTitle()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(logout(_:)), name: NOTIFICACTION_EnterBackground, object: nil)
    }
    
    deinit {
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: NOTIFICACTION_EnterBackground, object: nil)
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
    
    func logout(sender: AnyObject) -> Void {
        sideMenuController?.dismissViewControllerAnimated(true, completion: { 
            
        })
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
        SVProgressHUD.show()
        
        let usernamePassword = appManager().getUsernamePassword()
        let username = usernamePassword.0
        let password = usernamePassword.1

        self.requestManager().login(username!, password: password!) { (userInfo: AnyObject?, userError: NSError?) in
            if userInfo != nil {
                let json = JSON(userInfo!)
                let message = json["message"].stringValue
                let success = json["success"].stringValue
                if success == "true" {

                    self.appManager().currentUser = BE24UserModel(data: json["data"])
                    self.appManager().token = json["token"].stringValue
                    (UIApplication.sharedApplication().delegate as! AppDelegate).setTimeZone(self.appManager().currentUser!.personTimeZone!)
                    
                    print ("userID : " + String(self.appManager().currentUser!.id) + "  <:::>  " + "token : " + self.appManager().token!)
                    
                    self.requestManager().getData(self.appManager().currentUser!.id, token: self.appManager().token!, result: { (result: [BE24LocationModel]?, json: JSON?, error: NSError?) in
                        if result != nil {
                            self.appManager().stateData = result!
                            
                            //                self.performSegueWithIdentifier(APPSEGUE_gotoMainVC, sender: self)
                            self.refreshData()
                        } else {
                            self.showSimpleAlert("Error", Message: error!.localizedDescription, CloseButton: "Close", Completion: {
                                
                            })
                        }
                        SVProgressHUD.dismiss()
                    })
                    return
                } else {
                    self.showSimpleAlert("Error", Message: message, CloseButton: "Close", Completion: {
                        
                    })
                }
            } else {
                self.showSimpleAlert("Error", Message: userError!.localizedDescription, CloseButton: "Close", Completion: {})
            }
        }
        
    }
    
    func onPressNotification(sender: AnyObject) -> Void {
        print (#function)
        appManager().selectedHealthType = nil
        sideMenuController?.performSegueWithIdentifier(APPSEGUE_gotoAlertSummaryVC, sender: self)
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
            if count! == 0 {
                btnNotification.badgeValue = ""
            } else {
                btnNotification.badgeValue = String(count!)
            }
        }
    }
    
    func refreshData() -> Void {
        updateAlertBadgeCount()
    }
}
