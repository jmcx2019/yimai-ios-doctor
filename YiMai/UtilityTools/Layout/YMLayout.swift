//
//  YMCommonLayout.swift
//  YiMai
//
//  Created by why on 16/4/16.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit
import Neon
import Toucan
import Photos
import Kingfisher
import ImageViewer

public class TextFieldCreateParam {
    public var Placholder : String = ""
    public var DefaultText : String = ""
    public var Frame : CGRect = CGRect()
    public var BackgroundColor : UIColor = UIColor.whiteColor()
    public var FontSize : CGFloat = 12.0
    public var FontColor : UIColor = UIColor.blackColor()
    public var BackgroundImageName : String = ""
    public var BackgroundImage : UIImage? = nil
}

public class TextFieldPaddingParam {
    public var LeftPadding : UIView? = nil
    public var RightPadding : UIView? = nil
}

public typealias TagBuilderCB = ((tagText: String, tagInnerPadding: CGFloat, tagHeight: CGFloat, userData: AnyObject) -> UIView)

public class YMLayout {
    public static let TextFieldDelegate = YMTextFieldDelegate()

    public static func GetSuitableImageView(imageName: String) -> YMTouchableImageView {
        let suitableImageView = YMTouchableImageView(image: UIImage(named:imageName))
        
        suitableImageView.frame = CGRect(x: 0, y: 0, width: suitableImageView.width.LayoutImgVal(), height: suitableImageView.height.LayoutImgVal())
        return suitableImageView
    }
    
    public static func GetSuitableImageView(image: UIImage) -> YMTouchableImageView {
        let suitableImageView = YMTouchableImageView(image: image)
        
        suitableImageView.frame = CGRect(x: 0, y: 0, width: suitableImageView.width.LayoutImgVal(), height: suitableImageView.height.LayoutImgVal())
        return suitableImageView
    }
    
    public static func GetTouchableImageView(useObject actionTarget: AnyObject, useMethod actionFunc: Selector, imageName: String) -> YMTouchableImageView{
        let newImageView = YMLayout.GetSuitableImageView(imageName)
        let tapGR = UITapGestureRecognizer(target: actionTarget, action: actionFunc)
        
        newImageView.userInteractionEnabled = true
        newImageView.addGestureRecognizer(tapGR)

        return newImageView
    }
    
    public static func GetTouchableImageView(useObject actionTarget: AnyObject, useMethod actionFunc: Selector, image: UIImage) -> YMTouchableImageView{
        let newImageView = YMLayout.GetSuitableImageView(image)
        let tapGR = UITapGestureRecognizer(target: actionTarget, action: actionFunc)
        
        newImageView.userInteractionEnabled = true
        newImageView.addGestureRecognizer(tapGR)
        
        return newImageView
    }
    
    public static func GetTouchableView(useObject actionTarget: AnyObject, useMethod actionFunc: Selector,
                                                  userStringData: String = "", backgroundColor: UIColor = YMColors.White) -> YMTouchableView {
        let newView = YMTouchableView()

        newView.UserStringData = userStringData
        let tapGR = UITapGestureRecognizer(target: actionTarget, action: actionFunc)

        newView.userInteractionEnabled = true
        newView.addGestureRecognizer(tapGR)
        newView.backgroundColor = backgroundColor

        return newView
    }
    
    static func GetScrollCell(useObject actionTarget: AnyObject, useMethod actionFunc: Selector,
                                                  userStringData: String = "", backgroundColor: UIColor = YMColors.White) -> YMScrollCell {
        let newView = YMScrollCell()
        
        newView.UserStringData = userStringData
        let tapGR = UITapGestureRecognizer(target: actionTarget, action: actionFunc)
        
        newView.userInteractionEnabled = true
        newView.addGestureRecognizer(tapGR)
        newView.backgroundColor = backgroundColor
        
        return newView
    }
    
