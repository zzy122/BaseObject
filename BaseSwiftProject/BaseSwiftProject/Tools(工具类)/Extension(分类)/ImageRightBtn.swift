//
//  ImageRightBtn.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/7.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class ImageRightBtn: UIButton {
    var leftTitie:Bool = false
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if leftTitie {
            self.titleLabel?.frame.origin.x = 0
            self.imageView?.frame.origin.x = (self.titleLabel?.frame.width)!
        }
    }
    
    
    
}
