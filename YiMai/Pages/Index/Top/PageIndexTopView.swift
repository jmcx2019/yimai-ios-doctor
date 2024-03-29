//
//  PageIndexTopView.swift
//  YiMai
//
//  Created by why on 16/4/21.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageIndexTopView: NSObject {
    private var ParentView : UIView? = nil
    private var NavController : UINavigationController? = nil
    private var Actions: PageIndexActions? = nil
    
    var TargetBody: PageIndexBodyView? = nil
    
    private var NameCardButton: YMTouchableImageView? = nil
    private var SysMessageButton: YMTouchableImageView? = nil
    public var TopSearchInput: YMTextField? = nil
    private let TopSearchImage: UIImage = UIImage(named: "CommonIconSearchHeader")!
    private let TopBackground = YMLayout.GetSuitableImageView("TopViewBackgroundNormal")
    private let MsgWithNotifyPointIcon = YMLayout.GetSuitableImageView("IndexButtonMessageHaveNew")
    private let MsgWithoutNotifyPointIcon = YMLayout.GetSuitableImageView("IndexButtonMessageEmpty")
    
    private let TopView = UIView()
    
    private static var StartRefreshMsgStatus = false
    
    convenience init(parentView: UIView, navController: UINavigationController, pageActions: PageIndexActions){
        self.init()
        self.ParentView = parentView
        self.NavController = navController
        self.Actions = pageActions
        ViewLayout()
    }

    private func ViewLayout() {
        ParentView?.addSubview(TopView)
        TopView.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 0, otherSize: 128.LayoutVal())
        DrawTopPanel()
    }
    
    private func DrawTopPanel() {
        NameCardButton = YMLayout.GetTouchableImageView(useObject: Actions!, useMethod: YMSelectors.PageJumpByImageView, imageName: "IndexButtonNameCard")
        SysMessageButton = YMLayout.GetTouchableImageView(useObject: Actions!, useMethod: YMSelectors.PageJumpByImageView, imageName: "IndexButtonMessageEmpty")
        
        NameCardButton?.UserStringData = YMCommonStrings.CS_PAGE_MY_INFO_CARD
        SysMessageButton?.UserStringData = YMCommonStrings.CS_PAGE_MASSAGE_LIST_NAME
        
        let searchInputParam = TextFieldCreateParam()
        searchInputParam.FontColor = YMColors.FontBlue
        searchInputParam.FontSize = 24.LayoutVal()
        searchInputParam.Placholder = "按医院、科室、特长等搜索医生"
        searchInputParam.BackgroundImageName = "IndexInputSearchBackground"
        
        let leftPaddingRect = CGRect(x: 0,y: 0, width: 42.LayoutVal(), height: 48.LayoutVal())
        let leftPaddingImage = YMLayout.GetSuitableImageView("CommonIconSearchHeader")
        let leftPadding = UIView(frame: leftPaddingRect)
        
        leftPadding.addSubview(leftPaddingImage)
        leftPaddingImage.anchorInCenter(width: leftPaddingImage.width, height: leftPaddingImage.height)
        TopSearchInput = YMLayout.GetTextFieldWithMaxCharCount(searchInputParam, maxCharCount: 40)
        TopSearchInput?.SetLeftPadding(leftPadding)
        
        TopSearchInput?.EditEndCallback = self.Actions?.DoSearch
        
        TopView.addSubview(TopBackground)
        TopView.addSubview(NameCardButton!)
        TopView.addSubview(SysMessageButton!)
        TopView.addSubview(TopSearchInput!)
        
        TopBackground.fillSuperview()
        NameCardButton?.anchorInCorner(Corner.BottomLeft, xPad: 30.LayoutVal(), yPad: 23.LayoutVal(), width: (NameCardButton?.width)!, height: (NameCardButton?.height)!)
        SysMessageButton?.anchorInCorner(Corner.BottomRight, xPad: 30.LayoutVal(), yPad: 23.LayoutVal(), width: (SysMessageButton?.width)!, height: (SysMessageButton?.height)!)
        TopSearchInput?.anchorInCorner(Corner.BottomLeft, xPad: 126.LayoutVal(), yPad: 19.LayoutVal(), width: 500.LayoutVal(), height: 48.LayoutVal())
    }
    
    func ShowNewMsgNotifyPoint(fromLoop: Bool = false) {
        if(PageIndexTopView.StartRefreshMsgStatus && !fromLoop) {
            return
        }
        PageIndexTopView.StartRefreshMsgStatus = true
        UpdateMsgNotifyStatus()
        
        YMDelay(1.0) { 
            self.ShowNewMsgNotifyPoint(true)
        }
    }
    
    func UpdateMsgNotifyStatus() {
        if(0 == YMVar.MyNewBroadcastInfo.count
            && 0 == YMVar.MyNewAdmissionInfo.count
            && 0 == YMVar.MyNewAppointmentInfo.count) {
            SysMessageButton?.image = MsgWithoutNotifyPointIcon.image
        } else {
            SysMessageButton?.image = MsgWithNotifyPointIcon.image
        }
        
        if(0 == YMVar.MyNewAdmissionInfo.count) {
            TargetBody?.HideNewIconForAdmission()
        } else {
            TargetBody?.ShowNewIconForAdmission()
        }
        
        if(0 == YMVar.MyNewAppointmentInfo.count) {
            TargetBody?.HideNewIconForAppointment()
        } else {
            TargetBody?.ShowNewIconForAppointment()
        }
    }
}










