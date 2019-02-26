//
//  ImageExtension.swift
//  SmallSheep
//
//  Created by kfzs on 2018/8/9.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

extension UIImageView
{
    func sd_DownLoadImage(url:String,placeholder:String?,completed:(SDExternalCompletionBlock)? = nil){
//        self.backgroundColor = UIColor.white
        self.sd_setImage(with: URL.init(string: url), placeholderImage: imageName(name: placeholder ?? "zhanwei_fang"), options: SDWebImageOptions.cacheMemoryOnly, completed: completed)

    }
    
}





extension GeneralExt where Base == UIImage{
    /// 压缩图片到指定大小
    public func compress(toTargetSize size: CGSize =  CGSize(width: 480, height: 640)) -> UIImage? {
        let size = size
        var newImage: UIImage? = nil
        let imageSize = base.size
        let width = imageSize.width
        let height = imageSize.height
        let twidth = size.width
        let theight = size.height
        var point = CGPoint(x: 0, y: 0)
        var scaleFactor: CGFloat = 0.0
        var sacaledWidth = twidth
        var scaledHeight = theight
        
        if imageSize != size {
            let widthFactor: CGFloat = twidth / width
            let heightFactor: CGFloat = height / width
            scaleFactor = max(widthFactor, heightFactor)
            
            sacaledWidth = width * scaleFactor
            scaledHeight = height * scaleFactor
            
            if widthFactor > heightFactor { point.y = (theight - scaledHeight) * 0.5 }
            else if widthFactor < heightFactor { point.x = (twidth - sacaledWidth) * 0.5 }
        }
        
        UIGraphicsBeginImageContext(size)
        var thumbnailRect = CGRect.zero;
        thumbnailRect.origin = point;
        thumbnailRect.size.width = sacaledWidth;
        thumbnailRect.size.height = scaledHeight;
        base.draw(in: thumbnailRect)
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
