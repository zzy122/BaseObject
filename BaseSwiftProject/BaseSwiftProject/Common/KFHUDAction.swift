//
//  KFHUDAction.swift
//  SmallSheep
//
//  Created by kfzs on 2018/12/11.
//  Copyright © 2018 KFZS. All rights reserved.
//

import UIKit

class KFHUDAction: NSObject {
    class func showText(testStr:String,afterDeLay:Int?){
        self.showHud(type: MBProgressHUDMode.customView,bg:nil, textStr: testStr, detailStr: nil, afterDeLay: afterDeLay)
    }
    class func showProgress(bg:UIColor?, textStr:String?,detailStr:String?,afterDeLay:Int?){
        self.showHud(type: MBProgressHUDMode.indeterminate,bg:bg, textStr: textStr, detailStr: detailStr, afterDeLay: afterDeLay)
    }
    class func showHud(type:MBProgressHUDMode,bg:UIColor?,textStr:String?,detailStr:String?,afterDeLay:Int?){
        let view = viewWithShow()
        let hudTag = MBProgressHUD.showAdded(to: view, animated: true)
        hudTag.mode = type
        hudTag.label.text = textStr
        hudTag.removeFromSuperViewOnHide = true
        hudTag.detailsLabel.text = detailStr
        hudTag.show(animated: true)
        if let bgTag = bg {
            hudTag.bezelView.style = MBProgressHUDBackgroundStyle.solidColor;
            hudTag.bezelView.backgroundColor = bgTag;
        }
        if let delay = afterDeLay {
            hudTag.hide(animated: true, afterDelay: TimeInterval(delay))
        }
    }
    class func hiddenHud(){
        let view = viewWithShow()
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    private class func viewWithShow() -> UIView {
        var window = UIApplication.shared.keyWindow
        if window?.windowLevel != UIWindow.Level.normal {
            let windowArray = UIApplication.shared.windows
            for tempWin in windowArray {
                if tempWin.windowLevel == UIWindow.Level.normal {
                    window = tempWin;
                    break
                }
            }
            
        }
        return window!
    }

}
