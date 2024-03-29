//
//  PageAppointmentViewController.swift
//  YiMai
//
//  Created by why on 16/5/27.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageAppointmentViewController: PageViewController {
    private var Actions: PageAppointmentActions? = nil
    public var BodyView: PageAppointmentBodyView? = nil
    public var Loading: YMPageLoadingView? = nil
    
    public static var SelectedDoctor:[String: AnyObject]? = nil
    public static var PatientBasicInfo: [String: String]? = nil
    public static var PatientCondition: String = ""
    public static var SelectedTime: String = ""
    public static var SelectedTimeForUpload: [String]? = nil
    
    public static var DoctorIsPreSelected = false
    public static var FromIM = false
    
    public static var NewAppointment = true
    static var SavedAppointment = false
    
    func BeforeGoBack() -> Bool {
        if(0 == BodyView!.PhotoArray.count
        && nil == PageAppointmentViewController.PatientBasicInfo
        && "" == PageAppointmentViewController.PatientCondition
        && "" == PageAppointmentViewController.SelectedTime
        && nil == PageAppointmentViewController.SelectedDoctor
            ) {
            return true
        }
        YMPageModalMessage.ShowConfirmInfo("是否保存记录", nav: self.NavController!, ok: { (_) in
            self.NavController?.popViewControllerAnimated(true)
            PageAppointmentViewController.SavedAppointment = true
            }, cancel: { (_) in
                PageAppointmentViewController.SavedAppointment = false
                self.NavController?.popViewControllerAnimated(true)
        })
        
        return false
    }

    override func PageLayout() {
        super.PageLayout()
        Actions = PageAppointmentActions(navController: self.NavController, target: self)
        BodyView = PageAppointmentBodyView(parentView: self.SelfView!, navController: self.NavController!, pageActions: Actions!)
        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "预约", navController: self.NavController!, before: BeforeGoBack)
        
        Loading = YMPageLoadingView(parentView: self.view)
    }

    override func PagePreRefresh() {
        if(PageAppointmentViewController.NewAppointment) {
            
            if(!PageAppointmentViewController.DoctorIsPreSelected) {
                PageAppointmentViewController.SelectedDoctor = nil
            } else {
                PageAppointmentViewController.DoctorIsPreSelected = false
            }
            
            PageAppointmentPatientConditionBodyView.InitContent = ""

            PageAppointmentViewController.PatientBasicInfo = nil
            PageAppointmentViewController.PatientCondition = ""
            PageAppointmentViewController.SelectedTime = ""
            
            BodyView?.BodyView.removeFromSuperview()
            TopView?.TopViewPanel.removeFromSuperview()
            
            BodyView?.Actions = nil
            BodyView = PageAppointmentBodyView(parentView: self.SelfView!, navController: self.NavController!, pageActions: Actions!)
            TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "预约", navController: self.NavController!, before: BeforeGoBack)
            PageAppointmentViewController.NewAppointment = false
            BodyView?.Reload()
        } else {
            BodyView?.Reload()
            if(nil != VerifyInput(false)) {
                BodyView?.SetConfirmEnable()
            } else {
                BodyView?.SetConfirmDisable()
            }
        }
    }

    public func VerifyInput(showAlarm: Bool = true) -> [String:String]? {
        if(nil == PageAppointmentViewController.PatientBasicInfo) {
            if(showAlarm) {
                YMPageModalMessage.ShowErrorInfo("请填写病人基本信息！", nav: self.NavController!)
            }
            return nil
        }
        
        if(nil == PageAppointmentViewController.SelectedDoctor) {
            if(showAlarm) {
                YMPageModalMessage.ShowErrorInfo("请选择医生！", nav: self.NavController!)
            }
            return nil
        }
        
        if(nil == PageAppointmentViewController.SelectedTimeForUpload) {
            if(showAlarm) {
                YMPageModalMessage.ShowErrorInfo("请选择就诊时间！", nav: self.NavController!)
            }
            return nil
        }
        
        let basicInfo = PageAppointmentViewController.PatientBasicInfo!
        var date = ""
        var amOrPm = ""
        if(0 == PageAppointmentViewController.SelectedTimeForUpload?.count) {
            date = "0"
        } else {
            date = PageAppointmentViewController.SelectedTimeForUpload![0]
            amOrPm = PageAppointmentViewController.SelectedTimeForUpload![1]
        }
        
        let doctor = PageAppointmentViewController.SelectedDoctor!
        
        let ret =
            [
                "name": "\(basicInfo["name"]!)",
                "phone": "\(basicInfo["phone"]!)",
                "sex": "\(basicInfo["gender"]!)",
                "age": "\(basicInfo["age"]!)",
                "history": "\(PageAppointmentViewController.PatientCondition)",
                "doctor": "\(doctor[YMYiMaiStrings.CS_DATA_KEY_USER_ID]!)",
                "date": date,
                "am_or_pm": amOrPm
        ]
        
        return ret
    }
}































