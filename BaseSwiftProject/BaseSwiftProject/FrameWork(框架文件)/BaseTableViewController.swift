//
//  BaseTableViewController.swift
//  LeShanBankSwift
//
//  Created by zzy on 2018/4/12.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
let cornerRadius:CGFloat = 10.0
class BaseTableViewController: BaseViewController,UITableViewDelegate, UITableViewDataSource {
    let tableView:UITableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
    //圆角大小

    //section是否为圆角
    var isSectionRadius = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.frame = self.view.bounds
        
        self.tableView.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.RawValue(UInt8(UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.RawValue(UInt8(UIView.AutoresizingMask.flexibleLeftMargin.rawValue)   | UInt8(UIView.AutoresizingMask.flexibleWidth.rawValue)
            | UInt8(UIView.AutoresizingMask.flexibleRightMargin.rawValue))).rawValue) | UInt8(UIView.AutoresizingMask.flexibleTopMargin.rawValue) |
            UInt8(UIView.AutoresizingMask.flexibleHeight.rawValue)    |
            UInt8(UIView.AutoresizingMask.flexibleBottomMargin.rawValue)))//自动布局 防止父viewsize变了之后tableview的size超出父view
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
         self.tableView.separatorColor = UIColor.gray

//        tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.tableFooterView = UIView()
        
        if #available(iOS 11.0, *)
        {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }
        self.tableView.backgroundColor = k_CustomColor(red: 240, green: 240, blue: 240)
        self.view.addSubview(self.tableView)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.frame = self.view.bounds
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension BaseTableViewController
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isSectionRadius == false
        {
            return
        }
        
        cell.backgroundColor = UIColor.white
        let shapLayer = CAShapeLayer()
        let pathRef:CGMutablePath = CGMutablePath()
        let cellBounds:CGRect = cell.bounds.insetBy(dx: 10, dy: 0)
        var addLine = false
        if indexPath.row == 0 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
        {
            pathRef.addRoundedRect(in: cellBounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
        }
        else if indexPath.row == 0
        {
            pathRef.move(to: CGPoint.init(x: cellBounds.minX, y: cellBounds.maxY))
            pathRef.addArc(tangent1End: CGPoint.init(x: cellBounds.minX, y: cellBounds.minY), tangent2End: CGPoint.init(x: cellBounds.midX, y: cellBounds.minY), radius: cornerRadius)
            pathRef.addArc(tangent1End: CGPoint.init(x: cellBounds.maxX, y: cellBounds.minY), tangent2End: CGPoint.init(x: cellBounds.maxX, y: cellBounds.midY), radius: cornerRadius)
            pathRef.addLine(to: CGPoint.init(x: cellBounds.maxX, y: cellBounds.maxY))
            addLine = true
        }
        else if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
        {
            pathRef.move(to: CGPoint.init(x: cellBounds.minX, y: cellBounds.minY))
            
            pathRef.addArc(tangent1End: CGPoint.init(x: cellBounds.minX, y: cellBounds.maxY), tangent2End: CGPoint.init(x: cellBounds.midX, y: cellBounds.maxY), radius: cornerRadius)
            pathRef.addArc(tangent1End: CGPoint.init(x: cellBounds.maxX, y: cellBounds.maxY), tangent2End: CGPoint.init(x: cellBounds.maxX, y: cellBounds.midY), radius: cornerRadius)
            pathRef.addLine(to: CGPoint.init(x: cellBounds.maxX, y: cellBounds.minY))
        }
        else
        {
            pathRef.addRect(cellBounds)
            addLine = true
        }
        shapLayer.path = pathRef
        
        let color = cell.backgroundColor ?? UIColor.white
        
        //颜色修改
//        shapLayer.fillColor = UIColor.init(white: 1.0, alpha: 0.5).cgColor
        shapLayer.fillColor = color.cgColor
        shapLayer.strokeColor = UIColor.white.cgColor
        
        if addLine {
            let lineLayer = CALayer()
            let height = 1.0 / SCALE
            lineLayer.frame = CGRect.init(x: cellBounds.minX + cornerRadius, y: cellBounds.height - height, width: cellBounds.width - cornerRadius, height: height)
            lineLayer.backgroundColor = k_CustomColor(red: 240, green: 240, blue: 240).cgColor
            shapLayer.addSublayer(lineLayer)
        }
        let backView = UIView.init(frame: cellBounds)
        backView.layer.insertSublayer(shapLayer, at: 0)
        backView.backgroundColor = k_CustomColor(red: 240, green: 240, blue: 240)
        cell.backgroundView = backView
        cell.contentView.backgroundColor = UIColor.clear

        
    }
    
}
