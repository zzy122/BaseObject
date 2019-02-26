//
//  KFTimerBtn.swift
//  SmallSheep 普通倒计时按钮
//
//  Created by kfzs on 2018/9/18.
//  Copyright © 2018年 KFZS. All rights reserved.
//

import UIKit

class KFTimerBtn: UIButton {
    var startCount:Bool = false
    var codeTimer:DispatchSourceTimer?
    private var timerCount:Int = 0
    {
        willSet {
            let titleStr:String = self.getFormatPlayTime(secounds: TimeInterval(newValue))
            setTitle(titleStr, for: .normal)
            setTitle(titleStr, for: .selected)
            if newValue <= 0 {
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func stopTimer()
    {
         self.timerCount = 0
    }
    public func startCount(count: Int,complection:@escaping () ->Void){
        // 倒计时开始,禁止点击事件

        if self.codeTimer != nil {self.codeTimer?.cancel()}
        self.timerCount = count
        isEnabled = false
        
        // 保存当前的背景颜色
//        let defaultColor = self.backgroundColor
        // 设置倒计时,按钮背景颜色
//        backgroundColor = UIColor.gray
        
        codeTimer = DispatchSource.makeTimerSource(queue:DispatchQueue.global())
        // 设定这个时间源是每秒循环一次，立即开始
        codeTimer?.schedule(deadline: .now(), repeating: .seconds(1))
        // 设定时间源的触发事件
        codeTimer?.setEventHandler(handler: {
            // 返回主线程处理一些事件，更新UI等等
            DispatchQueue.main.async {
                // 每秒计时一次
                self.timerCount -= 1
                // 时间到了取消时间源
                if self.timerCount <= 0 {
//                    self.backgroundColor = defaultColor
                    self.isEnabled = true
                    self.codeTimer?.cancel()
                    self.timerCount = 0
                    complection()
                }
            }
        })
        // 启动时间源
        
        codeTimer?.resume()
    }
    //将秒转换成时间
    func getFormatPlayTime(secounds:TimeInterval)->String{
        if secounds.isNaN{
            return "00:00"
        }
        var Min = Int(secounds / 60)
        let Sec = Int(secounds.truncatingRemainder(dividingBy: 60))
        var Hour = 0
        if Min>=60 {
            Hour = Int(Min / 60)
            Min = Min - Hour*60
            return String(format: "%02d:%02d:%02d", Hour, Min, Sec)
        }
        return String(format: "00:%02d:%02d", Min, Sec)
    }
    
}
