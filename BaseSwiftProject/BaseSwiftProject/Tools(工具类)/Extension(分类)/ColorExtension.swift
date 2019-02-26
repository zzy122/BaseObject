//
//  ColorExtension.swift
//  SmallSheep
//
//  Created by kfzs on 2019/1/25.
//  Copyright © 2019 KFZS. All rights reserved.
//

import UIKit
extension GeneralExt where Base == UIColor{
    func colorWithImage() ->UIImage{
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(base.cgColor);
        context.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