    public static func GetTextField(param: TextFieldCreateParam) -> YMTextField {
        let newTextField = YMTextField(aDelegate: nil)

        newTextField.placeholder = param.Placholder
        newTextField.font = UIFont.systemFontOfSize(param.FontSize)
        newTextField.textColor = param.FontColor
        newTextField.delegate = YMLayout.TextFieldDelegate
        newTextField.text = ""
        
        if(nil != param.BackgroundImage) {
            newTextField.background = param.BackgroundImage
        } else if ("" != param.BackgroundImageName) {
            newTextField.background = UIImage(named: param.BackgroundImageName)
        } else {
            newTextField.backgroundColor = param.BackgroundColor
        }
        
        return newTextField
    }
    
    public static func GetTextFieldWithMaxCharCount(createParam: TextFieldCreateParam, maxCharCount: Int) -> YMTextField {
        let textField = YMLayout.GetTextField(createParam)
        textField.MaxCharCount = maxCharCount
        
        return textField
    }
    
    public static func GetCellPhoneField(param: TextFieldCreateParam) -> YMTextField {
        let newTextField = YMLayout.GetTextFieldWithMaxCharCount(param, maxCharCount: 13)
        newTextField.keyboardType = UIKeyboardType.NumberPad

        return newTextField
    }
    
    public static func GetPasswordField(createParam: TextFieldCreateParam) ->  YMTextField {
        let textField = YMLayout.GetTextField(createParam)
        textField.secureTextEntry = true
        return textField
    }
    
    public static func GetPasswordFieldWithMaxCharCount(createParam: TextFieldCreateParam, maxCharCount: Int) ->  YMTextField {
        let textField = YMLayout.GetPasswordField(createParam)
        textField.MaxCharCount = maxCharCount
        return textField
    }
    
    public static func GetStoryboardControllerByName(storyboardName: String) -> UIViewController? {
        let newStroyboard = UIStoryboard(name: storyboardName, bundle: nil)

        return newStroyboard.instantiateInitialViewController()
    }
    
    public static func BodyLayoutWithTop(parentView: UIView, bodyView: UIScrollView) {
        parentView.addSubview(bodyView)
        bodyView.backgroundColor = YMColors.BackgroundGray
        bodyView.fillSuperview()
        bodyView.contentInset = YMSizes.PageScrollBodyInsetOnlyTop
    }
    
    public static func BodyLayoutWithTopAndBottom(parentView: UIView, bodyView: UIScrollView) {
        parentView.addSubview(bodyView)
        bodyView.backgroundColor = YMColors.BackgroundGray
        bodyView.fillSuperview()
        bodyView.contentInset = YMSizes.PageScrollBodyInset
    }
    
    public static func DrawGrayVerticalSpace(parentView: UIView, height: CGFloat, relativeTo: UIView? = nil) -> UIView {
        let spaceView = UIView()
        spaceView.backgroundColor = YMColors.BackgroundGray
        
        parentView.addSubview(spaceView)
        if(nil != relativeTo){
            spaceView.align(Align.UnderMatchingLeft, relativeTo: relativeTo!, padding: 0, width: parentView.width, height: height)
        } else {
            spaceView.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 0, otherSize: height)
        }
        
