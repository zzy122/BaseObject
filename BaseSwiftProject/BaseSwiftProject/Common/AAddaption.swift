//
//  SFAddaption.swift
//  SmallSheep
//
//  Created by KF001 on 2018/8/27.
//  Copyright © 2018年 KFZS. All rights reserved.
//

import Foundation
import UIKit
//UI设计图尺寸
let kBasewidth : CGFloat = 375.00
let kBaseHeight : CGFloat = 667.00

//适配基础比例
func AAdaptionWidth() -> CGFloat {
    return (ScreenWidth/kBasewidth)
}

func AAdaption(num : CGFloat) -> CGFloat {
    return num * AAdaptionWidth();
}

func AAdaptionSize(width : CGFloat,height : CGFloat) -> CGSize{
    let newWidth = width * AAdaptionWidth()
    let newHeight = height * AAdaptionWidth()
    return CGSize(width: newWidth, height: newHeight)
}

func AAadaptionPoint(x : CGFloat,y : CGFloat) -> CGPoint{
    let newX = x * AAdaptionWidth()
    let newY = y * AAdaptionWidth()
    return CGPoint(x: newX, y: newY)
}

func AAdaptionRect(x : CGFloat,y : CGFloat,width: CGFloat,height: CGFloat) -> CGRect{
    let newX = x * AAdaptionWidth()
    let newY = y * AAdaptionWidth()
    let newWidth = width * AAdaptionWidth()
    let newHeight = height * AAdaptionWidth()
    return CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
}

func AAFont(font: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: font*AAdaptionWidth())
}

func BoldFont(font: CGFloat) -> UIFont {
    return UIFont.boldSystemFont(ofSize: font*AAdaptionWidth())
}
