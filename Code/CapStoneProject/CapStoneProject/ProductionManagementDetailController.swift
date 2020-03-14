//
//  ProductionManagementController.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/6.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit

var productionManagementProductList: [String] = []
var productionManagementAreaList: [String] = []

class ProductionManagementDetailController: UIViewController {

    var mPresenter = ProductionManagementDetailModel()
    
    @IBOutlet weak var baseScrollView: UIScrollView!
    @IBOutlet weak var label_productionManagementInfo: UILabel!
    @IBOutlet weak var stack_productTable: UIStackView!
    @IBOutlet weak var scroll_productTable: UIScrollView!
    @IBOutlet weak var stack_areaTable: UIStackView!
    @IBOutlet weak var scroll_areaTable: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter.mView = self
        mPresenter.getInfo()
    }
}

extension ProductionManagementDetailController: ProductionManagementDetailView {
    func setBusinessInfo(businessInfo: String) {
        label_productionManagementInfo.text = businessInfo
        label_productionManagementInfo.backgroundColor = .systemBackground
//        label_productionManagementInfo.layer.masksToBounds = true
//        label_productionManagementInfo.layer.cornerRadius = 5
    }
    
    func setProductTable() {
        if productionManagementProductList.count != 0 {
            let mst = MyScrollTable(rootView: scroll_productTable, type: .production)
            for i in 0..<productionManagementProductList.count {
                mst.add(unitFormat(productionManagementProductList[i]))
            }
            mst.finish()
        }
        else {
            stack_productTable.alpha = 0
            scroll_productTable.alpha = 0
            stack_areaTable.superview?.addConstraint(NSLayoutConstraint(item: stack_areaTable, attribute: .top, relatedBy: .equal, toItem: stack_productTable, attribute: .top, multiplier: 1.0, constant: 0))
        }
    }
    
    func setAreaTable() {
        if productionManagementAreaList.count != 0 {
            let mst = MyScrollTable(rootView: scroll_areaTable, type: .production)
            for i in 0..<productionManagementAreaList.count {
                mst.add(unitFormat(productionManagementAreaList[i]))
            }
            mst.finish()
        }
        else {
            stack_areaTable.removeFromSuperview()
            scroll_areaTable.removeFromSuperview()
        }
    }
}