        return spaceView
    }
    
    public static func ClearView(view target: UIView) {
        for view in target.subviews{
            let v = view as? YMTouchableView
            v?.UserObjectData = nil
            v?.UserStringData = ""
            view.removeFromSuperview()
        }
    }
    
    public static func SetViewHeightByLastSubview(view: UIView, lastSubView: UIView?, bottomPadding: CGFloat = 0) {
        if(nil == lastSubView) {
            return
        }
        let viewPoint = view.frame.origin
        view.frame = CGRectMake(viewPoint.x, viewPoint.y, view.width,
                                lastSubView!.height + lastSubView!.frame.origin.y + bottomPadding)
    }
    
    public static func SetViewWidthBySubview(view: UIView, subView: UIView, padding: CGFloat = 0) {
        let viewPoint = view.frame.origin
        view.frame = CGRectMake(viewPoint.x, viewPoint.y, subView.width + padding * 2,
                                view.height)
    }
    
    public static func SetHScrollViewContentSize(scrollView: UIScrollView, lastSubView: UIView?, padding: CGFloat = 0) {
        if(nil == lastSubView) { return }
        scrollView.contentSize = CGSizeMake(lastSubView!.width + lastSubView!.frame.origin.x + padding,
                                            scrollView.height)
    }
    
    public static func SetVScrollViewContentSize(scrollView: UIScrollView, lastSubView: UIView?, padding: CGFloat = 0) {
        if(nil == lastSubView) { return }
        scrollView.contentSize = CGSizeMake(scrollView.width,
                                            lastSubView!.height + lastSubView!.frame.origin.y + padding)
        
        if(scrollView.isKindOfClass(YMBodyTableView)) {
            let view = scrollView as! YMBodyTableView
            view.BodyViewContentSize = scrollView.contentSize
        }
    }

    public static func GetCommonFullWidthTouchableView(
        parentView: UIView,
        useObject: AnyObject,
        useMethod: Selector,
        label: UILabel,
        text: String,
        userStringData: String = "",
        fontSize: CGFloat = 28.LayoutVal(),
        showArrow: Bool = true) -> YMTouchableView {
        
        let view = YMLayout.GetTouchableView(useObject: useObject, useMethod: useMethod, userStringData: userStringData)
        let borderBottom = UIView()
        
        borderBottom.backgroundColor = YMColors.CommonBottomGray
        
        label.text = text
        label.font = YMFonts.YMDefaultFont(fontSize)
        label.textColor = YMColors.FontGray
        label.sizeToFit()
        
        parentView.addSubview(view)
        view.addSubview(label)
        view.addSubview(borderBottom)
        
        view.frame = CGRect(x: 0,y: 0,width: YMSizes.PageWidth, height: YMSizes.CommonTouchableViewHeight)
        label.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: 650.LayoutVal(), height: label.height)
        borderBottom.anchorToEdge(Edge.Bottom, padding: 0, width: YMSizes.PageWidth, height: YMSizes.OnPx)
        
        if(showArrow) {
            let arrow = YMLayout.GetSuitableImageView("CommonRightArrowIcon")
            view.addSubview(arrow)
            arrow.anchorToEdge(Edge.Right, padding: 40.LayoutVal(), width: arrow.width, height: arrow.height)
        }
        
        return view
    }
    
    public static func GetCommonLargeFullWidthTouchableView(
        parentView: UIView,
        useObject: AnyObject,
        useMethod: Selector,
        label: UILabel,
        text: String,
        userStringData: String = "",
        fontSize: CGFloat = 28.LayoutVal(),
        showArrow: Bool = true) -> YMTouchableView {
            
            let view = YMLayout.GetTouchableView(useObject: useObject, useMethod: useMethod, userStringData: userStringData)
            let borderBottom = UIView()
            
            borderBottom.backgroundColor = YMColors.CommonBottomGray
            
            label.text = text
            label.font = YMFonts.YMDefaultFont(fontSize)
            label.textColor = YMColors.FontGray
            label.sizeToFit()
            
            parentView.addSubview(view)
            view.addSubview(label)
            view.addSubview(borderBottom)
            
            view.frame = CGRect(x: 0,y: 0,width: YMSizes.PageWidth, height: YMSizes.CommonLargeTouchableViewHeight)
            label.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: 650.LayoutVal(), height: label.height)
            borderBottom.anchorToEdge(Edge.Bottom, padding: 0, width: YMSizes.PageWidth, height: YMSizes.OnPx)
            
            if(showArrow) {
                let arrow = YMLayout.GetSuitableImageView("CommonRightArrowIcon")
                view.addSubview(arrow)
                arrow.anchorToEdge(Edge.Right, padding: 40.LayoutVal(), width: arrow.width, height: arrow.height)
            }
            
            return view
    }
    
    public static func GetCommonUserHeadImage(url: String, useObject: AnyObject? = nil, useMethod: Selector? = nil) -> YMTouchableImageView {
        var userHead: YMTouchableImageView? = nil
        if(nil == useObject){
            userHead = YMLayout.GetSuitableImageView("CommonHeadImageBorder")
        } else {
            userHead = YMLayout.GetTouchableImageView(useObject: useObject!, useMethod: useMethod!, imageName: "CommonHeadImageBorder")
        }
        
        let fullUrlString = YMAPIInterfaceURL.Server + url
        let urlObj = NSURL(string: fullUrlString)
        
        userHead!.setImageWithURL(urlObj!)
        
        return userHead!
    }
    
    public static func GetYMPanelTitleLabel(title: String, fontColor: UIColor, fontSize: CGFloat, backgroundColor: UIColor,
                                             height: CGFloat, paddingLeft: CGFloat, panel: UIView) -> YMTouchableView {
        let titleView = YMTouchableView()
        let titleLabel = UILabel()
        
        panel.addSubview(titleView)
        titleView.anchorToEdge(Edge.Top, padding: 0, width: panel.width, height: height)
        titleView.backgroundColor = backgroundColor
        
        titleLabel.text = title
        titleLabel.font = YMFonts.YMDefaultFont(fontSize)
        titleLabel.textColor = fontColor
        titleLabel.sizeToFit()
        
        titleView.addSubview(titleLabel)
        titleLabel.anchorToEdge(Edge.Left, padding: paddingLeft, width: titleLabel.width, height: titleLabel.height)
        
        titleView.UserStringData = title
        titleView.UserObjectData = ["label": titleLabel]
        
        return titleView
    }
    
    public static func GetYMTouchableCell(placeholder: String, padding: CGFloat, showArrow: Bool,
                                    action: AnyObject, method: Selector,
                                    width: CGFloat, height: CGFloat,
                                    fontSize: CGFloat, panel: UIView) -> YMTouchableView {
        let cell = YMLayout.GetTouchableView(useObject: action, useMethod: method)
        let label = UILabel()
        
        panel.addSubview(cell)
        cell.anchorToEdge(.Top, padding: 0, width: width, height: height)
        
        label.text = placeholder
        label.textColor = YMColors.FontLightGray
        label.font = YMFonts.YMDefaultFont(fontSize)
        label.sizeToFit()
        
        cell.addSubview(label)
        label.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: label.width, height: label.height)
        
        if(showArrow) {
            let arrow = YMLayout.GetSuitableImageView("CommonRightArrowIcon")
            cell.addSubview(arrow)
            arrow.anchorToEdge(Edge.Right, padding: 40.LayoutVal(), width: arrow.width, height: arrow.height)
        }
        
        cell.UserObjectData = ["label": label]
        return cell
    }
    
    public static func SetHeadImageVFlag(imageView: YMTouchableImageView) {
        let v = YMLayout.GetSuitableImageView("YiMaiGeneralVFlag")
        imageView.addSubview(v)
        v.anchorInCorner(Corner.BottomRight, xPad: 0, yPad: 0, width: v.width, height: v.height)
    }
    
    public static func SetSelfHeadImageVFlag(headView: YMTouchableImageView) {
        let authStatus = YMVar.GetStringByKey(YMVar.MyUserInfo, key: "is_auth")
        YMLayout.ClearView(view: headView)
        if(YMValueValidator.IsAuthed(authStatus)) {
            YMLayout.SetHeadImageVFlag(headView)
        }
    }
    
    public static func SetDocfHeadImageVFlag(headView: YMTouchableImageView, docInfo: [String: AnyObject]) {
        let authStatus = YMVar.GetStringByKey(docInfo, key: "is_auth")
        YMLayout.ClearView(view: headView)
        if(YMValueValidator.IsAuthed(authStatus)) {
            YMLayout.SetHeadImageVFlag(headView)
        }
    }
    
    public static func LoadImageFromServer(imageView: UIImageView, url urlSegment: String, fullUrl: String? = nil, makeItRound: Bool = false, refresh: Bool = false) {
        var url = urlSegment
        
        var urlArr = url.componentsSeparatedByString("Optional(")
        if(1 < urlArr.count) {
            url = urlArr[0]
            let url2 = urlArr[1]
            let urlArr2 = url2.componentsSeparatedByString(")")
            
            url += urlArr2[0]
        }
        
        if(nil != fullUrl) {
            url = fullUrl!
        } else if(!url.containsString("http")) {
            url = YMAPIInterfaceURL.Server + url
//            url = YMAPIInterfaceURL.Server + url
        }

        if(refresh) {
            let cache = KingfisherManager.sharedManager.cache
            cache.removeImageForKey(url)
            url += "?t=" + "\(NSDate().timeIntervalSince1970)"
        }

        let imgUrl = NSURL(string: url)
        if(nil != imgUrl) {
            var opt: KingfisherOptionsInfo = [KingfisherOptionsInfoItem]()
            if(refresh) {
                opt.append(KingfisherOptionsInfoItem.ForceRefresh)
            }
            imageView.kf_setImageWithURL(NSURL(string: url)!, placeholderImage: imageView.image, optionsInfo: opt, progressBlock: nil,  completionHandler: { (image, error, cacheType, imageURL) in
                if(makeItRound) {
                    if(nil != image) {
                        imageView.image = Toucan(image: image!)
                            .resize(CGSize(width: imageView.width, height: imageView.height), fitMode: Toucan.Resize.FitMode.Crop)
                            .maskWithEllipse().image
                    }
                }
            })
        }
    }
    
    public static func GetNomalLabel(text: String?, textColor: UIColor, fontSize: CGFloat, maxWidth: CGFloat = 0) -> YMLabel {
        let label = YMLabel()
        label.text = text
        label.textColor = textColor
        label.font = YMFonts.YMDefaultFont(fontSize)
        
        if(maxWidth > 0) {
            label.numberOfLines = 0
            label.frame = CGRect(x: 0, y: 0, width: maxWidth, height: 0)
        }
        label.sizeToFit()

        return label
    }
    
    public static func TransPHAssetToUIImage(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.defaultManager()
        let option = PHImageRequestOptions()
        var img = UIImage()
        option.synchronous = true
        let targetWidth = asset.pixelWidth.LayoutVal()
        let targetHeight = asset.pixelHeight.LayoutVal()

        manager.requestImageForAsset(asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight),
                                     contentMode: .AspectFit, options: option, resultHandler: {(result, info)->Void in
            img = Toucan(image: result!).resize(CGSize(width: targetWidth, height: targetHeight)).image
        })
        
        return img
    }
    
    public static func TransPHAssetsToUIImages(assets: [PHAsset]) -> [UIImage] {
        var ret = [UIImage]()
        
        for asset in assets {
            ret.append(YMLayout.TransPHAssetToUIImage(asset))
        }
        return ret
    }
    
    public static func GetGrayImageView(imageName: String) -> YMTouchableImageView {
        let filter = CIFilter(name: "CIPhotoEffectTonal")
        let context = CIContext(options: nil)
        let inputImage = CIImage(image: UIImage(named: imageName)!)
        filter!.setValue(inputImage, forKey: kCIInputImageKey)
        let outputImage =  filter!.outputImage
        let cgImage = context.createCGImage(outputImage!,
                                            fromRect: outputImage!.extent)
        
        return YMLayout.GetSuitableImageView(UIImage(CGImage: cgImage))
    }
    
    public static func GetScaledImageData(img: UIImage) -> NSData {
        
        var imgForProcess = img
        if(img.size.width > 800 && img.size.height > 800) {
            imgForProcess = Toucan(image: imgForProcess).resize(CGSize(width: 800, height: 800), fitMode: Toucan.Resize.FitMode.Clip).image
        }
        
        var imgData = UIImageJPEGRepresentation(imgForProcess, 1.0)
        
        if (imgData!.length > 100*1024) {
            if (imgData!.length>1024*1024) {//1M以及以上
                imgData = UIImageJPEGRepresentation(imgForProcess, 0.1)
            }else if (imgData!.length > 512*1024) {//0.5M-1M
                imgData = UIImageJPEGRepresentation(imgForProcess, 0.5)
                
            }else if (imgData!.length > 200*1024) {//0.25M-0.5M
                imgData = UIImageJPEGRepresentation(imgForProcess, 0.9)
            }
        }
        
        return imgData!
    }
    
    /*!
     @param : tags : 这个是标签的数据
     @param : tagPanel : 这个是标签列表的父级 UIView
     @param : lineWidth : 这个是标签的一行的长度
     @param : lineHeight : 这个是标签的行高，所有的标签高度会充满行高
     @param : firstLineXPos : 第一行标签的左上角的 X 坐标值
     @param : firstLineYPos : 第一行标签的左上角的 Y 坐标值
     @param : lineSpace : 行间距，第一行总是按照上面两个参数进行位置布局，这个参数是控制从第二行开始，距离上一行的间距用的
     @param : tagSpace : 标签间距，这个是两个标签之间的间距
     @param : tagInnerPadding : 这个是标签的左右内边距
     @param : lineJustified : 这个是标签是否两端对齐，如果是的话，那么 tagSpace 的设定值无效，会自动计算两端对齐需要的标签间距
     @param : maxTagsInLine : 这个是一行最多排布几个标签，无论此行的剩余空间是否还能继续放下一个标签
     */
    public static func DrawTagList(tags : NSArray, tagPanel: UIView, tagBuilder: TagBuilderCB,
                                   lineWidth: CGFloat, lineHeight: CGFloat,
                                   firstLineXPos: CGFloat, firstLineYPos: CGFloat, lineSpace: CGFloat,
                                   tagSpace: CGFloat, tagInnerPadding: CGFloat,
                                   lineJustified: Bool = false, maxTagsInLine: Int = Int.max) -> UIView? {
        func GetTagFullWidth(tagLabel: UIView) -> CGFloat{
            return tagLabel.width
        }
        
        for view in tagPanel.subviews {
            view.removeFromSuperview()
        }
        var labelArray = [UIView]()
        var widthArray = [CGFloat]()
        var lineArray = [[Int]]()
        var lineViewArray = [UIView]()
        
        let listLineWidth = lineWidth
        let listLineHeight = lineHeight
        
        if(0 == tags.count) {
            return nil
        }
        
        let tagSorted = tags.sort { (a, b) -> Bool in
            let nameA = a as! String
            let nameB = b as! String
            return nameA.characters.count > nameB.characters.count
        }
        
        for tag in tagSorted {
            let tagName = tag as! String
            if(YMValueValidator.IsEmptyString(tagName)) {continue}
            let tagLabel = tagBuilder(tagText: tagName, tagInnerPadding: tagInnerPadding, tagHeight: lineHeight, userData: tag)
            labelArray.append(tagLabel)
            widthArray.append(GetTagFullWidth(tagLabel))
        }
        
        for (idx, val) in widthArray.enumerate() {
            var newLineFlag = true
            
            for (lIdx, lVal) in lineArray.enumerate() {
                var allTagWidth:CGFloat = 0
                for tagIdx in lVal {
                    allTagWidth += widthArray[tagIdx]
                }
                
                if((allTagWidth + val + CGFloat(lineArray[lIdx].count - 1) * tagSpace) < listLineWidth) {
                    if(maxTagsInLine > lineArray[lIdx].count) {
                        newLineFlag = false
                        lineArray[lIdx].append(idx)
                        break
                    }
                }
            }
            
            if(newLineFlag) {
                var newLine = [Int]()
                newLine.append(idx)
                lineArray.append(newLine)
            }
        }
        
        var tagPaddingByLine = [CGFloat]()
        if(true == lineJustified) {
            for (_, lVal) in lineArray.enumerate() {
                var lineTagWidth: CGFloat = 0.0
                var tagCount: CGFloat = 0
                for (_, val) in lVal.enumerate() {
                    let tagLabel = labelArray[val]
                    lineTagWidth += GetTagFullWidth(tagLabel)
                    tagCount += 1
                }
                
                if(tagCount > 1){
                    tagPaddingByLine.append((lineWidth - lineTagWidth) / (tagCount - 1))
                } else {
                    tagPaddingByLine.append(0)
                }
            }
        } else {
            for (_, _) in lineArray.enumerate() {
                tagPaddingByLine.append(tagSpace)
            }
        }
        
        var lastLine: UIView? = nil
        for (lIdx, lVal) in lineArray.enumerate() {
            let lineView = UIView()
            lineViewArray.append(lineView)
            tagPanel.addSubview(lineView)
            if(0 == lIdx) {
                lineView.anchorInCorner(Corner.TopLeft, xPad: firstLineXPos, yPad: firstLineYPos, width: listLineWidth, height: listLineHeight)
            } else {
                let prevLine = lineViewArray[lIdx - 1]
                lineView.align(Align.UnderMatchingLeft, relativeTo: prevLine, padding: lineSpace, width: listLineWidth, height: listLineHeight)
            }
            
            lastLine = lineView
            
            var prevLabel: UIView? = nil
            let tagPadding = tagPaddingByLine[lIdx]
            for (idx, val) in lVal.enumerate() {
                let tagLabel = labelArray[val]
                lineView.addSubview(tagLabel)
                if(0 == idx) {
                    tagLabel.anchorToEdge(Edge.Left, padding: 0, width: widthArray[val], height: listLineHeight)
                } else {
                    tagLabel.align(Align.ToTheRightCentered, relativeTo: prevLabel!, padding: tagPadding, width: widthArray[val], height: listLineHeight)
                }
                prevLabel = tagLabel
            }
        }
        
//        YMLayout.SetViewHeightByLastSubview(tagPanel, lastSubView: lastLine!)
//        YMLayout.SetViewWidthBySubview(tagPanel, subView: lastLine!, padding: firstLineXPos / 2)
        return lastLine
    }
    
    static func DefaultGalleryConfiguration() -> GalleryConfiguration {
        
        let dividerWidth = GalleryConfigurationItem.ImageDividerWidth(10)
        let spinnerColor = GalleryConfigurationItem.SpinnerColor(UIColor.whiteColor())
        let spinnerStyle = GalleryConfigurationItem.SpinnerStyle(UIActivityIndicatorViewStyle.White)
        
        let closeButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 40.LayoutVal(), height: 40.LayoutVal())))
        closeButton.setImage(UIImage(named: "YMIconCloseBtn"), forState: UIControlState.Normal)
        closeButton.setImage(UIImage(named: "YMIconCloseBtn"), forState: UIControlState.Highlighted)
        let closeButtonConfig = GalleryConfigurationItem.CloseButton(closeButton)
        
        //        let seeAllButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 50)))
        //        seeAllButton.setTitle("显示全部", forState: .Normal)
        //        let seeAllButtonConfig = GalleryConfigurationItem.SeeAllButton(seeAllButton)
        
        let pagingMode = GalleryConfigurationItem.PagingMode(GalleryPagingMode.Standard)
        
        let closeLayout = GalleryConfigurationItem.CloseLayout(ButtonLayout.PinRight(40, 40))
        //        let seeAllLayout = GalleryConfigurationItem.CloseLayout(ButtonLayout.PinLeft(8, 16))
        let headerLayout = GalleryConfigurationItem.HeaderViewLayout(HeaderLayout.Center(25))
        let footerLayout = GalleryConfigurationItem.FooterViewLayout(FooterLayout.Center(25))
        
        let statusBarHidden = GalleryConfigurationItem.StatusBarHidden(true)
        
        let hideDecorationViews = GalleryConfigurationItem.HideDecorationViewsOnLaunch(false)
        
        let backgroundColor = GalleryConfigurationItem.BackgroundColor(YMColors.OpacityBlackMask)
        
        return [dividerWidth, spinnerStyle, spinnerColor, closeButtonConfig, pagingMode, headerLayout, footerLayout, closeLayout, statusBarHidden, hideDecorationViews, backgroundColor]
    }
    
    static func GetUnreadCountLabel(count: Int) -> YMLabel {
        let label = YMLabel()
        if(count < 1000) {
            label.text = "\(count)"
        } else {
            label.text = "999+"
        }
        label.textColor = YMColors.White
        label.backgroundColor = YMColors.WarningFontColor
        label.font = YMFonts.YMDefaultFont(20.LayoutVal())
        label.sizeToFit()
        
        label.textAlignment = NSTextAlignment.Center
        
        label.frame = CGRect(x: 0, y: 0, width: label.width + 20.LayoutVal(), height: 28.LayoutVal())
        label.SetSemicircleBorder()
        
        return label
    }
    
    static func GetDiscussionImgLayoutIdxArr(idList: String) -> [Int] {
        var ret = [Int]()
        let ids = idList.componentsSeparatedByString(",")

        switch ids.count {
        case 0:
            break
        case 1:
            break
            
        case 2:
            ret.append(2)
            
        case 3:
            ret.append(2)
            ret.append(1)
            
        case 4:
            ret.append(2)
            ret.append(2)
            
        case 5:
            ret.append(3)
            ret.append(2)
            
        case 6:
            ret.append(3)
            ret.append(3)
            
        case 7:
            ret.append(3)
            ret.append(3)
            ret.append(1)
            
        case 8:
            ret.append(3)
            ret.append(3)
            ret.append(2)
            
        case 9:
            fallthrough
        default:
            ret.append(3)
            ret.append(3)
            ret.append(3)
        }
        
        return ret
    }
    
    static func GetDiscussionHeadimg(idList: String, panel: UIView) {
        
        let imgArr = YMLayout.GetDiscussionImgLayoutIdxArr(idList)
        if(0 == imgArr.count) {
            return
        }
        
        YMLayout.ClearView(view: panel)
        
        var rowList = [UIView]()

        for _ in imgArr {
            let rowPanel = UIView()
            panel.addSubview(rowPanel)
            rowList.append(rowPanel)
        }
        
        panel.groupAndFill(group: Group.Vertical, views: rowList.map({$0}), padding: 2)
        
        panel.layer.cornerRadius = 10.LayoutVal()
        panel.layer.masksToBounds = true
        
        var rowIdx: Int = 0
        var imgIdx: Int = 0
        var ids = idList.componentsSeparatedByString(",")
        var prevColSize = panel.height
        for colCnt in imgArr {
            let rowPanel = rowList[rowIdx]
            var colSize = (rowPanel.width / CGFloat(colCnt)) - 2
            rowIdx += 1
            
            if(colSize > prevColSize) {
                colSize = prevColSize
            } else {
                prevColSize = colSize
            }
            
            var colList = [YMTouchableImageView]()
            for _ in 1 ... colCnt {
                let userId = ids[imgIdx]

                let imgCell = YMLayout.GetSuitableImageView("YiMaiDefaultHead")
                imgCell.frame = CGRect(x: 0, y: 0, width: colSize, height: colSize)
                imgCell.UserStringData = YMVar.GetLocalUserHeadurl(userId)
                rowPanel.addSubview(imgCell)
                colList.append(imgCell)
                imgIdx += 1
            }
            
            rowPanel.groupInCenter(group: Group.Horizontal, views: colList.map({$0}), padding: 2, width: colSize, height: colSize)
            
            for img in colList {
                YMLayout.LoadImageFromServer(img, url: img.UserStringData, fullUrl: nil, makeItRound: true)
            }
        }
    }
}



























