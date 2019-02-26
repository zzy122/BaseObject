//
//  CustomProtocol.swift
//
//  Created by zzy on 2018/5/15.
//  Copyright © 2018年 zzy. All rights reserved.
//

import Foundation
import UIKit
protocol ResponderRouter {
    func interceptRoute(name:String,objc:UIResponder?,info:Any?)
}

