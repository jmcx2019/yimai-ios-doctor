//
//  YiMaiManualAddFriendActions.swift
//  YiMai
//
//  Created by why on 16/5/26.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

public class YiMaiManualAddFriendActions: PageJumpActions{
    private var QueryByPhoneApi: YMAPIUtility? = nil
    private var QueryByCodeApi: YMAPIUtility? = nil
    private var AddFriendApi: YMAPIUtility? = nil
    
    private var TargetController: PageYiMaiManualAddFriendViewController? = nil
    
    override func ExtInit() {
        super.ExtInit()
        
        TargetController = self.Target as? PageYiMaiManualAddFriendViewController
        
        QueryByPhoneApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_QUERY_USER_BY_PHONE + "fromManualAdd",
                                       success: QuerySuccess, error: QueryError)
        
        QueryByCodeApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_QUERY_USER_BY_CODE + "fromManualAdd",
                                       success: QuerySuccess, error: QueryError)
        
        AddFriendApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_ADD_FRIEND + "fromManualAdd",
                                    success: AddSuccess, error: AddError)
    }
    
    public func AddSuccess(_: NSDictionary? ){
        
    }
    
    public func AddError(_: NSError) {
        YMPageModalMessage.ShowErrorInfo("服务器繁忙，请稍后再试", nav: self.NavController!)
    }
    
    public func QuerySuccess(data: NSDictionary?) {
        let userInfo = data!["user"] as! [String: AnyObject]
        TargetController?.BodyView?.ShowAddPage(userInfo)
    }
    
    public func QueryError(error: NSError) {
        if(nil != error.userInfo["com.alamofire.serialization.response.error.response"]) {
//            let response = error.userInfo["com.alamofire.serialization.response.error.response"]!
            let errInfo = JSON(data: error.userInfo["com.alamofire.serialization.response.error.data"] as! NSData)
            
            print(errInfo)
        } else {
            YMPageModalMessage.ShowErrorInfo("网络连接异常，请稍后再试。", nav: self.NavController!)
        }
        TargetController?.BodyView?.ClearBody()
    }
    
    public func SearchFriend(sender: UIGestureRecognizer) {
        let viewController = Target as! PageYiMaiManualAddFriendViewController
        
        let code = viewController.BodyView?.GetInputCode()
        
        if(!YMValueValidator.IsCellPhoneNum(code!)) {
            viewController.BodyView?.ShowAlertPage()
//            QueryByCodeApi?.YMQueryUserInfoById()
        } else {
            QueryByPhoneApi?.YMQueryUserByPhone(code!)
        }
//        if("" == code || code?.characters.count < 6) {
//            viewController.BodyView?.ShowAlertPage()
//        } else if("18012345678" == code) {
//            viewController.BodyView?.ShowInvitePage()
//        } else {
//            viewController.BodyView?.ShowAddPage([
//                YMYiMaiManualAddFriendStrings.CS_DATA_KEY_USERHEAD:"test",
//                YMYiMaiManualAddFriendStrings.CS_DATA_KEY_NAME:"池帅",
//                YMYiMaiManualAddFriendStrings.CS_DATA_KEY_HOSPATIL:"鸡西矿业总医院医疗集团二道河子中心医院",
//                YMYiMaiManualAddFriendStrings.CS_DATA_KEY_DEPARTMENT:"心血管外科",
//                YMYiMaiManualAddFriendStrings.CS_DATA_KEY_JOB_TITLE:"主任医师",
//                YMYiMaiManualAddFriendStrings.CS_DATA_KEY_USER_ID:"1"
//                ])
//        }
    }
    
    public func AddFriend(sender: UIGestureRecognizer) {
        let viewController = self.Target as! PageYiMaiManualAddFriendViewController
        viewController.BodyView?.ClearBody()
        viewController.BodyView?.ClearInput()
        
        let btn = sender.view as! YMTouchableView
        
        let data = btn.UserObjectData as! [String: AnyObject]
        let userId = "\(data["id"])"
        
        AddFriendApi?.YMAddFriendById(userId)

        let alertController = UIAlertController(title: "添加成功", message: "等待对方验证", preferredStyle: .Alert)
        let goBack = UIAlertAction(title: "返回", style: .Default,
            handler: {
                action in
                self.NavController?.popViewControllerAnimated(true)
        })
        
        let goOn = UIAlertAction(title: "继续添加", style: .Default,
            handler: {
                action in
        })
        
        goBack.setValue(YMColors.FontGray, forKey: "titleTextColor")
        goOn.setValue(YMColors.FontBlue, forKey: "titleTextColor")
        
        alertController.addAction(goBack)
        alertController.addAction(goOn)
        self.NavController!.presentViewController(alertController, animated: true, completion: nil)
    }
    
    public func InvitFriend(sender: UIGestureRecognizer) {
        let viewController = self.Target as! PageYiMaiManualAddFriendViewController
        viewController.BodyView?.ClearBody()
        viewController.BodyView?.ClearInput()
        
        let alertController = UIAlertController(title: "已经邀请", message: "等待对方同意", preferredStyle: .Alert)
        let goBack = UIAlertAction(title: "返回", style: .Default,
            handler: {
                action in
                self.NavController?.popViewControllerAnimated(true)
        })
        
        let goOn = UIAlertAction(title: "继续添加", style: .Default,
            handler: {
                action in
        })
        
        goBack.setValue(YMColors.FontGray, forKey: "titleTextColor")
        goOn.setValue(YMColors.FontBlue, forKey: "titleTextColor")
        
        alertController.addAction(goBack)
        alertController.addAction(goOn)
        self.NavController!.presentViewController(alertController, animated: true, completion: nil)
    }
    
    public func QRScanSuccess(qrStr: String?) {
        if(nil == qrStr) {
            return
        }
        
        YMQRRecognizer.RecognizFromQRJson(qrStr!, qrRecognizedFunc: QRRecongized, qrUnrecognizedFunc: QRUnrecongized)
    }
    
    public func QRRecongized(data: AnyObject) {
        let dataInfo = data as! [String: AnyObject]
        
        let docId = "\(dataInfo["id"]!)"
        PageAddFriendInfoCardBodyView.DoctorID = docId
        DoJump(YMCommonStrings.CS_PAGE_ADD_FRIEND_QR_CARD)
    }
    
    public func QRUnrecongized(data: AnyObject) {
        YMPageModalMessage.ShowErrorInfo("二维码非医脉信息！", nav: self.NavController!)
    }
    
    public func QRScan(sender: UIGestureRecognizer) {
        var style = LBXScanViewStyle()
        
        style.centerUpOffset = 44
        
        //扫码框周围4个角的类型设置为在框的上面
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.On
        //扫码框周围4个角绘制线宽度
        style.photoframeLineW = 6
        
        //扫码框周围4个角的宽度
        style.photoframeAngleW = 24
        
        //扫码框周围4个角的高度
        style.photoframeAngleH = 24
        
        //显示矩形框
        style.isNeedShowRetangle = true;
        
        //动画类型：网格形式，模仿支付宝
        style.anmiationStyle = LBXScanViewAnimationStyle.LineMove
        
        //网格图片
        //        style.animationImage = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_part_net"]
        
        //码框周围4个角的颜色
        style.colorAngle = YMColors.FontBlue // [UIColor colorWithRed:65./255. green:174./255. blue:57./255. alpha:1.0]
        
        //矩形框颜色
        style.colorRetangleLine = YMColors.FontGray // [UIColor colorWithRed:247/255. green:202./255. blue:15./255. alpha:1.0];
        
        //非矩形框区域颜色
        style.red_notRecoginitonArea = 247.0/255
        style.green_notRecoginitonArea = 202.0/255
        style.blue_notRecoginitonArea = 15.0/255
        style.alpa_notRecoginitonArea = 0.2
        
        let vc = LBXScanViewController()
        //        SubLBXScanViewController *vc = [SubLBXScanViewController new];
        vc.scanStyle = style
        
        //开启只识别矩形框内图像功能
        vc.isOpenInterestRect = true
        
        vc.scanSuccessHandler = QRScanSuccess
        
        self.NavController?.pushViewController(vc, animated: true)
    }
    
    public func FriendCellTouched(sender: UIGestureRecognizer) {
        
    }
}