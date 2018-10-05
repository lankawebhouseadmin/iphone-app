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
        NotificationCenter.default.addObserver(self, selector: #selector(logout(_:)), name: NSNotification.Name(rawValue: NOTIFICACTION_EnterBackground), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NOTIFICACTION_EnterBackground), object: nil)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        addCustomNavigationBar()
        addCustomTitleView()
        
        self.tableView.allowsSelection = false
        self.tableView.backgroundColor = APPCOLOR.BACKGROUND_BLACK
        self.tableView.separatorStyle = .none
        
        
        //self.setPageTitle()
    }
    
    func logout(_ sender: AnyObject) -> Void {
        sideMenuController?.dismiss(animated: true, completion: { 
            
        })
    }
    
    internal func addCustomNavigationBar() {
        let titleView = BE24View(frame: CGRect(x: 0, y: 0, width: 180, height: 30))
        
        let imgIconLogo = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imgIconLogo.image = UIImage(named: "iconLogoBig")
        titleView.addSubview(imgIconLogo)
    
        let lblTitle = UILabel(frame: CGRect(x: imgIconLogo.frame.maxX + 10, y: imgIconLogo.frame.origin.y, width: 100, height: 30))
        lblTitle.text = "BeThere24™"
        lblTitle.font = UIFont.systemFont(ofSize: 20)
        lblTitle.textColor = UIColor.white
        lblTitle.sizeToFit()
        var frame = lblTitle.frame
        frame.size.height = 30
        lblTitle.frame = frame
        titleView.addSubview(lblTitle)
        
        self.navigationItem.titleView = titleView
        
        let btnRefresh = UIBarButtonItem(image: UIImage(named: "iconRefresh"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(self.onPressRefresh(_:)))
        btnRefresh.tintColor = UIColor.white
//        btnRefresh.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10)
        
        let btnNotificationBody = UIButton(type: .custom)
        btnNotificationBody.setImage(UIImage(named: "iconAlert"), for: UIControlState())
        btnNotificationBody.frame = CGRect(x: 0, y: 0, width: 30, height: 40)
        btnNotificationBody.addTarget(self, action: #selector(self.onPressNotification(_:)), for: .touchUpInside)
        
        let btnNotification = ENMBadgedBarButtonItem(customView: btnNotificationBody, value: "3")
        btnNotification.badgeBackgroundColor = UIColor.red
        btnNotification.badgeTextColor = UIColor.white
        self.btnNotification = btnNotification
        updateAlertBadgeCount()
//        btnNotificationBody.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10)
        
        self.navigationItem.rightBarButtonItems = [btnNotification, btnRefresh]
    }
    
    internal func addCustomTitleView() {
        let _titleView = BE24View(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 40))
        _titleView.backgroundColor = UIColor.white
        _titleView.backgroundColor = UIColor.brown
        
        let _lblTitle = UILabel(frame: CGRect(x: _titleView.frame.width/2 - 100, y: 5, width: 200, height: 30))
        //_lblTitle.center = CGPoint(x: _titleView.frame.width/2, y: _titleView.frame.height/2)
        
        //_lblTitle.frame.size = CGSize(width: 150, height: 30)
        _lblTitle.text = "Health Summary"
        _lblTitle.font = UIFont.boldSystemFont(ofSize: 16)
        _lblTitle.textColor = .black
//        _lblTitle.backgroundColor = .red
        _lblTitle.textAlignment = .center
        _titleView.addSubview(_lblTitle)
        _titleView.backgroundColor = UIColor.white
        
//        _lblTitle.snp_makeConstraints { (make) in
//            make.centerX.equalTo(20)
//            make.centerY.equalTo(0)
//        }
        
//        _lblTitle.snp.makeConstraints { (make) in
//            make.centerX.equalTo(20)
//            make.centerY.equalTo(0)
//        }
//
        let _imgPageIcon = UIImageView(frame: CGRect(x: _lblTitle.frame.minX - 10, y: 5, width: 30, height: 30))
        _titleView.addSubview(_imgPageIcon)
//        _imgPageIcon.snp.makeConstraints { (make) in
//            make.width.equalTo(_titleView.snp.height).offset(-10)
//            make.height.equalTo(_imgPageIcon.snp.width).offset(0)
//            make.centerY.equalTo(0)
//            make.right.equalTo(_lblTitle.snp.left).offset(-15)
//        }
        self.tableView.tableHeaderView = _titleView
        
        
        self.lblTitle = _lblTitle
        
        self.imgPageIcon = _imgPageIcon
        
    }
    
    fileprivate func setPageTitle() {
        var pageInfo: [String: String]?
        switch pageType! {
            case .healthSummary:
                pageInfo = appManager().menuItems[0]
                break
            case .healthScoreDetails:
                pageInfo = appManager().menuItems[1]
                break
            case .alertSummary:
                pageInfo = appManager().menuItems[2]
                break
            case .historicalGraphs:
                pageInfo = appManager().menuItems[3]
                break
            case .contactInfo:
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
    
    func onPressRefresh(_ sender: AnyObject) -> Void {
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
                    (UIApplication.shared.delegate as! AppDelegate).setTimeZone(self.appManager().currentUser!.personTimeZone!)
                    
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
    
    func onPressNotification(_ sender: AnyObject) -> Void {
        print (#function)
        appManager().selectedHealthType = nil
        sideMenuController?.performSegue(withIdentifier: APPSEGUE_gotoAlertSummaryVC, sender: self)
    }
    
    func updateAlertBadgeCount(_ count: Int? = nil) -> Void {
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
