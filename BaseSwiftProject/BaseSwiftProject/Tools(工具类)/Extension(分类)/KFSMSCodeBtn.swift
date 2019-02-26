
//
//  KFSMSCodeBtn.swift
//  SmallSheep 验证码倒计时按钮
//
//  Created by kfzs on 2018/9/18.
//  Copyright © 2018年 KFZS. All rights reserved.
//

import UIKit

class KFSMSCodeBtn: UIButton {
    var endTitle : String?
    
    private var timerCount:Int = 0
    {
        willSet {
            if endTitle == nil {
                setTitle("\(newValue)秒后重新发送", for: .normal)
                setTitle("\(newValue)秒后重新发送", for: .selected)
            }else{
                setTitle("知道了(\(newValue))", for: .normal)
            }
            if newValue <= 0 {
                if endTitle == nil{
                    setTitle("重新获取", for: .normal)
                }else{
                    setTitle(endTitle, for: .normal)
                }
            }
        }
    }
    public func countDown(count: Int,textFont : UIFont? = nil,bgColor : UIColor? = nil){
        // 倒计时开始,禁止点击事件
        self.timerCount = count
        isEnabled = false
        
        // 保存当前的背景颜色
        let defaultColor = self.backgroundColor
        
        let defaultFont = self.titleLabel?.font
        let defaultTitleColor = self.titleLabel?.textColor
        // 设置倒计时,按钮背景颜色
        backgroundColor = (bgColor == nil) ? k_CustomColor(red: 230, green: 230, blue: 230) : bgColor
        self.titleLabel?.font = (textFont == nil) ? kFont_system10 : textFont
        self.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
        // 在global线程里创建一个时间源
        let codeTimer = DispatchSource.makeTimerSource(queue:DispatchQueue.global())
        // 设定这个时间源是每秒循环一次，立即开始
        codeTimer.schedule(deadline: .now(), repeating: .seconds(1))
        // 设定时间源的触发事件
        codeTimer.setEventHandler(handler: {
            // 返回主线程处理一些事件，更新UI等等
            DispatchQueue.main.async {
                // 每秒计时一次
                self.timerCount -= 1
                // 时间到了取消时间源
                if self.timerCount <= 0 {
                    self.backgroundColor = defaultColor
                    self.setTitleColor(defaultTitleColor, for: UIControl.State.normal)
                    self.titleLabel?.font = defaultFont
                    self.isEnabled = true
                    codeTimer.cancel()
                    self.timerCount = 0
                }
            }
        })
        // 启动时间源
        codeTimer.resume()
    }
    public func cancelTimer()
    {
        self.timerCount = 0
        isEnabled = true
    }
}
