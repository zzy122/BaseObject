//
//  ViewExtension.swift
//  SmallSheep
//
//  Created by kfzs on 2018/8/9.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
//MARK: -颜色渐变
enum GradualColorDirectionType:Int {//渐变方向
    case horizontal = 100
    case vertical = 200
}
enum ShowBlankType:Int{
    case normal = 5
    case refresh = 6
}
extension UIView
{
    private struct RuntimeKey {
        static let imageKey = UnsafeRawPointer.init(bitPattern: "imageKey".hashValue)
        static let btnKey = UnsafeRawPointer.init(bitPattern: "bottonKey".hashValue)
        static let labKey = UnsafeRawPointer.init(bitPattern: "lableKey".hashValue)
        static let backViewKey = UnsafeRawPointer.init(bitPattern: "bakKey".hashValue)
        static let styleKey = UnsafeRawPointer.init(bitPattern: "styleKey".hashValue)
        
        static let tapGesterKey = UnsafeRawPointer.init(bitPattern: "tapGesterKey".hashValue)//
        static let tapKey = UnsafeRawPointer.init(bitPattern: "tapKey".hashValue)//
    }
    var blackBackView:UIView?//背景view
    {
        set{
            newValue?.frame = bounds
            objc_setAssociatedObject(self,RuntimeKey.backViewKey!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return (objc_getAssociatedObject(self, RuntimeKey.backViewKey!) as? UIView)
        }
    }
    var blankImageView:UIImageView?//占位图
    {
        set{
            objc_setAssociatedObject(self, RuntimeKey.imageKey!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return (objc_getAssociatedObject(self, RuntimeKey.imageKey!) as? UIImageView)
        }
    }
    var blankDescLab:UILabel?//占位提示控件
    {
        set{
            objc_setAssociatedObject(self, RuntimeKey.labKey!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return (objc_getAssociatedObject(self , RuntimeKey.labKey!) as? UILabel)
        }
    }
    var descBtn:UIButton?//占位提示控件
    {
        set{
            objc_setAssociatedObject(self, RuntimeKey.btnKey!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return (objc_getAssociatedObject(self , RuntimeKey.btnKey!) as? UIButton)
        }
    }

    func showBlanckView(backColor:UIColor){
        self.showBlanckView()
        self.blackBackView?.backgroundColor = backColor
    }
    func showBlanckView(showType:ShowBlankType = .normal,clickRefresh:(() -> Void)? = nil)//显示
    {
        if self.blackBackView != nil{}
        else{
            self.blackBackView = {
                let view:UIView = UIView.init(frame: self.bounds)
                view.backgroundColor = UIColor.white
                return view
            }()
        }

        if self.blankImageView != nil{}
        else
        {
            self.blankImageView = {
                let image:UIImage? = imageName(name: "无数据")
                let IMV:UIImageView = UIImageView.init(frame: CGRect.init(x: (bounds.width - (image?.size.width ?? 0.0)) / 2.0, y: (bounds.height - (image?.size.height ?? 30)) / 2.0 - 30, width: image?.size.width ?? 0.0, height: image?.size.height ?? 0.0))
                IMV.image = image
                IMV.tap {
                    DebugLog(message: "kkkkk")
                }
                return IMV
            }()
        }
        if self.blankDescLab == nil{
            self.blankDescLab = {
                let title =  (showType == .refresh ? "网络加载失败,请刷新" : "还没有数据哦~")
                let width:CGFloat = title.zzy.caculateWidth(font: kFont_system11)
                let lab = UILabel()
                lab.frame = CGRect.init(x: (bounds .width - width - 20) / 2.0, y: (self.blankImageView?.frame.maxY)! + 5, width: width + 20, height: 30)
                lab.textColor = UIColor.gray
                lab.text = title
                lab.textAlignment = NSTextAlignment.center
                lab.font = kFont_system11
                lab.backgroundColor = UIColor.clear
                return lab
            }()
        }
        if self.descBtn != nil{}
        else{
            self.descBtn =  {
                let title = "刷新"
                let width:CGFloat = title.zzy.caculateWidth(font: kFont_system11)
                let btn:UIButton = UIButton.init(frame: CGRect.init(x: (bounds .width - width - 20) / 2.0, y: (self.blankImageView?.frame.maxY)! + 5, width: width + 20, height: 34))
                btn.setTitleColor(k_CustomColor(red: 0, green: 94, blue: 181), for: UIControl.State.normal)
                btn.setTitle(title, for: UIControl.State.normal)
                btn.layer.cornerRadius = 8
                btn.layer.borderColor = k_CustomColor(red: 0, green: 94, blue: 181).cgColor
                btn.layer.borderWidth = 1.0
                btn.titleLabel?.font = kFont_system11
                btn.tap{
                    clickRefresh?()
                }
                btn.backgroundColor = UIColor.clear
                return btn
                }()
        }
        self.blankDescLab?.removeFromSuperview()
        self.blankImageView?.removeFromSuperview()
        self.descBtn?.removeFromSuperview()
        self.blackBackView?.removeFromSuperview()
        self.blackBackView?.frame = CGRect.init(x: 0, y: 0, width: bounds.width, height: bounds.height)
        let imageFrame:CGRect = CGRect.init(x: (bounds.width - 150) / 2.0, y: (bounds.height - 100) / 2.0 - 30, width:150, height: 100)
        self.blankImageView?.frame = imageFrame
        let labWidth:CGFloat = self.blankDescLab?.text?.zzy.caculateWidth(font: kFont_system15) ?? 0.0
        let labFrame = CGRect.init(x: (bounds .width - labWidth - 20) / 2.0, y: (self.blankImageView!.frame.maxY) + 5, width: labWidth + 20, height: 30)
        self.blankDescLab?.frame = labFrame
        let btnWidth:CGFloat = self.descBtn?.titleLabel?.text?.zzy.caculateWidth(font: kFont_system15) ?? 0.0
        let desBtnFrame = CGRect.init(x: (bounds .width - btnWidth - 40) / 2.0, y: (labFrame.maxY) + 20, width: btnWidth + 40, height: 34)
        self.descBtn?.frame = desBtnFrame
        self.addSubview(self.blackBackView!)
        blackBackView!.addSubview(self.blankImageView!)
        blackBackView!.addSubview(self.blankDescLab!)
        if showType == .refresh{
            blackBackView!.addSubview(self.descBtn!)
        }
    }

    func hiddenBlackView()//隐藏
    {
        self.blackBackView?.removeFromSuperview()
    }
}
extension UIView{//圆角
    //圆角 支持自定义单个圆角
    func addCorners(roundCorners:UIRectCorner,cornerSize:CGSize)
    {
        let path = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: roundCorners, cornerRadii: cornerSize)
        let corLayer = CAShapeLayer()
        corLayer.path = path.cgPath
        corLayer.frame = bounds
        layer.mask = corLayer
    }
}
extension UIView{//颜色渐变
    func gradualColor(colors:[UIColor],direction:GradualColorDirectionType)
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        var cgColors:[CGColor] = []
        for i in 0 ..< colors.count {
            cgColors.append(colors[i].cgColor)
        }
        gradientLayer.colors = cgColors
        if direction == .horizontal{
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0)
        }
        else{
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1.0)
        }
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
extension UIView{//点击事件
    private var tapgester:UITapGestureRecognizer?{
        set{
            objc_setAssociatedObject(self, RuntimeKey.tapGesterKey!, newValue,  objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, RuntimeKey.tapGesterKey!) as? UITapGestureRecognizer
        }
    }
    fileprivate var zzyTapAction:(() -> Void)?{
        set{
            objc_setAssociatedObject(self, RuntimeKey.tapKey!, newValue,  objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, RuntimeKey.tapKey!) as? (() -> Void)
        }
    }
    @objc private func click_tapMySelf(){
        self.zzyTapAction?()
    }
    func tap(tapComplection:@escaping () -> Void){//点击事件
        if self.tapgester == nil {
            self.tapgester = UITapGestureRecognizer.init(target: self, action: #selector(click_tapMySelf))
            self.addGestureRecognizer(tapgester!)
        }
        self.isUserInteractionEnabled = true
        self.zzyTapAction = tapComplection
    }
}
extension UIView{//View ->图片
    func zzyImage() ->UIImage{
        let size:CGSize = self.bounds.size
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let rect:CGRect = self.frame
        self.drawHierarchy(in: rect, afterScreenUpdates: true)
        let imageTag = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageTag!
    }
    /// 虚线边框
    ///
    /// - Parameters:
    ///   - color: 边框颜色
    ///   - width: 边框宽度
    ///   - dashPartten: 虚线样式
    func dashBorder(_ color: CGColor = "cccccc".zzy.hexToColor().cgColor,
                           _ width: CGFloat = 1 / UIScreen.main.scale,
                           _ dashPartten: [NSNumber] = [4, 2],
                           _ lineCap: String = "square",
                           frame: CGRect) {
        let border = CAShapeLayer()
        border.strokeColor = color
        border.fillColor = nil
        border.path = UIBezierPath(rect: frame).cgPath
        border.frame = frame
        border.lineWidth = width
        border.lineCap = CAShapeLayerLineCap(rawValue: "lineCap")
        border.lineDashPattern = dashPartten
        self.layer.addSublayer(border)
    }
}
