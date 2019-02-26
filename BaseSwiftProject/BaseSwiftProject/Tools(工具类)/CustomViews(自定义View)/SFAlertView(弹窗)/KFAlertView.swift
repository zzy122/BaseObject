//
//  KFAlertView.swift
//  SmallSheep
//
//  Created by KF001 on 2018/9/10.
//  Copyright © 2018年 KFZS. All rights reserved.
//

import UIKit

class KFAlertView: UIView{
    //定义block
    typealias ClickIndex = (Int) -> Void
    //设置block属性
    var touchIndex:ClickIndex?
    lazy var alertView: UIView = {
        let alertView = UIView()
        alertView.backgroundColor = UIColor.white
        alertView.layer.cornerRadius = AAdaption(num: 20)
        alertView.layer.masksToBounds = true
        return alertView
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: AAdaptionRect(x: 0, y: 60, width: 587, height: 36))
        label.textColor = "333333".zzy.hexToColor()
        label.font = BoldFont(font: 32)
        label.textAlignment = .center
        return label
    }()
    lazy var textView: UITextView = {
        let textV = UITextView(frame: AAdaptionRect(x: 23, y: 120, width: 543, height: 210))
        textV.isEditable = false
        textV.textColor = "666666".zzy.hexToColor()
        textV.font = AAFont(font: 26)
        textV.isScrollEnabled = true
        return textV
    }()
    lazy var cancleBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = "EBEBEB".zzy.hexToColor()
        btn.setTitleColor("4889FF".zzy.hexToColor(), for: .normal)
        btn.titleLabel?.font = AAFont(font: 28)
        btn.addTarget(self, action: #selector(cancleClick), for: .touchUpInside)
        return btn
    }()
    lazy var sureBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = "EBEBEB".zzy.hexToColor()
        btn.setTitleColor("4889FF".zzy.hexToColor(), for: .normal)
        btn.titleLabel?.font = AAFont(font: 28)
        btn.addTarget(self, action: #selector(sureClick), for: .touchUpInside)
        return btn
    }()
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = "666666".zzy.hexToColor()
        label.font = AAFont(font: 27)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    lazy var backImageV:UIImageView = {
        let iv = UIImageView()
        iv.image = imageName(name: "更新组1")
        self.alertView.insertSubview(iv, at: 0)
        return iv
    }()
    /// html标签页（专用于更新提示）弹窗
    ///
    /// - Parameters:
    ///   - title: 题目
    ///   - message: 内容
    //isShowBack:显示背景图
    ///   - cancelBtnTitle: 取消按钮title
    ///   - sureBtnTitle: 确定按钮title
    ///   - touchIndex: block传出去点击按钮的index
    public func showAttrbuteAlertView(title:String?, message:String?, cancelBtnTitle:String?,sureBtnTitle:String?, touchIndex:@escaping ClickIndex) {
        self.frame = (UIApplication.shared.keyWindow?.bounds)!
        self.backgroundColor = "000000".zzy.hexToColor(alpha: 0.6)
        UIApplication.shared.keyWindow?.addSubview(self)
        self.touchIndex = touchIndex
        self.setupViews()
    
        self.alertView.addSubview(self.textView)
        titleLabel.text = title
       
        if cancelBtnTitle != nil {
            self.alertView.addSubview(self.cancleBtn)
            cancleBtn.snp.makeConstraints { (make) in
                make.right.bottom.equalToSuperview()
                make.width.equalTo(AAdaption(num: 294))
                make.height.equalTo(AAdaption(num: 89))
            }
            sureBtn.snp.remakeConstraints { (make) in
                make.bottom.left.equalToSuperview()
                make.width.equalTo(AAdaption(num: 294))
                make.height.equalTo(AAdaption(num: 89))
            }
            sureBtn.setTitleColor("FF2D4B".zzy.hexToColor(), for: .normal)
            cancleBtn.setTitle(cancelBtnTitle, for: .normal)
        }
        sureBtn.setTitle(sureBtnTitle, for: .normal)
        //将html标签用富文本显示
        do {
            guard let content = message else {return}
            let srtData = content.data(using: String.Encoding.unicode, allowLossyConversion: true)!
            let strOptions = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
            let attrStr = try NSAttributedString(data: srtData, options: strOptions, documentAttributes: nil)
            self.textView.attributedText = attrStr
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        self.showAnimation(animationView: self.alertView)
    }
    /// 版本更新
    ///
    /// - Parameters:
    ///   - title: 题目
    ///   - message: 内容
    ///   - cancelBtnTitle: 取消按钮title
    ///   - sureBtnTitle: 确定按钮title
    ///   - touchIndex: block传出去点击按钮的index
    public func showUpdateAttrbuteAlertView(title:String?, message:String?, cancelBtnTitle:String?,sureBtnTitle:String?,touchIndex:@escaping ClickIndex) {
        self.frame = (UIApplication.shared.keyWindow?.bounds)!
        self.backgroundColor = "000000".zzy.hexToColor(alpha: 0.6)
        UIApplication.shared.keyWindow?.addSubview(self)
        self.touchIndex = touchIndex
        self.addSubview(self.alertView)
        self.alertView.addSubview(self.titleLabel)
        self.alertView.addSubview(self.sureBtn)
        alertView.snp.remakeConstraints { (make) in
            make.width.equalTo(AAdaption(num: 587))
            make.center.equalToSuperview()
            make.height.equalTo(AAdaption(num: 675))
        }
        sureBtn.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(AAdaption(num: 89))
        }
        
        alertView.backgroundColor = UIColor.clear
        textView.backgroundColor = UIColor.clear
        self.alertView.addSubview(self.textView)
        titleLabel.text = title
        self.backImageV.isHidden = false
        self.backImageV.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalToSuperview()
        }
        
        if cancelBtnTitle != nil {
            self.alertView.addSubview(self.cancleBtn)
            cancleBtn.snp.makeConstraints { (make) in
                make.right.bottom.equalToSuperview()
                make.width.equalTo(AAdaption(num: 294))
                make.height.equalTo(AAdaption(num: 89))
            }
            sureBtn.snp.remakeConstraints { (make) in
                make.bottom.left.equalToSuperview()
                make.width.equalTo(AAdaption(num: 294))
                make.height.equalTo(AAdaption(num: 89))
            }
            sureBtn.setTitleColor("FF2D4B".zzy.hexToColor(), for: .normal)
            cancleBtn.setTitle(cancelBtnTitle, for: .normal)
        }
        sureBtn.setTitle(sureBtnTitle, for: .normal)
        //将html标签用富文本显示
        do {
            guard let content = message else {return}
            let srtData = content.data(using: String.Encoding.unicode, allowLossyConversion: true)!
            let strOptions = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
            let attrStr = try NSAttributedString(data: srtData, options: strOptions, documentAttributes: nil)
            self.textView.attributedText = attrStr
            self.textView.frame = AAdaptionRect(x: 23, y: 240, width: 543, height: 300)
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        self.showAnimation(animationView: self.alertView)
    }
    /// 普通的弹出提示框
    ///
    /// - Parameters:
    ///   - title: 题目
    ///   - message: 内容
    ///   - cancelBtnTitle: 取消按钮title
    ///   - sureBtnTitle: 确定按钮title
    ///   - touchIndex: block传出去点击按钮的index
    public func showAlertView(title:String?, message:String?, cancelBtnTitle:String?,sureBtnTitle:String?, touchIndex:@escaping ClickIndex) {
        self.frame = (UIApplication.shared.keyWindow?.bounds)!
        self.backgroundColor = "000000".zzy.hexToColor(alpha: 0.6)
        UIApplication.shared.keyWindow?.addSubview(self)
        self.touchIndex = touchIndex
        self.setupViews()
        self.alertView.addSubview(self.contentLabel)
        titleLabel.text = title
        if cancelBtnTitle != nil {
            self.alertView.addSubview(self.cancleBtn)
            cancleBtn.snp.makeConstraints { (make) in
                make.right.bottom.equalToSuperview()
                make.width.equalTo(AAdaption(num: 294))
                make.height.equalTo(AAdaption(num: 89))
            }
            sureBtn.snp.remakeConstraints { (make) in
                make.bottom.left.equalToSuperview()
                make.width.equalTo(AAdaption(num: 294))
                make.height.equalTo(AAdaption(num: 89))
            }
            sureBtn.setTitleColor("FF2D4B".zzy.hexToColor(), for: .normal)
            cancleBtn.setTitle(cancelBtnTitle, for: .normal)
        }
        sureBtn.setTitle(sureBtnTitle, for: .normal)
        self.contentLabel.text = message
        //计算message文本高度
        let messageH = message!.zzy.caculateHeight(font: AAFont(font: 27), width: AAdaption(num: 534), lineSpace: 3)
        self.contentLabel.frame = AAdaptionRect(x: 40, y: 120, width: 534, height: messageH/AAdaptionWidth())
        alertView.snp.remakeConstraints { (make) in
            make.width.equalTo(AAdaption(num: 587))
            make.center.equalToSuperview()
            make.height.equalTo(AAdaption(num: 227)+messageH)
        }
        self.showAnimation(animationView: self.alertView)
    }
    // MARK: - 添加视图并设置约束
    private func setupViews(){
        self.addSubview(self.alertView)
        self.alertView.addSubview(self.titleLabel)
        self.alertView.addSubview(self.sureBtn)
        alertView.snp.remakeConstraints { (make) in
            make.width.equalTo(AAdaption(num: 587))
            make.center.equalToSuperview()
            make.height.equalTo(AAdaption(num: 435))
        }
        sureBtn.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(AAdaption(num: 89))
        }
    }
    @objc func cancleClick(){
        self.removeFromSuperview()
        self.touchIndex!(0)
    }
    @objc func sureClick(){
        self.removeFromSuperview()
        self.touchIndex!(1)
    }
    //设置动画
    func showAnimation(animationView : UIView) {
        // 第一步：将view宽高缩至无限小（点）
        animationView.transform = CGAffineTransform.init(scaleX: CGFloat.leastNormalMagnitude, y: CGFloat.leastNormalMagnitude)
        UIView.animate(withDuration: 0.3, animations: {
            // 第二步： 以动画的形式将view慢慢放大至原始大小的1.2倍
            animationView.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
        }) { (finished) in
            UIView.animate(withDuration: 0.2, animations: {
                // 第三步： 以动画的形式将view恢复至原始大小
                animationView.transform = CGAffineTransform.identity
            })
        }
    }
    
}
